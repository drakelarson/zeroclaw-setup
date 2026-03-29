#!/bin/bash
#
# Setup Telegram channel for ZeroClaw
#
# Usage: ./setup-telegram.sh --token "123456:ABC"
#
# Options:
#   --token         Telegram bot token from @BotFather (required)
#   --allowed-users Comma-separated list of allowed user IDs (default: * for all)
#   --help          Show this help
#

set -e

RED='\\033[0;31m'
GREEN='\\033[0;32m'
YELLOW='\\033[1;33m'
NC='\\033[0m'

TOKEN=""
ALLOWED_USERS="*"

while [[ $# -gt 0 ]]; do
    case $1 in
        --token)
            TOKEN="$2"
            shift 2
            ;;
        --allowed-users)
            ALLOWED_USERS="$2"
            shift 2
            ;;
        --help|-h)
            head -20 "$0"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$TOKEN" ]]; then
    echo -e "${RED}Error: --token is required${NC}"
    echo "Get your bot token from @BotFather on Telegram"
    exit 1
fi

CONFIG_FILE="/root/.zeroclaw/config.toml"

echo -e "${YELLOW}Setting up Telegram channel...${NC}"

# Verify token with Telegram API
echo "Verifying bot token..."
BOT_INFO=$(curl -s "https://api.telegram.org/bot${TOKEN}/getMe")

if ! echo "$BOT_INFO" | jq -e '.ok' > /dev/null 2>&1; then
    echo -e "${RED}Invalid bot token. Response:${NC}"
    echo "$BOT_INFO" | jq .
    exit 1
fi

BOT_USERNAME=$(echo "$BOT_INFO" | jq -r '.result.username')
BOT_NAME=$(echo "$BOT_INFO" | jq -r '.result.first_name')

echo "Bot found: @$BOT_USERNAME ($BOT_NAME)"

# Check if config exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo -e "${RED}Config file not found. Run install-zeroclaw.sh and configure-provider.sh first${NC}"
    exit 1
fi

# Format allowed users
if [[ "$ALLOWED_USERS" == "*" ]]; then
    USERS_TOML="allowed_users = [\"*\"]"
else
    # Convert comma-separated to TOML array
    USERS_ARRAY=$(echo "$ALLOWED_USERS" | tr ',' '\\n' | sed 's/^/"/;s/$/"/' | tr '\\n' ',' | sed 's/,$//')
    USERS_TOML="allowed_users = [$USERS_ARRAY]"
fi

# Check if telegram config already exists
if grep -q "\\[channels_config.telegram\\]" "$CONFIG_FILE"; then
    echo "Updating existing Telegram config..."
    # Update existing config
    sed -i "s/^bot_token = .*/bot_token = \"$TOKEN\"/" "$CONFIG_FILE"
    sed -i "s/^allowed_users = .*/$USERS_TOML/" "$CONFIG_FILE"
else
    echo "Adding Telegram config..."
    # Append new config
    cat >> "$CONFIG_FILE" << EOF

[channels_config.telegram]
bot_token = "$TOKEN"
$USERS_TOML
stream_mode = "off"
EOF
fi

echo -e "${GREEN}✅ Telegram channel configured${NC}"
echo ""
echo "Bot:        @$BOT_USERNAME"
echo "Token:      Configured"
echo "Allowed:    $ALLOWED_USERS"
echo ""
echo "Start daemon: NVIDIA_API_KEY=... zeroclaw daemon"
echo "Then message your bot on Telegram!"