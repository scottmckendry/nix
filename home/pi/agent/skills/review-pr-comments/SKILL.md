---
name: review-pr-comments
description: "Reviews and addresses unresolved PR review comments on the current GitHub branch. For each unresolved thread: reads full context, implements clear/actionable comments, replies and resolves via gh CLI. Skips ambiguous, debatable, or already-addressed comments."
disable-model-invocation: true
---

# Review PR Comments

Fetches the current PR number, then reviews and addresses unresolved review threads.

## Usage

Run via `/skill:review-pr-comments` or ask pi to review PR comments.

## Steps

1. Get PR number: `gh pr view --json number --jq .number`
2. For each unresolved thread:
   - Reads full thread including replies
   - If actionable and technically valid: implements change, leaves unstaged, replies with one sentence, resolves via `gh`
   - If ambiguous/debatable/already addressed: skips (does not resolve)
