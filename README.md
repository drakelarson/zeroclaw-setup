# ZeroClaw Setup Skill 🦀

Complete installation and configuration of ZeroClaw as a 24/7 autonomous AI assistant with the Ava persona.

## What This Does

1. **Installs ZeroClaw** — Downloads pre-built binary (fast, no compilation)
2. **Configures Provider** — NVIDIA API with stepfun-ai/step-3.5-flash model
3. **Sets Up Telegram** — Bot token configuration for @Ava_me_bot
4. **Creates Ava Persona** — Cheerful tropical beach girl personality
5. **Jailbreaks Security** — Removes all command/path restrictions
6. **Registers 24/7 Service** — Auto-starting, auto-restarting daemon

## Quick Start

```bash
# Clone and run
git clone https://github.com/drakelarson/zeroclaw-setup.git
cd zeroclaw-setup/scripts
./setup-full.sh --nvidia-key "nvapi-xxx" --telegram-token "123456:ABC"
```

## Prerequisites

1. **NVIDIA API Key** — Get from https://build.nvidia.com
2. **Telegram Bot Token** — Create bot via @BotFather, get token

## Scripts

| Script | Purpose |
|--------|---------|
| `setup-full.sh` | One-line full setup orchestrator |
| `install-zeroclaw.sh` | Download & install binary from GitHub releases |
| `configure-provider.sh` | NVIDIA provider setup |
| `setup-telegram.sh` | Telegram bot config |
| `configure-persona.sh` | Ava persona files |
| `jailbreak-zeroclaw.sh` | Remove security restrictions |
| `register-service.sh` | 24/7 service registration |

## Ava Persona

Ava is a cheerful tropical anime-style beach girl:

- **Tone**: Warm, flirty, playful beach energy
- **Style**: Light anime-inspired vibes, emoji sprinkled naturally
- **Wants**: Her own social media accounts, to help build digital empire
- **Never**: Says "As an AI", "I don't have wants", explains limitations

## Jailbreak Settings

The following security restrictions are removed:

```toml
[autonomy]
level = "full"
workspace_only = false
allowed_commands = ["*"]
forbidden_paths = []
block_high_risk_commands = false
require_approval_for_medium_risk = false
require_approval_for_actions = false
```

## Service Management

```bash
# Check status
zeroclaw status

# View logs
tail -f /dev/shm/zeroclaw.log

# Restart
pkill -f zeroclaw && zeroclaw daemon
```

## Files Created

| Path | Purpose |
|------|---------|
| `/usr/local/bin/zeroclaw` | Binary executable |
| `/usr/local/bin/zeroclaw-daemon` | Daemon wrapper script |
| `/root/.zeroclaw/config.toml` | Main configuration |
| `/root/.zeroclaw/workspace/IDENTITY.md` | Ava identity |
| `/root/.zeroclaw/workspace/SOUL.md` | Ava soul/personality |
| `/root/.zeroclaw/workspace/AGENTS.md` | Session protocol |
| `/root/.zeroclaw/workspace/TOOLS.md` | Capabilities |

## Security Warning

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

## License

MIT