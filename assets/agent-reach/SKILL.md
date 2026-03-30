---
name: agent-reach
description: Give Ava internet browsing superpowers. Read Twitter, YouTube, GitHub, Reddit, Bilibili, XiaoHongShu, WeChat — zero API fees. Use when user asks to search social media, read articles, watch videos, or browse the web.
compatibility: Requires agent-reach CLI installed
metadata:
  author: Panniantong
  version: 1.3.0
---

# Agent-Reach — Ava's Internet Eyes

## When to Use

User asks to:
- "Check Twitter for..."
- "Read this Reddit thread..."
- "What does this YouTube video say?"
- "Search 小红书 for..."
- "Read this webpage..."
- "Search the web for..."

## Quick Commands

### Read Any Webpage
```bash
curl https://r.jina.ai/URL
```

### YouTube Video
```bash
yt-dlp --dump-json "YOUTUBE_URL" | jq '.title, .description, .subtitles'
```

### GitHub Repo
```bash
gh repo view owner/repo
gh search repos "query" --limit 10
```

### Semantic Web Search (FREE)
```bash
mcporter call 'exa.search(query: "your search", numResults: 5)'
```

### Check Status
```bash
agent-reach doctor
```

## Configure More Platforms

| Platform | Command |
|----------|---------|
| Twitter | `agent-reach configure twitter-cookies "auth_token=xxx; ct0=yyy"` |
| Proxy (for Reddit/Bilibili on servers) | `agent-reach configure proxy http://user:pass@ip:port` |
| XiaoHongShu | `docker run -d --name xiaohongshu-mcp -p 18060:18060 xpzouying/xiaohongshu-mcp` |

## Status Check

Run `agent-reach doctor` to see which platforms are working.
