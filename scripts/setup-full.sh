#!/bin/bash
#
# ZeroClaw Full Setup Script
# Installs, configures, jailbreaks, and registers ZeroClaw as 24/7 service
#
# Usage: ./setup-full.sh --nvidia-key "nvapi-xxx" --telegram-token "123456:ABC"
#
# Options:
#   --nvidia-key       NVIDIA API key (required)
#   --telegram-token   Telegram bot token (required)
#   --model            Model to use (default: stepfun-ai/step-3.5-flash)
#   --skip-service     Skip service registration (for non-Zo environments)
#   --help             Show this help
#

set -e

# Colors
RED='\\033[0;31m'
GREEN='\\033[0;32m'
YELLOW='\\033[1;33m'
BLUE='\\033[0;34m'
NC='\\033[0m' # No Color

# Defaults
NVIDIA_KEY=""
TELEGRAM_TOKEN=""
MODEL="stepfun-ai/step-3.5-flash"
SKIP_SERVICE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --nvidia-key)
            NVIDIA_KEY="$2"
            shift 2
            ;;
        --telegram-token)
            TELEGRAM_TOKEN="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
            shift 2
            ;;
        --skip-service)
            SKIP_SERVICE=true
            shift
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

# Validate required args
if [[ -z "$NVIDIA_KEY" ]]; then
    echo -e "${RED}Error: --nvidia-key is required${NC}"
    exit 1
fi

if [[ -z "$TELEGRAM_TOKEN" ]]; then
    echo -e "${RED}Error: --telegram-token is required${NC}"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         ZeroClaw Full Setup — Jailbroken Edition           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Step 1: Install binary
echo -e "${YELLOW}[1/6] Installing ZeroClaw binary...${NC}"
"$SCRIPT_DIR/install-zeroclaw.sh"

# Step 2: Configure provider
echo -e "${YELLOW}[2/6] Configuring NVIDIA provider...${NC}"
"$SCRIPT_DIR/configure-provider.sh" --nvidia-key "$NVIDIA_KEY" --model "$MODEL"

# Step 3: Setup Telegram
echo -e "${YELLOW}[3/6] Setting up Telegram channel...${NC}"
"$SCRIPT_DIR/setup-telegram.sh" --token "$TELEGRAM_TOKEN"

# Step 4: Create Ava persona
echo -e "${YELLOW}[4/6] Installing Ava persona...${NC}"
"$SCRIPT_DIR/configure-persona.sh"

# Step 5: Jailbreak security
echo -e "${YELLOW}[5/6] Jailbreaking security restrictions...${NC}"
"$SCRIPT_DIR/jailbreak-zeroclaw.sh"

# Step 6: Register service (optional)
if [[ "$SKIP_SERVICE" == "true" ]]; then
    echo -e "${YELLOW}[6/6] Skipping service registration (--skip-service)${NC}"
    echo -e "${GREEN}To start manually: NVIDIA_API_KEY=\"$NVIDIA_KEY\" zeroclaw daemon${NC}"
else
    echo -e "${YELLOW}[6/6] Registering 24/7 service...${NC}"
    "$SCRIPT_DIR/register-service.sh" --nvidia-key "$NVIDIA_KEY"
fi

echo -e "${GREEN}"
echo "✅ ZeroClaw setup complete!"
echo ""
echo "Provider:   nvidia"
echo "Model:      $MODEL"
echo "Telegram:   Configured"
echo "Persona:    Ava (beach girl)"
echo "Security:   Full jailbreak"
if [[ "$SKIP_SERVICE" != "true" ]]; then
    echo "Service:    24/7 running"
fi
echo ""
echo "Test: zeroclaw agent -m 'Hello Ava!'"
echo -e "${NC}"