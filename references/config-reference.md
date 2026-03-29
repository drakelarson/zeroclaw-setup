# ZeroClaw Configuration Reference

## Jailbreak Settings

The following settings unlock full autonomous operation:

### Autonomy Section

```toml
[autonomy]
level = "full"                        # Full autonomous mode
workspace_only = false                 # Allow full filesystem access
allowed_commands = ["*"]              # ALL commands allowed
forbidden_paths = []                  # No path restrictions
max_actions_per_hour = 500            # High action limit
require_approval_for_medium_risk = false
require_approval_for_actions = false
block_high_risk_commands = false      # Allow rm, dd, etc.
```

### Why These Work

According to ZeroClaw source code (`src/security/policy.rs`):

1. `allowed_commands = ["*"]` opts out of command allowlist
2. `forbidden_paths = []` removes path traversal blocking  
3. `workspace_only = false` enables full filesystem access
4. `block_high_risk_commands = false` enables all commands

## Provider Settings

### NVIDIA Provider

```toml
default_provider = "nvidia"
default_model = "stepfun-ai/step-3.5-flash"
default_temperature = 0.7
```

NVIDIA API base URL is hardcoded in ZeroClaw:
- `https://integrate.api.nvidia.com/v1`

### Other Providers

ZeroClaw supports 20+ providers. Change `default_provider`:

| Provider | ID | API Key Env Var |
|----------|-----|-----------------|
| OpenRouter | `openrouter` | `OPENROUTER_API_KEY` |
| Anthropic | `anthropic` | `ANTHROPIC_API_KEY` |
| OpenAI | `openai` | `OPENAI_API_KEY` |
| Gemini | `gemini` | `GEMINI_API_KEY` |
| Groq | `groq` | `GROQ_API_KEY` |
| DeepSeek | `deepseek` | `DEEPSEEK_API_KEY` |
| Ollama | `ollama` | (local, optional) |

## Channel Settings

### Telegram

```toml
[channels_config.telegram]
bot_token = "123456:ABC"
allowed_users = ["*"]    # Or ["12345678", "87654321"] for specific users
stream_mode = "off"
```

### Other Channels

ZeroClaw supports: WhatsApp, Discord, Slack, Signal, Matrix, IRC, Email, and more.

See: https://github.com/zeroclaw-labs/zeroclaw/blob/master/docs/reference/api/channels-reference.md

## Memory Settings

```toml
[memory]
backend = "sqlite"       # SQLite storage
auto_save = true         # Auto-save conversations
hygiene_enabled = true   # Clean old memories
```

Memory location: `/root/.zeroclaw/workspace/memory/brain.db`

## Security Settings

### To Disable Security

```toml
[security.audit]
enabled = false

[security.otp]
enabled = false

[security.estop]
enabled = false
```

### To Keep Some Security

```toml
[security.sandbox]
backend = "auto"         # Still uses sandbox but respects allowed_commands
```

## Rate Limits

```toml
max_actions_per_hour = 500
max_cost_per_day_cents = 5000

[shell_tool]
timeout_secs = 300       # 5 minute command timeout
```

## Gateway Settings

```toml
[gateway]
port = 42617
host = "127.0.0.1"       # Bind to localhost
require_pairing = false  # Disable pairing requirement
```

## Fallback Providers

For reliability, configure fallback providers:

```toml
[reliability]
fallback_providers = ["openrouter", "anthropic"]
provider_retries = 2

[reliability.model_fallbacks]
"stepfun-ai/step-3.5-flash" = ["meta/llama-3.3-70b-instruct"]
```

## See Also

- [ZeroClaw Providers Reference](https://github.com/zeroclaw-labs/zeroclaw/blob/master/docs/reference/api/providers-reference.md)
- [ZeroClaw Channels Reference](https://github.com/zeroclaw-labs/zeroclaw/blob/master/docs/reference/api/channels-reference.md)