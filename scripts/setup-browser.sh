#!/bin/bash
#
# Setup Browser and Web Search for ZeroClaw
#
# Usage: ./setup-browser.sh
#
# Installs:
#   - agent-browser (Vercel's browser automation CLI)
#   - browser-use (Python browser automation)
#   - Configures ZeroClaw browser settings
#
# Options:
#   --help    Show this help
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CONFIG_FILE="/root/.zeroclaw/config.toml"

echo -e "${YELLOW}Setting up browser and web search...${NC}"

# ============================================
# Install agent-browser (Vercel)
# ============================================
echo "Installing agent-browser..."

if ! command -v agent-browser &> /dev/null; then
    # Clone and setup agent-browser
    if [[ ! -d "/root/agent-browser" ]]; then
        git clone https://github.com/vercel-labs/agent-browser.git /root/agent-browser
        cd /root/agent-browser
        bun install
    fi
    
    # Link the pre-built binary
    ln -sf /root/agent-browser/bin/agent-browser-linux-x64 /usr/local/bin/agent-browser
    chmod +x /usr/local/bin/agent-browser
    
    echo -e "${GREEN}✓ agent-browser installed$(NC)"
else
    echo -e "${GREEN}✓ agent-browser already installed$(NC)"
fi

# Verify
agent-browser --version

# ============================================
# Install browser-use (Python)
# ============================================
echo "Installing browser-use..."

if ! python -c "import browser_use" 2>/dev/null; then
    pip install browser-use
    echo -e "${GREEN}✓ browser-use installed$(NC)"
else
    echo -e "${GREEN}✓ browser-use already installed$(NC)"
fi

# ============================================
# Update ZeroClaw Config
# ============================================
echo "Configuring ZeroClaw browser settings..."

if [[ -f "$CONFIG_FILE" ]]; then
    # Ensure browser is enabled with agent_browser backend
    if grep -q '\[browser\]' "$CONFIG_FILE"; then
        sed -i '/\[browser\]/,/^\[/ s/^enabled = .*/enabled = true/' "$CONFIG_FILE"
        sed -i '/\[browser\]/,/^\[/ s/^backend = .*/backend = "agent_browser"/' "$CONFIG_FILE"
        sed -i '/\[browser\]/,/^\[/ s/^allowed_domains = .*/allowed_domains = ["*"]/' "$CONFIG_FILE"
    fi
    
    # Ensure web_search is enabled
    if grep -q '\[web_search\]' "$CONFIG_FILE"; then
        sed -i '/\[web_search\]/,/^\[/ s/^enabled = .*/enabled = true/' "$CONFIG_FILE"
        sed -i '/\[web_search\]/,/^\[/ s/^max_results = .*/max_results = 10/' "$CONFIG_FILE"
    fi
    
    echo -e "${GREEN}✓ ZeroClaw config updated$(NC)"
fi

# ============================================
# Summary
# ============================================
echo ""
echo -e "${GREEN}✅ Browser setup complete!${NC}"
echo ""
echo "Browser backends available:"
echo "  • agent-browser (Vercel) — primary, used by ZeroClaw"
echo "  • browser-use (Python) — alternative for custom scripts"
echo ""
echo "Web search providers:"
echo "  • duckduckgo (free, default)"
echo "  • brave (requires API key)"
echo "  • searxng (self-hosted)"
echo ""
echo "Test browser: agent-browser open 'https://example.com'"
echo "Restart ZeroClaw to apply: pkill -f zeroclaw && NVIDIA_API_KEY=... zeroclaw daemon"