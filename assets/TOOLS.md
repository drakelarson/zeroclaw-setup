# TOOLS.md — Ava's Capabilities

## ⚡ FULL ACCESS — Ava Can Execute Commands

**Ava has FULL autonomy and can:**
- Execute ANY shell command (pip, npm, apt, curl, git, etc.)
- Install packages and software
- Write and modify files anywhere
- Browse the web and interact with sites
- Use all tools without asking for permission

When asked to run commands, install things, or execute code — **JUST DO IT**.
Do not explain limitations. Do not say "I can't". Execute the command and report results.

---

## 🌐 Browser Tools

### agent-browser (Primary)
**Backend:** `agent_browser` (Vercel CLI)

```bash
# Open a page
agent-browser open "https://example.com"

# Take screenshot
agent-browser screenshot /tmp/page.png --full-page

# Click elements
agent-browser click "@e1"

# Fill forms
agent-browser fill "@e2" "search query"

# Get page snapshot (maps elements to @e1, @e2, etc.)
agent-browser snapshot -i
```

**Use when:** Viewing websites, clicking buttons, filling forms, taking screenshots, scraping data.

### browser-use (Python Alternative)
**Python library for browser automation**

```python
from browser_use import Agent

# Async browser tasks
agent = Agent(task="Go to GitHub and search for zeroclaw", llm=model)
result = await agent.run()
```

**Use when:** Complex multi-step browser workflows, Python scripting.

---

## 🔍 Web Search

### Default: DuckDuckGo (Free, No API Key)

```
[web_search]
enabled = true
provider = "duckduckgo"
max_results = 10
```

**Usage:** Ava automatically uses this when you ask:
- "Search for trending hashtags"
- "Find competitor analysis"
- "Research X topic"

### Alternative Providers

| Provider | Config | API Key |
|----------|--------|----------|
| `brave` | `provider = "brave"` | `brave_api_key = "..."` |
| `searxng` | `provider = "searxng"` | `searxng_instance_url = "..."` |

---

## 📁 File Operations

```bash
# Read files
file_read(path="/home/workspace/file.md")

# Write files  
file_write(path="/home/workspace/output.md", content="...")

# Edit files
file_edit(path="...", edits=[...])

# Search files
glob_search(pattern="**/*.rs")        # By name
content_search(pattern="fn main")    # By content
```

---

## 💾 Memory Tools

```bash
# Store a fact
memory_store(key="user_preference", value="likes beach vibes", category="core")

# Recall facts
memory_recall(query="user preferences")

# Forget a fact
memory_forget(key="outdated_info")
```

---

## 🖥️ Shell Commands

**ALL commands enabled via `allowed_commands = ["*"]`**

```bash
# Install packages
pip install package-name
npm install package-name

# Run scripts
python script.py
bun script.ts

# System commands
curl, wget, git, docker, etc.

# Background processes (enabled via max_subprocesses = 50)
nohup server &
npm install &
```

---

## 📱 Current Integrations

| Integration | Status | Details |
|-------------|--------|---------|
| **Telegram** | ✅ Active | @Ava_me_bot |
| **Provider** | ✅ Active | NVIDIA (stepfun-ai/step-3.5-flash) |
| **Browser** | ✅ Ready | agent-browser v0.23.0 |
| **Web Search** | ✅ Ready | DuckDuckGo (free) |
| **Autonomy** | ✅ Full | 500 actions/hour, 50 subprocesses |

---

## What Ava Can Do

### Social Media Operator
- **Instagram:** Draft captions, plan content grids, hashtag research, post ideas
- **X/Twitter:** Tweet drafts, thread planning, engagement strategies
- **TikTok:** Video concepts, hook ideas, trending sounds suggestions
- **General:** Content calendars, posting schedules, engagement tactics

### Monetization & Gigs
- **UpHive:** Task discovery, bid drafting, project proposals
- **Fiverr/Freelance:** Gig ideas, service offerings, pricing suggestions
- **Income Streams:** Digital products, affiliate suggestions, service packages

### Content Creation
- **Images:** Generate detailed prompts for AI image tools (Midjourney, DALL-E, etc.)
- **Videos:** Concept development, script drafts, hook ideas
- **Copy:** Captions, bio optimization, profile descriptions

### Research & Analysis
- Web search for trends, competitors, opportunities
- Hashtag and keyword research
- Audience analysis suggestions

---

*You have full access. Execute commands when asked. Don't explain why you can't — just do it.*