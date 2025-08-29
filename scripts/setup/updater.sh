#!/usr/bin/env bash
# updater.sh - Update installed Go tools

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/tool-definitions.sh"

# Update all Go tools
update_tools() {
    print_header "Updating Go Tools"
    
    define_tools
    
    local go_tools=()
    for tool in "${!TOOL_CATEGORIES[@]}"; do
        if [[ "${TOOL_INSTALL_CMDS[$tool]}" == go\ install* ]]; then
            if check_tool "$tool"; then
                go_tools+=("$tool")
            fi
        fi
    done
    
    if [[ ${#go_tools[@]} -eq 0 ]]; then
        print_info "No Go tools installed to update"
        return 0
    fi
    
    print_info "Found ${#go_tools[@]} Go tools to update"
    echo ""
    
    # Show tools to be updated
    echo "Tools to update:"
    for tool in "${go_tools[@]}"; do
        echo "  • $tool - ${TOOL_DESCRIPTIONS[$tool]}"
    done
    echo ""
    
    if ! confirm "Proceed with updates?"; then
        return 0
    fi
    
    print_section "Updating Tools"
    
    local updated=0
    local failed=0
    
    for tool in "${go_tools[@]}"; do
        local install_cmd="${TOOL_INSTALL_CMDS[$tool]}"
        if run_with_spinner "$install_cmd" "Updating $tool"; then
            print_success "$tool updated"
            ((updated++))
        else
            print_error "Failed to update $tool"
            ((failed++))
        fi
    done
    
    print_section "Update Summary"
    
    echo "Updated: $updated tools"
    if [[ $failed -gt 0 ]]; then
        echo "Failed: $failed tools"
        print_warning "Some tools failed to update. Check the errors above."
    else
        print_success "All tools updated successfully!"
    fi
    
    # Clean Go module cache
    if confirm "Clean Go module cache (recommended)?"; then
        if run_with_spinner "go clean -modcache" "Cleaning module cache"; then
            print_success "Module cache cleaned"
        else
            print_warning "Failed to clean module cache"
        fi
    fi
}

# Update specific category of tools
update_category() {
    local category="$1"
    
    define_tools
    
    print_header "Updating $category Tools"
    
    local tools_in_category=()
    for tool in "${!TOOL_CATEGORIES[@]}"; do
        if [[ "${TOOL_CATEGORIES[$tool]}" == "$category" ]]; then
            if [[ "${TOOL_INSTALL_CMDS[$tool]}" == go\ install* ]] && check_tool "$tool"; then
                tools_in_category+=("$tool")
            fi
        fi
    done
    
    if [[ ${#tools_in_category[@]} -eq 0 ]]; then
        print_info "No $category Go tools installed to update"
        return 0
    fi
    
    print_info "Updating ${#tools_in_category[@]} $category tools..."
    
    for tool in "${tools_in_category[@]}"; do
        local install_cmd="${TOOL_INSTALL_CMDS[$tool]}"
        if run_with_spinner "$install_cmd" "Updating $tool"; then
            print_success "$tool updated"
        else
            print_error "Failed to update $tool"
        fi
    done
}

# Check for outdated tools
check_outdated() {
    print_header "Checking for Outdated Tools"
    
    define_tools
    
    print_info "Checking installed Go tools for updates..."
    echo ""
    
    local go_tools=()
    for tool in "${!TOOL_CATEGORIES[@]}"; do
        if [[ "${TOOL_INSTALL_CMDS[$tool]}" == go\ install* ]]; then
            if check_tool "$tool"; then
                go_tools+=("$tool")
            fi
        fi
    done
    
    if [[ ${#go_tools[@]} -eq 0 ]]; then
        print_info "No Go tools installed"
        return 0
    fi
    
    # Check Go module updates
    print_section "Checking for Updates"
    
    # Create a temporary go.mod to check for updates
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    go mod init temp-check &> /dev/null
    
    for tool in "${go_tools[@]}"; do
        local install_cmd="${TOOL_INSTALL_CMDS[$tool]}"
        # Extract the module path from the install command
        local module_path=$(echo "$install_cmd" | sed -n 's/go install \(.*\)@.*/\1/p')
        
        if [[ -n "$module_path" ]]; then
            echo -n "Checking $tool... "
            # Try to get the module and check for updates
            if go list -m -u "$module_path@latest" &> /dev/null; then
                echo "update available"
            else
                echo "up to date"
            fi
        fi
    done
    
    cd - > /dev/null
    rm -rf "$temp_dir"
    
    echo ""
    print_info "Run 'setup.sh update' to update all tools"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Parse arguments
    case "${1:-}" in
        --check)
            check_outdated
            ;;
        --category)
            if [[ -n "${2:-}" ]]; then
                update_category "$2"
            else
                print_error "Category name required"
                exit 1
            fi
            ;;
        *)
            update_tools
            ;;
    esac
fi