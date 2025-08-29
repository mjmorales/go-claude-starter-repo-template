#!/usr/bin/env bash
# installer.sh - Tool installation logic

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/tool-definitions.sh"

# Interactive installation mode
install_interactive() {
    print_header "🚀 Go Monorepo Setup"
    
    define_tools
    
    # Check for required tools first
    print_section "Checking Prerequisites"
    
    if ! check_tool "go"; then
        print_error "Go is not installed. Please install Go 1.23+ first."
        echo "Visit: https://go.dev/doc/install"
        exit 1
    fi
    
    print_success "Go ${TOOL_VERSIONS[go]} installed"
    
    # Select feature sets
    print_section "Select Feature Sets"
    
    local categories=(
        "core:Core Tools (git, task, docker)"
        "go-tools:Go Development Tools (gopls, linters, formatters)"
        "testing:Testing Tools (gotestsum, mockgen)"
        "api:API Development (protobuf, gRPC, OpenAPI)"
        "database:Database Tools (migrate, sqlc)"
        "quality:Code Quality (pre-commit, security scanners)"
        "kubernetes:Kubernetes Tools (kubectl, helm, kind)"
        "cloud:Cloud CLIs (AWS, GCP, Azure)"
        "infrastructure:Infrastructure Tools (Terraform)"
    )
    
    local selected_categories=()
    
    if [[ "$HAS_GUM" == true ]]; then
        # Use gum for selection
        local category_names=()
        for cat in "${categories[@]}"; do
            category_names+=("$cat")
        done
        
        selected=$(gum choose --no-limit --selected="core:Core Tools (git, task, docker)","go-tools:Go Development Tools (gopls, linters, formatters)" --header="Select feature sets to install:" "${category_names[@]}")
        
        while IFS= read -r line; do
            selected_categories+=("${line%%:*}")
        done <<< "$selected"
    else
        # Fallback to basic selection
        echo "Select feature sets to install (y/n):"
        echo ""
        
        for cat in "${categories[@]}"; do
            local key="${cat%%:*}"
            local desc="${cat#*:}"
            
            # Auto-select core and go-tools
            if [[ "$key" == "core" ]] || [[ "$key" == "go-tools" ]]; then
                echo -e "${CLR_GREEN}✓${CLR_NC} $desc (required)"
                selected_categories+=("$key")
            else
                read -p "Install $desc? (y/N): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    selected_categories+=("$key")
                fi
            fi
        done
    fi
    
    # Build list of tools to install
    local tools_to_install=()
    
    for category in "${selected_categories[@]}"; do
        for tool in "${!TOOL_CATEGORIES[@]}"; do
            if [[ "${TOOL_CATEGORIES[$tool]}" == "$category" ]]; then
                if ! check_tool "$tool"; then
                    tools_to_install+=("$tool")
                fi
            fi
        done
    done
    
    if [[ ${#tools_to_install[@]} -eq 0 ]]; then
        print_success "All selected tools are already installed!"
        return 0
    fi
    
    # Show installation plan
    print_section "Installation Plan"
    
    echo "The following tools will be installed:"
    echo ""
    
    for tool in "${tools_to_install[@]}"; do
        echo "  • $tool - ${TOOL_DESCRIPTIONS[$tool]}"
    done
    
    echo ""
    
    if ! confirm "Proceed with installation?"; then
        exit 0
    fi
    
    # Install tools
    print_section "Installing Tools"
    
    local failed_tools=()
    
    for tool in "${tools_to_install[@]}"; do
        install_tool "$tool" || failed_tools+=("$tool")
    done
    
    # Post-installation setup
    post_install_setup
    
    # Summary
    print_section "✅ Setup Complete"
    
    if [[ ${#failed_tools[@]} -gt 0 ]]; then
        print_warning "Some tools failed to install: ${failed_tools[*]}"
        echo "Please install them manually using the commands shown above."
    else
        print_success "All selected tools installed successfully!"
    fi
    
    echo ""
    echo "Next steps:"
    echo "  1. Run 'setup.sh doctor' to verify your setup"
    echo "  2. Run 'task init' to initialize the project"
    echo "  3. Start coding! 🚀"
}

# Install a specific tool
install_tool() {
    local tool="$1"
    
    print_info "Installing $tool..."
    
    # Determine installation method
    local install_cmd="${TOOL_INSTALL_CMDS[$tool]}"
    
    # Handle Go tools specially
    if [[ "$install_cmd" == go\ install* ]]; then
        if run_with_spinner "$install_cmd" "Installing $tool"; then
            print_success "$tool installed successfully"
            return 0
        else
            print_error "Failed to install $tool"
            return 1
        fi
    elif [[ "$tool" == "task" ]]; then
        # Special handling for task
        if run_with_spinner 'sh -c "$(curl -ssL https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin' "Installing task"; then
            print_success "task installed successfully"
            print_info "Add ~/.local/bin to your PATH if not already present"
            return 0
        else
            print_error "Failed to install task"
            return 1
        fi
    else
        # For system tools, just show the command
        print_info "Manual installation required:"
        echo "  $install_cmd"
        return 1
    fi
}

# Quick install presets
install_preset() {
    local preset="$1"
    
    define_tools
    
    case "$preset" in
        minimal)
            print_header "Installing Minimal Setup"
            local tools=("git" "task" "docker" "gopls" "goimports" "golangci-lint")
            ;;
        recommended)
            print_header "Installing Recommended Setup"
            local tools=("git" "task" "docker" "docker-compose" "gopls" "goimports" 
                        "golangci-lint" "gofumpt" "air" "gotestsum" "mockgen" 
                        "staticcheck" "gosec" "pre-commit")
            ;;
        full)
            print_header "Installing Full Setup"
            local tools=()
            for tool in "${!TOOL_DESCRIPTIONS[@]}"; do
                tools+=("$tool")
            done
            ;;
        *)
            print_error "Unknown preset: $preset"
            echo "Available presets: minimal, recommended, full"
            exit 1
            ;;
    esac
    
    print_info "Installing $preset tool set..."
    
    local failed_tools=()
    
    for tool in "${tools[@]}"; do
        if ! check_tool "$tool"; then
            install_tool "$tool" || failed_tools+=("$tool")
        else
            print_success "$tool already installed"
        fi
    done
    
    post_install_setup
    
    if [[ ${#failed_tools[@]} -gt 0 ]]; then
        print_warning "Some tools require manual installation: ${failed_tools[*]}"
    else
        print_success "Installation complete!"
    fi
}

# Post-installation setup tasks
post_install_setup() {
    print_section "Post-Installation Setup"
    
    # Initialize pre-commit if installed
    if check_tool "pre-commit" && [[ -f ".pre-commit-config.yaml" ]]; then
        print_info "Setting up pre-commit hooks..."
        if run_with_spinner "pre-commit install" "Installing pre-commit hooks"; then
            print_success "Pre-commit hooks installed"
        fi
    fi
    
    # Create go.work if it doesn't exist
    if [[ ! -f "go.work" ]] && [[ -d "cmd" ]]; then
        print_info "Initializing Go workspace..."
        if run_with_spinner "go work init" "Creating go.work"; then
            print_success "Go workspace initialized"
        fi
    fi
    
    # Check for Claude config
    if [[ -f "scripts/setup/install-claude-config.sh" ]]; then
        print_info "Claude configuration installer available"
        echo "Run 'scripts/setup/install-claude-config.sh' to set up Claude AI integration"
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Check for preset argument
    if [[ $# -gt 0 ]]; then
        install_preset "$1"
    else
        install_interactive
    fi
fi