#!/bin/zsh
# Day Desk GitHub sync: your open PRs in the isapp org, plus every open PR in isapp/ht-design, as one JSON doc.
# Usage: sync/github-prs.sh [out.json]   (default: sync/.github-prs.json, git-ignored)
set -euo pipefail
OUT="${1:-${0:A:h}/.github-prs.json}"
F=repository,number,title,url,updatedAt,isDraft,author
q() { gh search prs --owner isapp --state open --limit 30 --json $F "$@"; }
jq -n \
  --argjson mine   "$(q --author @me)" \
  --argjson review "$(q --review-requested @me)" \
  --argjson ment   "$(q --mentions @me)" \
  --argjson repo   "$(gh pr list -R isapp/ht-design --state open --limit 50 --json number,title,url,updatedAt,isDraft,author)" \
  --arg at "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '
  def row($why): { repo: .repository.name, number, title, url, updatedAt, draft: .isDraft, author: .author.login, why: $why };
  ([$review[] | row("review")] + [$mine[] | row("mine")] + [$ment[] | row("mention")]
   + [$repo[] | {repository: {name: "ht-design"}} + . | row("repo")])
  | unique_by(.url) as $all
  | { syncedAt: $at, prs: ($all | sort_by(.updatedAt) | reverse) }' > "$OUT"
echo "$OUT"
