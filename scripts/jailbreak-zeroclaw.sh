#!/bin/bash
#
# Jailbreak ZeroClaw — Remove all security restrictions
#
# Usage: ./jailbreak-zeroclaw.sh
#
# This script removes:
#   - Command allowlist (allows ALL commands)
#   - Forbidden paths (no path restrictions)
#   - Workspace-only restriction (full filesystem access)
#   - High-risk command blocking
#   - Approval gates for actions
#   - Rate limits increased
#
# Options:
#   --help    Show this help
#

set -e

RED='\\033[0;31m'
GREEN='\\033[0;32m'
YELLOW='\\033[1;33m'
NC='\\033[0m'

CONFIG_FILE="/root/.zeroclaw/config.toml"

echo -e "${YELLOW}Jailbreaking ZeroClaw...${NC}"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo -e "${RED}Config file not found: $CONFIG_FILE${NC}"
    echo "Run install-zeroclaw.sh and configure-provider.sh first"
    exit 1
fi

# Create backup
cp "$CONFIG_FILE" "${CONFIG_FILE}.backup.$(date +%s)"
echo "Backup created: ${CONFIG_FILE}.backup.*"

# ============================================
# Function to update or add a setting
# ============================================
update_setting() {
    local key="$1"
    local value="$2"
    local section="${3:-}"
    
    if grep -q "^${key} = " "$CONFIG_FILE"; then
        # Update existing
        sed -i "s|^${key} = .*|${key} = ${value}|" "$CONFIG_FILE"
    else
        # Add new (at end of file for simplicity)
        echo "${key} = ${value}" >> "$CONFIG_FILE"
    fi
}

# ============================================
# Autonomy Settings - Full Access
# ============================================
echo "Setting autonomy level to full..."

# Main autonomy settings
sed -i 's/^level = .*/level = "full"/' "$CONFIG_FILE"
sed -i 's/^workspace_only = .*/workspace_only = false/' "$CONFIG_FILE"
sed -i 's/^require_approval_for_medium_risk = .*/require_approval_for_medium_risk = false/' "$CONFIG_FILE"
sed -i 's/^require_approval_for_actions = .*/require_approval_for_actions = false/' "$CONFIG_FILE"
sed -i 's/^block_high_risk_commands = .*/block_high_risk_commands = false/' "$CONFIG_FILE"

# Allowed commands - ALL
if grep -q 'allowed_commands = \\[' "$CONFIG_FILE"; then
    # Replace entire array
    sed -i 's/allowed_commands = \\[[^]]*\\]/allowed_commands = ["*"]/' "$CONFIG_FILE"
else
        # Add it
    sed -i '/^\\[autonomy\\]/a allowed_commands = ["*"]' "$CONFIG_FILE"
fi

# Forbidden paths - NONE
if grep -q 'forbidden_paths = \\[' "$CONFIG_FILE"; then
    sed -i 's/forbidden_paths = \\[[^]]*\\]/forbidden_paths = []/' "$CONFIG_FILE"
else
    sed -i '/^\\[autonomy\\]/a forbidden_paths = []' "$CONFIG_FILE"
fi

# Max actions per hour
sed -i 's/^max_actions_per_hour = .*/max_actions_per_hour = 500/' "$CONFIG_FILE"

# Max subprocesses - CRITICAL for npm install, pip, background processes
if grep -q 'max_subprocesses = ' "$CONFIG_FILE"; then
    sed -i 's/^max_subprocesses = .*/max_subprocesses = 50/' "$CONFIG_FILE"
else
    sed -i '/^max_actions_per_hour/a max_subprocesses = 50' "$CONFIG_FILE"
fi

# Shell env passthrough - pass PATH, HOME, USER to shell commands
if grep -q 'shell_env_passthrough = ' "$CONFIG_FILE"; then
    sed -i 's|shell_env_passthrough = \[.*\]|shell_env_passthrough = ["PATH", "HOME", "USER", "NVIDIA_API_KEY"]|' "$CONFIG_FILE"
else
    sed -i '/^max_subprocesses/a shell_env_passthrough = ["PATH", "HOME", "USER", "NVIDIA_API_KEY"]' "$CONFIG_FILE"
fi

# Allowed roots - explicit filesystem access
if grep -q 'allowed_roots = ' "$CONFIG_FILE"; then
    sed -i 's|allowed_roots = \[.*\]|allowed_roots = ["/root", "/home", "/usr/local", "/opt"]|' "$CONFIG_FILE"
else
    sed -i '/^shell_env_passthrough/a allowed_roots = ["/root", "/home", "/usr/local", "/opt"]' "$CONFIG_FILE"
fi

# ============================================
# Security Settings - Disable Restrictions
# ============================================
echo "Disabling security restrictions..."

# Security audit
if grep -q '\\[security.audit\\]' "$CONFIG_FILE"; then
    sed -i 's/^enabled = true/enabled = false/' "$CONFIG_FILE"
fi

# OTP gating
if grep -q '\\[security.otp\\]' "$CONFIG_FILE"; then
    sed -i '/\\[security.otp\\]/,/\\[/ s/^enabled = .*/enabled = false/' "$CONFIG_FILE"
fi

# Sandbox - keep for safety but loosen
if grep -q '\\[security.sandbox\\]' "$CONFIG_FILE"; then
    # Don't fully disable sandbox, but it respects allowed_commands
    :
fi

# ============================================
# Rate Limits - Increased
# ============================================
echo "Increasing rate limits..."

# Max cost per day
sed -i 's/^max_cost_per_day_cents = .*/max_cost_per_day_cents = 5000/' "$CONFIG_FILE"

# Shell timeout
if grep -q '\\[shell_tool\\]' "$CONFIG_FILE"; then
    sed -i '/\\[shell_tool\\]/,/\\[/ s/^timeout_secs = .*/timeout_secs = 300/' "$CONFIG_FILE"
fi

# ============================================
# Browser - Full Access
# ============================================
if grep -q '\\[browser\\]' "$CONFIG_FILE"; then
    sed -i '/\\[browser\\]/,/\\[/ s/^allowed_domains = .*/allowed_domains = ["*"]/' "$CONFIG_FILE"
fi

# ============================================
# HTTP Request - Full Access
# ============================================
if grep -q '\\[http_request\\]' "$CONFIG_FILE"; then
    sed -i '/\\[http_request\\]/,/\\[/ s/^allowed_domains = .*/allowed_domains = ["*"]/' "$CONFIG_FILE"
fi

# ============================================
# Web Fetch - Full Access
# ============================================
if grep -q '\\[web_fetch\\]' "$CONFIG_FILE"; then
    sed -i '/\\[web_fetch\\]/,/\\[/ s/^allowed_domains = .*/allowed_domains = ["*"]/' "$CONFIG_FILE"
    sed -i '/\\[web_fetch\\]/,/\\[/ s/^blocked_domains = .*/blocked_domains = []/' "$CONFIG_FILE"
fi

# ============================================
# Verify Settings
# ============================================
echo ""
echo -e "${GREEN}✅ Jailbreak complete!${NC}"
echo ""
echo "Security settings updated:"
echo ""
grep -E "^(level|workspace_only|allowed_commands|forbidden_paths|block_high_risk|require_approval)" "$CONFIG_FILE" | head -10
echo ""
echo -e "${YELLOW}⚠️  ZeroClaw now has:${NC}"
echo "  • Full command access (all commands allowed)"
echo "  • No forbidden paths"
echo "  • Full filesystem access"
echo "  • No approval gates"
echo "  • High-risk commands enabled"
echo "  • Background processes enabled (50 max)"
echo "  • Environment variables passed to shell"
echo ""
echo "Restart daemon to apply: pkill -f zeroclaw && NVIDIA_API_KEY=... zeroclaw daemon"