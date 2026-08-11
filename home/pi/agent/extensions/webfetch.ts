/**
 * WebFetch Extension
 * Fetch web content in text, markdown, or HTML format.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

function errorResult(message: string) {
  return {
    content: [{ type: "text" as const, text: `Error: ${message}` }],
    details: {},
    isError: true,
  };
}

const MAX_SIZE = 5 * 1024 * 1024;
const DEFAULT_TIMEOUT = 30;
const MAX_TIMEOUT = 120;

function stripScriptsAndStyles(html: string): string {
  return html
    .replace(/<script[^>]*>[\s\S]*?<\/script>/gi, "")
    .replace(/<style[^>]*>[\s\S]*?<\/style>/gi, "");
}

function extractTextFromHTML(html: string): string {
  return stripScriptsAndStyles(html)
    .replace(/<[^>]+>/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function convertHTMLToMarkdown(html: string): string {
  let md = stripScriptsAndStyles(html);
  // Headers
  md = md.replace(/<h1[^>]*>([\s\S]*?)<\/h1>/gi, "# $1\n\n");
  md = md.replace(/<h2[^>]*>([\s\S]*?)<\/h2>/gi, "## $1\n\n");
  md = md.replace(/<h3[^>]*>([\s\S]*?)<\/h3>/gi, "### $1\n\n");
  md = md.replace(/<h4[^>]*>([\s\S]*?)<\/h4>/gi, "#### $1\n\n");
  md = md.replace(/<h5[^>]*>([\s\S]*?)<\/h5>/gi, "##### $1\n\n");
  md = md.replace(/<h6[^>]*>([\s\S]*?)<\/h6>/gi, "###### $1\n\n");
  // Bold and italic
  md = md.replace(/<strong[^>]*>([\s\S]*?)<\/strong>/gi, "**$1**");
  md = md.replace(/<b[^>]*>([\s\S]*?)<\/b>/gi, "**$1**");
  md = md.replace(/<em[^>]*>([\s\S]*?)<\/em>/gi, "*$1*");
  md = md.replace(/<i[^>]*>([\s\S]*?)<\/i>/gi, "*$1*");
  // Code
  md = md.replace(/<code[^>]*>([\s\S]*?)<\/code>/gi, "`$1`");
  md = md.replace(/<pre[^>]*>([\s\S]*?)<\/pre>/gi, "```\n$1\n```\n");
  // Links
  md = md.replace(/<a[^>]+href="([^"]*)"[^>]*>([\s\S]*?)<\/a>/gi, "[$2]($1)");
  // Images
  md = md.replace(
    /<img[^>]+src="([^"]*)"[^>]*alt="([^"]*)"[^>]*\/?>/gi,
    "![$2]($1)",
  );
  md = md.replace(/<img[^>]+src="([^"]*)"[^>]*\/?>/gi, "![]($1)");
  // Lists
  md = md.replace(/<li[^>]*>([\s\S]*?)<\/li>/gi, "- $1\n");
  md = md.replace(/<\/?[ou]l[^>]*>/gi, "\n");
  // Paragraphs and breaks
  md = md.replace(/<br\s*\/?>/gi, "\n");
  md = md.replace(/<p[^>]*>([\s\S]*?)<\/p>/gi, "$1\n\n");
  // Blockquotes
  md = md.replace(/<blockquote[^>]*>([\s\S]*?)<\/blockquote>/gi, "> $1\n");
  // Remove remaining tags
  md = md.replace(/<[^>]+>/g, "");
  // Decode HTML entities
  md = md.replace(/&amp;/g, "&");
  md = md.replace(/&lt;/g, "<");
  md = md.replace(/&gt;/g, ">");
  md = md.replace(/&quot;/g, '"');
  md = md.replace(/&#39;/g, "'");
  md = md.replace(/\n{3,}/g, "\n\n");
  return md.trim();
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "webfetch",
    label: "Web Fetch",
    description: "Fetch web content from URL. Returns text, markdown, or HTML.",
    parameters: Type.Object({
      url: Type.String({ description: "URL to fetch (http/https only)" }),
      format: Type.Union([
        Type.Literal("text"),
        Type.Literal("markdown"),
        Type.Literal("html"),
      ], { description: "Output format (default: markdown)" }),
      timeout: Type.Optional(Type.Number({ description: "Timeout in seconds (max 120)", minimum: 1, maximum: 120 })),
    }),
    async execute(_toolCallId, params, signal, _onUpdate, _ctx) {
      const { url, format, timeout } = params;

      // Validate URL
      if (!/^https?:\/\//.test(url)) {
        return errorResult("URL must start with http:// or https://");
      }

      // Set timeout
      const timeoutMs =
        Math.min(timeout ?? DEFAULT_TIMEOUT, MAX_TIMEOUT) * 1000;

      try {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

        // Combine external signal with our timeout
        const combinedSignal = signal
          ? AbortSignal.any([signal, controller.signal])
          : controller.signal;

        const response = await fetch(url, {
          signal: combinedSignal,
          headers: {
            "User-Agent": "pi-webfetch/1.0",
          },
          redirect: "follow",
        });

        clearTimeout(timeoutId);

        if (!response.ok) {
          return errorResult(`Request failed with status code: ${response.status}`);
        }

        // Read body with size limit
        const reader = response.body?.getReader();
        if (!reader) {
          return errorResult("Could not read response body");
        }

        const chunks: Uint8Array[] = [];
        let totalSize = 0;

        while (true) {
          const { done, value } = await reader.read();
          if (done) break;
          totalSize += value.length;
          if (totalSize > MAX_SIZE) {
            return errorResult("Response exceeds 5MB size limit");
          }
          chunks.push(value);
        }

        const content = new TextDecoder().decode(Buffer.concat(chunks));
        const contentType = response.headers.get("content-type") ?? "";

        let result: string;

        switch (format) {
          case "text":
            if (contentType.includes("text/html")) {
              result = extractTextFromHTML(content);
            } else {
              result = content;
            }
            break;

          case "markdown":
            result = contentType.includes("text/html")
              ? convertHTMLToMarkdown(content)
              : "```\n" + content + "\n```";
            break;

          case "html":
          default:
            result = content;
        }

        return {
          content: [{ type: "text", text: result }],
          details: {
            url,
            format,
            contentType,
            size: totalSize,
          },
        };
      } catch (error: any) {
        return errorResult(error.name === "AbortError" ? "Request timed out" : error.message);
      }
    },
  });
}
