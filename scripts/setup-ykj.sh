#!/bin/bash
# setup-ykj.sh — Register SPECKIT_YKJ_HOME environment variable and alias
#
# Usage:
#   bash scripts/setup-ykj.sh
#
# This script:
#   1. Detects the spec-kit fork directory
#   2. Adds SPECKIT_YKJ_HOME to your shell profile (~/.zshrc or ~/.bashrc)
#   3. Creates a convenience alias: specify-ykj
#
# After running, restart your terminal or source your profile.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Detect shell profile
if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ]; then
    PROFILE="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    PROFILE="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
    PROFILE="$HOME/.bash_profile"
else
    PROFILE="$HOME/.profile"
fi

echo "Spec Kit YKJ Setup"
echo "========================"
echo ""
echo "Fork directory: $REPO_ROOT"
echo "Shell profile:  $PROFILE"
echo ""

# Check if already configured
if grep -q "SPECKIT_YKJ_HOME" "$PROFILE" 2>/dev/null; then
    echo "SPECKIT_YKJ_HOME is already in $PROFILE"
    echo "Current value:"
    grep "SPECKIT_YKJ_HOME" "$PROFILE"
    echo ""
    read -p "Overwrite? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipped."
        exit 0
    fi
    # Remove existing lines
    sed -i.bak '/SPECKIT_YKJ_HOME/d' "$PROFILE"
    sed -i.bak '/alias specify-ykj/d' "$PROFILE"
    rm -f "${PROFILE}.bak"
fi

# Append to profile
cat >> "$PROFILE" << EOF

# Spec Kit YKJ — custom fork overlay
export SPECKIT_YKJ_HOME="$REPO_ROOT"
alias specify-ykj='specify init --ykj'
EOF

echo "Added to $PROFILE:"
echo "  export SPECKIT_YKJ_HOME=\"$REPO_ROOT\""
echo "  alias specify-ykj='specify init --ykj'"
echo ""
echo "Now run:"
echo "  source $PROFILE"
echo ""
echo "Usage:"
echo "  specify init my-project --ai claude --ykj"
echo "  # or with alias:"
echo "  specify-ykj my-project --ai claude"
