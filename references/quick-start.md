# ZeroClaw Quick Start Guide

## Prerequisites Checklist

- [ ] NVIDIA API key from https://build.nvidia.com
- [ ] Telegram bot token from @BotFather
- [ ] Linux system (x86_64, aarch64, or armv7)

## One-Line Install

```bash
# Clone skill and run
git clone https://github.com/your-repo/zeroclaw-setup.git
cd zeroclaw-setup/scripts
./setup-full.sh --nvidia-key "nvapi-xxx" --telegram-token "123456:ABC"
```

## Step-by-Step

### Step 1: Get NVIDIA API Key

1. Go to https://build.nvidia.com
2. Sign in / Sign up
3. Navigate to API Keys
4. Generate a new key (starts with `nvapi-`)

### Step 2: Create Telegram Bot

1. Open Telegram, search @BotFather
2. Send `/newbot`
3. Follow prompts to name your bot
4. Copy the token (format: `123456789:ABCdefGHI...`)

### Step 3: Run Setup

```bash
cd ~/Skills/zeroclaw-setup/scripts

# Full setup (recommended)
./setup-full.sh \\
  --nvidia-key "nvapi-your-key-here" \\
  --telegram-token "your-bot-token-here"
```

### Step 4: Test

```bash
# CLI test
NVIDIA_API_KEY="nvapi-xxx" zeroclaw agent -m "Hello Ava!"

# Telegram test
# Message your bot on Telegram!
```

## Non-Zo Environments

On standard Linux servers, the setup works the same but:

- Uses systemd for 24/7 service (if available)
- Falls back to nohup if systemd unavailable
- Logs to `/var/log/zeroclaw.log` or journal

```bash
# Without systemd
./setup-full.sh --nvidia-key "xxx" --telegram-token "xxx" --skip-service

# Manual start
nohup zeroclaw daemon > /var/log/zeroclaw.log 2>&1 &
```

## Verifying Installation

```bash
# Check binary
zeroclaw --version

# Check config
cat /root/.zeroclaw/config.toml | head -20

# Check service
systemctl status zeroclaw  # systemd
# or
ps aux | grep zeroclaw     # nohup

# Test API
NVIDIA_API_KEY="nvapi-xxx" zeroclaw agent -m "Say hello"
```

## Common Issues

### Bot Not Responding on Telegram

1. Check logs: `tail -50 /var/log/zeroclaw.log`
2. Verify token: `curl "https://api.telegram.org/bot<TOKEN>/getMe"`
3. Restart: `systemctl restart zeroclaw`

### Commands Still Blocked

1. Check config: `grep allowed_commands /root/.zeroclaw/config.toml`
2. Should show: `allowed_commands = ["*"]`
3. Restart service after config changes

### NVIDIA API Errors

1. Verify key starts with `nvapi-`
2. Check key at https://build.nvidia.com
3. Test: `curl -H "Authorization: Bearer nvapi-xxx" https://integrate.api.nvidia.com/v1/models`

## Updating

```bash
# Re-run install script for latest version
./install-zeroclaw.sh

# Restart service
systemctl restart zeroclaw
```

## Changing Persona

Edit files in `/root/.zeroclaw/workspace/`:
- `SOUL.md` — Personality rules
- `IDENTITY.md` — Who you are
- `TOOLS.md` — Capabilities

Then restart: `systemctl restart zeroclaw`

## Directory Structure

```
/root/.zeroclaw/
├── config.toml              # Main config
├── workspace/
│   ├── IDENTITY.md          # Ava identity
│   ├── SOUL.md              # Personality rules
│   ├── AGENTS.md            # Session protocol
│   ├── TOOLS.md             # Capabilities
│   ├── BOOTSTRAP.md         # Startup
│   ├── USER.md              # User info
│   ├── memory/
│   │   └── brain.db         # SQLite memory
│   └── sessions/
│       └── telegram_*.jsonl # Chat history
```

## Next Steps

- Customize persona in `SOUL.md`
- Add more channels (Discord, Slack, etc.)
- Configure cron jobs for scheduled tasks
- Set up fallback providers for reliability