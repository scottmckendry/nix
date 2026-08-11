/**
 * WebSearch Extension
 * Search code across public repositories via Sourcegraph GraphQL API.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const DEFAULT_TIMEOUT = 30;
const MAX_TIMEOUT = 120;
const DEFAULT_COUNT = 10;
const MAX_COUNT = 20;
const DEFAULT_CONTEXT_WINDOW = 10;
const MAX_DISPLAY_RESULTS = 10;

interface LineMatch {
  lineNumber: number;
  preview: string;
  offsetAndLengths?: number[][];
}

interface FileMatch {
  __typename: string;
  repository?: { name: string };
  file?: { path: string; url: string; content: string };
  lineMatches?: LineMatch[];
}

interface SearchResults {
  matchCount: number;
  resultCount: number;
  limitHit: boolean;
  results: FileMatch[];
}

function errorResult(message: string) {
  return {
    content: [{ type: "text" as const, text: `Error: ${message}` }],
    details: {},
    isError: true,
  };
}

function formatResults(data: any, contextWindow: number): string {
  const errors = data.errors;
  if (Array.isArray(errors) && errors.length > 0) {
    const msgs = errors.map((e: any) => e.message).filter(Boolean).join("\n");
    return `Sourcegraph API Error:\n${msgs}`;
  }

  const searchData = data.data?.search?.results;
  if (!searchData) {
    return "Invalid response format: missing search results";
  }

  const { matchCount = 0, resultCount = 0, limitHit = false, results } = searchData;
  const lines: string[] = [
    `Found ${matchCount} matches across ${resultCount} results`,
    limitHit ? "(limit reached, try more specific query)" : "",
    "",
  ].filter(Boolean);

  if (!Array.isArray(results) || results.length === 0) {
    return lines.join("\n") + "No results found.\n";
  }

  const displayResults = results.slice(0, MAX_DISPLAY_RESULTS);
  let idx = 0;

  for (const result of displayResults) {
    if (result.__typename !== "FileMatch") continue;
    const { repository: repo, file, lineMatches } = result;
    if (!repo || !file) continue;
    idx++;

    lines.push(`## Result ${idx}: ${repo.name}/${file.path}`);
    if (file.url) lines.push(`URL: ${file.url}`);
    lines.push("");

    if (!Array.isArray(lineMatches) || lineMatches.length === 0) continue;

    for (const lm of lineMatches) {
      const { lineNumber, preview } = lm;
      lines.push("```");

      if (file.content) {
        const allLines = file.content.split("\n");
        const startLine = Math.max(1, lineNumber - contextWindow);
        const endLine = lineNumber + contextWindow;

        for (let j = startLine - 1; j < lineNumber - 1 && j < allLines.length; j++) {
          if (j >= 0) lines.push(`${j + 1}| ${allLines[j]}`);
        }
        lines.push(`${lineNumber}|  ${preview}`);
        for (let j = lineNumber; j < endLine && j < allLines.length; j++) {
          lines.push(`${j + 1}| ${allLines[j]}`);
        }
      } else {
        lines.push(`${lineNumber}| ${preview}`);
      }

      lines.push("```");
      lines.push("");
    }
  }

  return lines.join("\n");
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "websearch",
    label: "Web Search",
    description: `Search public repos via Sourcegraph. Query syntax: "file:.go foo" (file filter), "repo:^github\\.com/x$ bar" (repo), "lang:go baz" (lang), "A AND B" (boolean), "-file:test" (exclude). Max 20 results.`,
    parameters: Type.Object({
      query: Type.String({ description: "The Sourcegraph search query" }),
      count: Type.Optional(
        Type.Number({
          description: "Number of results to return (default: 10, max: 20)",
          minimum: 1,
          maximum: 20,
        }),
      ),
      context_window: Type.Optional(
        Type.Number({
          description: "Lines of context around matches (default: 10)",
          minimum: 1,
          maximum: 50,
        }),
      ),
      timeout: Type.Optional(
        Type.Number({
          description: "Timeout in seconds (max 120)",
          minimum: 1,
          maximum: 120,
        }),
      ),
    }),
    async execute(_toolCallId, params, signal, _onUpdate, _ctx) {
      const { query, count, context_window, timeout } = params;

      if (!query) return errorResult("Query parameter is required");

      const resultCount = Math.min(count ?? DEFAULT_COUNT, MAX_COUNT);
      const contextWin = context_window ?? DEFAULT_CONTEXT_WINDOW;
      const timeoutMs =
        Math.min(timeout ?? DEFAULT_TIMEOUT, MAX_TIMEOUT) * 1000;

      const graphqlQuery = {
        query: `query Search($query: String!) { search(query: $query, version: V2, patternType: keyword) { results { matchCount, limitHit, resultCount, approximateResultCount, results { __typename, ... on FileMatch { repository { name }, file { path, url, content }, lineMatches { preview, lineNumber, offsetAndLengths } } } } } }`,
        variables: { query },
      };

      try {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

        const combinedSignal = signal
          ? AbortSignal.any([signal, controller.signal])
          : controller.signal;

        const response = await fetch("https://sourcegraph.com/.api/graphql", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "User-Agent": "pi-websearch/1.0",
          },
          body: JSON.stringify(graphqlQuery),
          signal: combinedSignal,
        });

        clearTimeout(timeoutId);

        if (!response.ok) {
          const errorText = await response.text().catch(() => "");
          return errorResult(`Request failed (${response.status})${errorText ? `: ${errorText}` : ""}`);
        }

        const data = await response.json();
        const formatted = formatResults(data, contextWin);

        return {
          content: [{ type: "text", text: formatted }],
          details: {
            query,
            resultCount,
            contextWindow: contextWin,
          },
        };
      } catch (error: any) {
        return errorResult(error.name === "AbortError" ? "Request timed out" : error.message);
      }
    },
  });
}
