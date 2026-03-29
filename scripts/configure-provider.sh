#!/bin/bash
#
# Configure NVIDIA provider for ZeroClaw
#
# Usage: ./configure-provider.sh --nvidia-key "nvapi-xxx" [--model MODEL]
#
# Options:
#   --nvidia-key    NVIDIA API key (required)
#   --model         Model to use (default: stepfun-ai/step-3.5-flash)
#   --help          Show this help
#

set -e

RED='\\033[0;31m'
GREEN='\\033[0;32m'
YELLOW='\\033[1;33m'
NC='\\033[0m'

NVIDIA_KEY=""
MODEL="stepfun-ai/step-3.5-flash"

while [[ $# -gt 0 ]]; do
    case $1 in
        --nvidia-key)
            NVIDIA_KEY="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
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

if [[ -z "$NVIDIA_KEY" ]]; then
    echo -e "${RED}Error: --nvidia-key is required${NC}"
    exit 1
fi

CONFIG_DIR="/root/.zeroclaw"
CONFIG_FILE="$CONFIG_DIR/config.toml"

echo -e "${YELLOW}Configuring NVIDIA provider...${NC}"

# Create config directory if needed
mkdir -p "$CONFIG_DIR"

# Check if config exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Running initial onboarding..."
    export NVIDIA_API_KEY="$NVIDIA_KEY"
    zeroclaw onboard --api-key "$NVIDIA_KEY" --provider nvidia 2>/dev/null || true
fi

# Ensure config exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Creating minimal config..."
    cat > "$CONFIG_FILE" << 'EOFCONFIG'
default_provider = "nvidia"
default_model = "PLACEHOLDER_MODEL"
default_temperature = 0.7
provider_timeout_secs = 120

[autonomy]
level = "supervised"
workspace_only = true
allowed_commands = []
max_actions_per_hour = 100
EOFCONFIG
fi

# Update settings
echo "Setting provider to nvidia..."
sed -i 's/^default_provider = .*/default_provider = "nvidia"/' "$CONFIG_FILE"

echo "Setting model to $MODEL..."
sed -i "s/^default_model = .*/default_model = \"$MODEL\"/" "$CONFIG_FILE"

# Add NVIDIA API key to environment
echo "Adding NVIDIA_API_KEY to environment..."
if ! grep -q "export NVIDIA_API_KEY" /etc/profile.d/zeroclaw.sh 2>/dev/null; then
    mkdir -p /etc/profile.d
    echo "export NVIDIA_API_KEY=\"$NVIDIA_KEY\"" > /etc/profile.d/zeroclaw.sh
fi

# Also add to bashrc
if ! grep -q "NVIDIA_API_KEY" /root/.bashrc 2>/dev/null; then
    echo "export NVIDIA_API_KEY=\"$NVIDIA_KEY\"" >> /root/.bashrc
fi

# Test connection
echo "Testing connection..."
if NVIDIA_API_KEY="$NVIDIA_KEY" zeroclaw agent -m "Say 'ok'" 2>&1 | grep -q "ok\|Ok\|OK"; then
    echo -e "${GREEN}✅ NVIDIA provider configured and tested${NC}"
else
    echo -e "${YELLOW}⚠️  Provider configured but test unclear. Check with: zeroclaw agent -m 'Hello'${NC}"
fi

echo ""
echo "Provider:   nvidia"
echo "Model:      $MODEL"
echo "Base URL:   https://integrate.api.nvidia.com/v1"
echo "API Key:    Set in environment"