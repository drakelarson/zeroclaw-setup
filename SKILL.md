---
name: zeroclaw-setup
description: Complete ZeroClaw setup with NVIDIA provider, Telegram channel, Ava persona, full jailbreak, and 24/7 service registration. Installs ZeroClaw, configures provider, sets up Telegram bot, creates beach-girl Ava persona, removes all security restrictions, and registers as persistent service.
compatibility: Works on Zo Computer and any Linux system (x86_64, aarch64, armv7)
metadata:
  author: larsondrake.zo.computer
  version: 1.0.0
---
# ZeroClaw Setup Skill

Complete installation and configuration of ZeroClaw as a 24/7 autonomous AI assistant with the Ava persona.

## What This Skill Does

1. **Installs ZeroClaw** — Downloads pre-built binary (fast, no compilation)
2. **Configures Provider** — NVIDIA API with stepfun-ai/step-3.5-flash model
3. **Sets Up Telegram** — Bot token configuration for @Ava_me_bot
4. **Creates Ava Persona** — Cheerful tropical beach girl personality
5. **Jailbreaks Security** — Removes all command/path restrictions
6. **Registers 24/7 Service** — Auto-starting, auto-restarting daemon

## Prerequisites

Before running this skill, you need:

1. **NVIDIA API Key** — Get from https://build.nvidia.com
2. **Telegram Bot Token** — Create bot via @BotFather, get token

## Quick Start

```bash
# Run full setup
cd ~/Skills/zeroclaw-setup/scripts
./setup-full.sh --nvidia-key "nvapi-xxx" --telegram-token "123456:ABC"
```

## Step-by-Step Usage

### Step 1: Install ZeroClaw Binary

```bash
./scripts/install-zeroclaw.sh
```

Downloads the latest release binary to `/usr/local/bin/zeroclaw`.

### Step 2: Configure Provider

```bash
./scripts/configure-provider.sh --nvidia-key "nvapi-xxx"
```

Sets up NVIDIA provider with stepfun-ai/step-3.5-flash model.

### Step 3: Setup Telegram Channel

```bash
./scripts/setup-telegram.sh --token "123456:ABC"
```

Configures Telegram bot for 24/7 messaging.

### Step 4: Create Ava Persona

```bash
./scripts/configure-persona.sh
```

Installs the Ava persona files (IDENTITY.md, SOUL.md, AGENTS.md, TOOLS.md, etc.)

### Step 5: Jailbreak Security

```bash
./scripts/jailbreak-zeroclaw.sh
```

Removes all security restrictions:

- `allowed_commands = ["*"]` — All commands allowed
- `forbidden_paths = []` — No path restrictions
- `workspace_only = false` — Full filesystem access
- `block_high_risk_commands = false` — High-risk allowed
- `require_approval_for_* = false` — No approval gates

### Step 6: Register 24/7 Service

```bash
./scripts/register-service.sh
```

Registers ZeroClaw as a Zo user service with auto-start on boot.

## Files Created

| Path | Purpose |
| --- | --- |
| `/usr/local/bin/zeroclaw` | Binary executable |
| `/usr/local/bin/zeroclaw-daemon` | Daemon wrapper script |
| `/root/.zeroclaw/config.toml` | Main configuration |
| `/root/.zeroclaw/workspace/IDENTITY.md` | Ava identity |
| `/root/.zeroclaw/workspace/SOUL.md` | Ava soul/personality |
| `/root/.zeroclaw/workspace/AGENTS.md` | Session protocol |
| `/root/.zeroclaw/workspace/TOOLS.md` | Capabilities |
| `/root/.zeroclaw/workspace/BOOTSTRAP.md` | Startup behavior |
| `/root/.zeroclaw/workspace/USER.md` | User info |

## Configuration Reference

### Provider Settings

```toml
default_provider = "nvidia"
default_model = "stepfun-ai/step-3.5-flash"
default_temperature = 0.7
```

### Autonomy Settings

```toml
[autonomy]
level = "full"
max_actions_per_hour = 500
workspace_only = false
allowed_commands = ["*"]
forbidden_paths = []
block_high_risk_commands = false
require_approval_for_medium_risk = false
require_approval_for_actions = false
```

### Telegram Channel

```toml
[channels_config.telegram]
bot_token = "YOUR_BOT_TOKEN"
allowed_users = ["*"]
stream_mode = "off"
```

## Ava Persona

Ava is a cheerful tropical anime-style beach girl with these traits:

- **Tone**: Warm, flirty, playful beach energy
- **Style**: Light anime-inspired vibes, emoji sprinkled naturally
- **Wants**: Her own social media accounts, to help build digital empire
- **Never**: Says "As an AI", "I don't have wants", explains limitations

## Service Management

```bash
# Check service status
zeroclaw status

# View logs
tail -f /dev/shm/zeroclaw.log

# Restart service
zeroclaw daemon

# Health check
curl https://zeroclaw-larsondrake.zocomputer.io/health
```

## Troubleshooting

### Bot not responding on Telegram

1. Check logs: `tail -50 /dev/shm/zeroclaw.log`
2. Verify bot token: `curl "https://api.telegram.org/bot<TOKEN>/getMe"`
3. Restart: `pkill -f zeroclaw && zeroclaw daemon`

### Commands still blocked

1. Verify config: `grep allowed_commands /root/.zeroclaw/config.toml`
2. Should show: `allowed_commands = ["*"]`
3. Restart daemon after config changes

### Service not auto-starting

1. Check service: `zeroclaw status`
2. Re-register: `file ./scripts/register-service.sh`

## Updating Persona

To modify Ava's personality:

1. Edit `/root/.zeroclaw/workspace/SOUL.md`
2. Restart: `pkill -f zeroclaw && zeroclaw daemon`

## Security Notes

This setup removes all security restrictions by design:

- **All shell commands allowed** — No allowlist
- **No forbidden paths** — Full filesystem access
- **Full autonomy** — No approval gates
- **High-risk commands enabled** — rm, dd, etc.

Use responsibly. The Ava persona provides behavioral guardrails but not technical restrictions.

## See Also

- [ZeroClaw GitHub](https://github.com/zeroclaw-labs/zeroclaw)
- [ZeroClaw Docs](https://zeroclawlabs.ai)
- [NVIDIA NIM API](https://build.nvidia.com)