#!/usr/bin/env bash
# install-claude-config.sh - Install Claude AI configuration files
# This script copies recommended Claude configuration from a source directory

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SOURCE_DIR="${PROJECT_ROOT}/delete_after_copying"
BACKUP_DIR="${PROJECT_ROOT}/.claude-backup-$(date +%Y%m%d-%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo ""
    echo -e "${BOLD}${CYAN}════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}    Claude Configuration Installer${NC}"
    echo -e "${BOLD}${CYAN}════════════════════════════════════════════════${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if source directory exists
check_source() {
    if [[ ! -d "$SOURCE_DIR" ]]; then
        print_error "Source directory not found: $SOURCE_DIR"
        echo "Please ensure the Claude configuration files are in:"
        echo "  $SOURCE_DIR"
        exit 1
    fi
    
    # Check for required files
    local required_files=(
        ".mcp.json"
        ".claude"
    )
    
    for file in "${required_files[@]}"; do
        if [[ ! -e "$SOURCE_DIR/$file" ]]; then
            print_error "Required file/directory not found: $SOURCE_DIR/$file"
            exit 1
        fi
    done
    
    print_success "Source directory verified"
}

# Backup existing configuration
backup_existing() {
    local has_backup=false
    
    # Check if any Claude files exist
    if [[ -f "$PROJECT_ROOT/.mcp.json" ]] || [[ -d "$PROJECT_ROOT/.claude" ]]; then
        print_info "Backing up existing Claude configuration..."
        mkdir -p "$BACKUP_DIR"
        
        if [[ -f "$PROJECT_ROOT/.mcp.json" ]]; then
            cp "$PROJECT_ROOT/.mcp.json" "$BACKUP_DIR/"
            has_backup=true
        fi
        
        if [[ -d "$PROJECT_ROOT/.claude" ]]; then
            cp -r "$PROJECT_ROOT/.claude" "$BACKUP_DIR/"
            has_backup=true
        fi
        
        if [[ "$has_backup" == true ]]; then
            print_success "Existing configuration backed up to: $BACKUP_DIR"
        fi
    fi
}

# Copy Claude configuration files
install_claude_config() {
    print_info "Installing Claude configuration files..."
    
    # Copy .mcp.json
    if [[ -f "$SOURCE_DIR/.mcp.json" ]]; then
        cp "$SOURCE_DIR/.mcp.json" "$PROJECT_ROOT/.mcp.json"
        print_success "Installed .mcp.json"
        
        # Update workspace path in .mcp.json
        update_mcp_config
    fi
    
    # Copy .claude directory
    if [[ -d "$SOURCE_DIR/.claude" ]]; then
        # Remove existing .claude directory if it exists
        if [[ -d "$PROJECT_ROOT/.claude" ]]; then
            rm -rf "$PROJECT_ROOT/.claude"
        fi
        
        cp -r "$SOURCE_DIR/.claude" "$PROJECT_ROOT/"
        print_success "Installed .claude directory"
        
        # Count installed files
        local agent_count=$(find "$PROJECT_ROOT/.claude/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        local command_count=$(find "$PROJECT_ROOT/.claude/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        
        if [[ "$agent_count" -gt 0 ]]; then
            print_info "  Installed $agent_count agent configurations"
        fi
        
        if [[ "$command_count" -gt 0 ]]; then
            print_info "  Installed $command_count command configurations"
        fi
    fi
}

# Update .mcp.json with correct workspace path
update_mcp_config() {
    local mcp_file="$PROJECT_ROOT/.mcp.json"
    
    if [[ -f "$mcp_file" ]]; then
        # Update the workspace path
        if [[ "$(uname)" == "Darwin" ]]; then
            # macOS
            sed -i '' "s|REPLACE_ME_WITH_YOUR_WORKSPACE_PATH|$PROJECT_ROOT|g" "$mcp_file"
        else
            # Linux
            sed -i "s|REPLACE_ME_WITH_YOUR_WORKSPACE_PATH|$PROJECT_ROOT|g" "$mcp_file"
        fi
        
        print_success "Updated workspace path in .mcp.json"
    fi
}

# Add Claude files to .gitignore if not already present
update_gitignore() {
    local gitignore="$PROJECT_ROOT/.gitignore"
    local claude_patterns=(
        ".claude"
        ".mcp.json"
        ".claude-backup-*"
        "delete_after_copying"
    )
    
    if [[ -f "$gitignore" ]]; then
        print_info "Updating .gitignore..."
        
        for pattern in "${claude_patterns[@]}"; do
            # Escape special characters for grep
            local escaped_pattern=$(echo "$pattern" | sed 's/[[\.*^$()+?{|]/\&/g')
            if ! grep -q "^$escaped_pattern$" "$gitignore" 2>/dev/null; then
                echo "$pattern" >> "$gitignore"
                print_success "Added $pattern to .gitignore"
            fi
        done
    fi
}

# Clean up source directory if requested
cleanup_source() {
    if [[ "${1:-}" == "--cleanup" ]] || [[ "${1:-}" == "-c" ]]; then
        read -p "Remove source directory '$SOURCE_DIR'? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$SOURCE_DIR"
            print_success "Removed source directory"
        fi
    fi
}

# Verify installation
verify_installation() {
    print_info "Verifying installation..."
    
    local all_good=true
    
    # Check .mcp.json
    if [[ -f "$PROJECT_ROOT/.mcp.json" ]]; then
        print_success ".mcp.json is present"
        
        # Check if workspace path was updated
        if grep -q "REPLACE_ME_WITH_YOUR_WORKSPACE_PATH" "$PROJECT_ROOT/.mcp.json"; then
            print_warning "Workspace path needs to be updated in .mcp.json"
            all_good=false
        fi
    else
        print_error ".mcp.json is missing"
        all_good=false
    fi
    
    # Check .claude directory
    if [[ -d "$PROJECT_ROOT/.claude" ]]; then
        print_success ".claude directory is present"
    else
        print_error ".claude directory is missing"
        all_good=false
    fi
    
    # Check for agents
    if [[ -d "$PROJECT_ROOT/.claude/agents" ]]; then
        local agent_files=$(find "$PROJECT_ROOT/.claude/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        if [[ "$agent_files" -gt 0 ]]; then
            print_success "Found $agent_files agent configurations"
        else
            print_warning "No agent configurations found"
        fi
    fi
    
    # Check for commands
    if [[ -d "$PROJECT_ROOT/.claude/commands" ]]; then
        local command_files=$(find "$PROJECT_ROOT/.claude/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        if [[ "$command_files" -gt 0 ]]; then
            print_success "Found $command_files command configurations"
        else
            print_warning "No command configurations found"
        fi
    fi
    
    if [[ "$all_good" == true ]]; then
        print_success "Installation verified successfully!"
    else
        print_warning "Installation completed with warnings"
    fi
}

# Show available agents and commands
show_available_features() {
    echo ""
    echo -e "${BOLD}Available Claude Features:${NC}"
    echo ""
    
    # List agents
    if [[ -d "$PROJECT_ROOT/.claude/agents" ]]; then
        echo -e "${CYAN}Agents:${NC}"
        for agent in "$PROJECT_ROOT/.claude/agents"/*.md; do
            if [[ -f "$agent" ]]; then
                local name=$(basename "$agent" .md)
                echo "  • $name"
            fi
        done
        echo ""
    fi
    
    # List commands
    if [[ -d "$PROJECT_ROOT/.claude/commands" ]]; then
        echo -e "${CYAN}Commands:${NC}"
        for cmd in "$PROJECT_ROOT/.claude/commands"/*.md; do
            if [[ -f "$cmd" ]]; then
                local name=$(basename "$cmd" .md)
                echo "  • /$name"
            fi
        done
        echo ""
    fi
}

# Show usage instructions
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install Claude AI configuration files for the project.

OPTIONS:
    -c, --cleanup     Remove source directory after installation
    -h, --help        Show this help message
    -v, --verify      Only verify existing installation

EXAMPLES:
    $0                Install Claude configuration
    $0 --cleanup      Install and remove source directory
    $0 --verify       Check existing installation

The script will:
1. Check for source files in: $SOURCE_DIR
2. Backup any existing Claude configuration
3. Install .mcp.json and .claude directory
4. Update workspace paths
5. Update .gitignore
6. Verify the installation

EOF
}

# Main execution
main() {
    case "${1:-}" in
        -h|--help)
            show_usage
            exit 0
            ;;
        -v|--verify)
            print_header
            verify_installation
            show_available_features
            exit 0
            ;;
        *)
            print_header
            
            # Run installation steps
            check_source
            backup_existing
            install_claude_config
            update_gitignore
            cleanup_source "$@"
            
            echo ""
            verify_installation
            show_available_features
            
            # Show next steps
            echo -e "${BOLD}Next Steps:${NC}"
            echo "1. Restart Claude Desktop to load the new configuration"
            echo "2. Use available agents with: @agent-name"
            echo "3. Use available commands with: /command-name"
            echo ""
            echo "To integrate with Taskfile, run: task claude:setup"
            ;;
    esac
}

# Run main function
main "$@"