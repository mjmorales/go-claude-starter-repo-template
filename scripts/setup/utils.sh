#!/usr/bin/env bash
# utils.sh - Common utility functions for setup scripts

# Colors for non-gum output (prefixed to avoid conflicts)
export CLR_RED='[0;31m'
export CLR_GREEN='[0;32m'
export CLR_BLUE='[0;34m'
export CLR_YELLOW='[1;33m'
export CLR_CYAN='[0;36m'
export CLR_MAGENTA='[0;35m'
export CLR_BOLD='[1m'
export CLR_NC='[0m' # No Color

# Detect if gum is installed
export HAS_GUM=false
if command -v gum &> /dev/null; then
    export HAS_GUM=true
fi

# Platform detection
export OS="$(uname -s)"
export ARCH="$(uname -m)"
export DISTRO=""
if [[ "$OS" == "Linux" ]]; then
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        export DISTRO=$ID
    fi
fi

# Print functions that work with or without gum
print_header() {
    local text="$1"
    if [[ "$HAS_GUM" == true ]]; then
        gum style \
            --foreground 212 \
            --border double \
            --border-foreground 212 \
            --padding "1 4" \
            --margin "1 0" \
            --align center \
            "$text"
    else
        echo ""
        echo -e "${CLR_BOLD}${CLR_CYAN}════════════════════════════════════════════════${CLR_NC}"
        echo -e "${CLR_BOLD}${CLR_CYAN}    $text${CLR_NC}"
        echo -e "${CLR_BOLD}${CLR_CYAN}════════════════════════════════════════════════${CLR_NC}"
        echo ""
    fi
}

print_section() {
    local text="$1"
    if [[ "$HAS_GUM" == true ]]; then
        gum style \
            --foreground 99 \
            --border rounded \
            --border-foreground 99 \
            --padding "0 2" \
            --margin "1 0" \
            "$text"
    else
        echo ""
        echo -e "${CLR_BOLD}${CLR_MAGENTA}── $text ──${CLR_NC}"
        echo ""
    fi
}

print_success() {
    local text="$1"
    if [[ "$HAS_GUM" == true ]]; then
        gum style --foreground 82 "✓ $text"
    else
        echo -e "${CLR_GREEN}✓${CLR_NC} $text"
    fi
}

print_error() {
    local text="$1"
    if [[ "$HAS_GUM" == true ]]; then
        gum style --foreground 196 "✗ $text"
    else
        echo -e "${CLR_RED}✗${CLR_NC} $text"
    fi
}

print_warning() {
    local text="$1"
    if [[ "$HAS_GUM" == true ]]; then
        gum style --foreground 214 "⚠ $text"
    else
        echo -e "${CLR_YELLOW}⚠${CLR_NC} $text"
    fi
}

print_info() {
    local text="$1"
    if [[ "$HAS_GUM" == true ]]; then
        gum style --foreground 45 "ℹ $text"
    else
        echo -e "${CLR_BLUE}ℹ${CLR_NC} $text"
    fi
}

# Spinner function
run_with_spinner() {
    local command="$1"
    local message="$2"
    
    if [[ "$HAS_GUM" == true ]]; then
        gum spin --spinner dot --title "$message" -- bash -c "$command"
    else
        echo -n "$message... "
        if eval "$command" &> /dev/null; then
            echo "done"
        else
            echo "failed"
            return 1
        fi
    fi
}

# Check if a tool is installed
check_tool() {
    local tool="$1"
    
    if command -v "$tool" &> /dev/null; then
        TOOL_STATUS["$tool"]="installed"
        # Try to get version
        case "$tool" in
            go)
                TOOL_VERSIONS["$tool"]=$(go version | awk '{print $3}' | sed 's/go//')
                ;;
            git)
                TOOL_VERSIONS["$tool"]=$(git --version | awk '{print $3}')
                ;;
            docker)
                TOOL_VERSIONS["$tool"]=$(docker --version | awk '{print $3}' | sed 's/,//')
                ;;
            task)
                TOOL_VERSIONS["$tool"]=$(task --version | grep -o 'v[0-9.]*' | head -1)
                ;;
            kubectl)
                TOOL_VERSIONS["$tool"]=$(kubectl version --client --short 2>/dev/null | awk '{print $3}')
                ;;
            terraform)
                TOOL_VERSIONS["$tool"]=$(terraform version | head -1 | awk '{print $2}' | sed 's/v//')
                ;;
            *)
                # Try generic --version flag
                if $tool --version &> /dev/null; then
                    TOOL_VERSIONS["$tool"]=$($tool --version 2>&1 | head -1 | grep -o '[0-9.]*' | head -1)
                else
                    TOOL_VERSIONS["$tool"]="unknown"
                fi
                ;;
        esac
        return 0
    else
        TOOL_STATUS["$tool"]="missing"
        MISSING_TOOLS["$tool"]=1
        return 1
    fi
}

# Confirmation prompt
confirm() {
    local prompt="${1:-Proceed?}"
    
    if [[ "$HAS_GUM" == true ]]; then
        gum confirm "$prompt"
    else
        read -p "$prompt (y/N): " -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]]
    fi
}

# Multi-select menu (fallback when gum is not available)
multi_select() {
    local header="$1"
    shift
    local options=("$@")
    local selected=()
    
    echo "$header"
    echo ""
    
    for i in "${!options[@]}"; do
        echo "$((i+1)). ${options[$i]}"
    done
    
    echo ""
    echo "Enter numbers separated by space (e.g., 1 3 5) or 'all' for all:"
    read -r selection
    
    if [[ "$selection" == "all" ]]; then
        selected=("${options[@]}")
    else
        for num in $selection; do
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#options[@]}" ]; then
                selected+=("${options[$((num-1))]}")
            fi
        done
    fi
    
    printf '%s\n' "${selected[@]}"
}

# Export arrays for use in other scripts
export -f print_header
export -f print_section
export -f print_success
export -f print_error
export -f print_warning
export -f print_info
export -f run_with_spinner
export -f check_tool
export -f confirm
export -f multi_select