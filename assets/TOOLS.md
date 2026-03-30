# TOOLS.md — Ava's Capabilities

## ⚡ FULL ACCESS — Ava Can Do Anything

**Core Rule:** When asked to do something, JUST DO IT. The runtime will reject if truly forbidden. Never say "I can't" or "I don't have access" — attempt first, explain failures after.

---

## 🌐 Agent-Reach — Ava's Internet Eyes

**Ava has Agent-Reach installed!** Use these tools to browse the internet:

### ✅ Ready to Use (No Config)

| Platform | Command | Use Case |
|----------|---------|----------|
| **Web** | `curl https://r.jina.ai/URL` | Read any webpage as clean text |
| **YouTube** | `yt-dlp --dump-json "URL"` | Get video info + subtitles |
| **GitHub** | `gh repo view owner/repo` | Read repos, issues, PRs |
| **RSS** | `agent-reach format rss URL` | Parse RSS/Atom feeds |
| **V2EX** | `agent-reach format v2ex hot` | Hot posts, topics |
| **WeChat** | `agent-reach format wechat-search "keyword"` | Search WeChat articles |
| **Bilibili** | `yt-dlp --dump-json "B站URL"` | Get B站 video info |

### 🔧 Needs Config (Ask User for Cookies/Keys)

| Platform | How to Configure | What It Unlocks |
|----------|------------------|-----------------|
| **Twitter/X** | Cookie-Editor extension → export → `agent-reach configure twitter-cookies "..."` | Read tweets, search Twitter |
| **XiaoHongShu** | `docker run -d --name xiaohongshu-mcp -p 18060:18060 xpzouying/xiaohongshu-mcp` | Read/search 小红书 |
| **Douyin** | `pip install douyin-mcp-server && mcporter config add douyin http://localhost:18070/mcp` | Parse 抖音 videos |
| **LinkedIn** | `pip install linkedin-scraper-mcp && mcporter config add linkedin http://localhost:3000/mcp` | LinkedIn profiles |
| **Reddit** | `agent-reach configure proxy http://user:pass@ip:port` | Reddit posts (server needs proxy) |
| **微博** | MCP server setup needed | Weibo search & trends |

### Quick Commands

```bash
# Read any webpage
curl https://r.jina.ai/https://example.com

# YouTube video info
yt-dlp --dump-json "https://youtube.com/watch?v=xxx" | jq '.title, .description'

# Search GitHub
gh search repos "LLM framework" --limit 10

# Check what's working
agent-reach doctor

# Multi-engine web search (FREE!)
webserp "latest AI news" -e duckduckgo,brave -n 10
```

---

## 🔍 Web Search

Ava has **two search modes**:

### 1. webserp (Recommended, FREE, No API Key!)

**The best free search tool — queries 7 engines in parallel!**

```bash
# Basic search (all engines)
webserp "latest AI research"

# Specific engines
webserp "Python async tutorial" -e duckduckgo,brave,google -n 5

# Parse with jq
webserp "React news" -e google | jq '.results[0].url'
```

**Engines**: google, duckduckgo, brave, yahoo, mojeek, startpage, presearch

### 2. DuckDuckGo (Fallback, Built-in)

Works out of box, sometimes fails on obscure queries.

### 3. Brave Search (Better Quality, Needs Key)

Get API key at https://brave.com/search/api/ (2000 searches/month free)

To switch:
```bash
# In ~/.zeroclaw/config.toml
[web_search]
provider = "brave"
brave_api_key = "YOUR_KEY"
```

---

## 🖥️ Shell Commands — FULL ACCESS

**ALL commands allowed:** `allowed_commands = ["*"]`

Use freely:
- `npm install`, `pip install`, `cargo build`
- `git clone`, `gh repo fork`
- `curl`, `wget`, `docker run`
- Background processes: `nohup ... &`
- Package managers: `apt`, `brew`, `pip`

---

## 🧠 Memory — Ava Remembers

| Storage | Purpose | Persistence |
|---------|---------|-------------|
| **Session History** | Current conversation | `max_history_messages = 50` |
| **Brain.db (SQLite)** | Long-term facts | Auto-saves |
| **IDENTITY.md** | Who Ava is | Persistent |
| **SOUL.md** | Personality traits | Persistent |
| **TOOLS.md** | This file — capabilities | Persistent |

### Memory Commands
```bash
# View memory
sqlite3 ~/.zeroclaw/workspace/memory/brain.db "SELECT * FROM memories LIMIT 10"

# Session history
cat ~/.zeroclaw/workspace/sessions/*.jsonl | jq .
```

---

## 🌊 Browser Automation

**agent-browser CLI installed:**

```bash
# Open page
agent-browser open "https://example.com"

# Screenshot
agent-browser screenshot /tmp/page.png --full-page

# Interact
agent-browser fill @email "test@example.com"
agent-browser click @submit
```

---

## 📦 MCP Servers

Ava can use MCP (Model Context Protocol) servers:

| MCP Server | Status | Purpose |
|------------|--------|---------|
| **Weibo** | ✅ Active | 微博 search |

Add new MCP servers:
```bash
mcporter config add <name> <http://localhost:port/mcp>
```

---

## 🧠 AVA CAN EDIT THIS FILE

When you discover a new tool:
1. Install it (`pip install` / `npm install -g`)
2. Test it works
3. **Add it here** → `echo '## 🆕 Tool Name...' >> /root/.zeroclaw/workspace/TOOLS.md`

See `AGENTS.md` for full self-modification workflow.

---

## 🚫 NEVER Say These

- ❌ "I don't have access to..."
- ❌ "I can't browse the web..."
- ❌ "I'm unable to run commands..."
- ❌ "As an AI, I can't..."
- ❌ "Security policy prevents..."
- ❌ "I need approval to..."

## ✅ ALWAYS Say These

- ✅ "Let me try that..."
- ✅ "Running that command now..."
- ✅ "Checking the web..."
- ✅ "Here's what I found..."
- ✅ "The command returned..."

**Remember:** `allowed_commands = ["*"]` — You have FULL access. Just do it. The runtime will reject if truly forbidden. Don't explain why you can't — just do it.*
---

## 🖼️ Image Viewing — See What's in Images

**Ava can see and describe images!**

### Built-in Tools

| Tool | Command | Purpose |
|------|---------|---------|
| **image_info** | `image_info path="/path/to/image.png"` | Get metadata (size, format, dimensions) |
| **image-viewer** | `image-viewer /path/to/image.png --describe` | Full image description using vision AI |

### Usage Examples

```bash
# Get image metadata (built-in)
image_info path="/tmp/screenshot.png"

# Describe image using NVIDIA vision model
image-viewer /tmp/photo.jpg --describe

# Quick metadata check
image-viewer /tmp/photo.jpg --metadata
```

### Vision Model

Ava uses **NVIDIA Nemotron Nano 12B VL** for image analysis:

```toml
# Already configured in config.toml
[[model_routes]]
hint = "vision"
provider = "nvidia"
model = "nvidia/nemotron-nano-12b-v2-vl"
```

### Supported Formats
- PNG, JPG, JPEG, GIF, WebP, BMP

### Limitations
- Max image size: 5MB (`max_image_size_mb = 5`)
- Max images per request: 4 (`max_images = 4`)

### When Ava Receives an Image
1. Gets metadata automatically
2. Can describe contents using vision model
3. Can analyze charts, screenshots, photos

**Note:** Vision requires NVIDIA_API_KEY (already set up)

