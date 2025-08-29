#!/usr/bin/env bash
# setup.sh - Go Monorepo Setup Orchestrator
# Orchestrates setup subscripts for modular functionality

set -euo pipefail

# Script version
VERSION="1.0.0"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_SCRIPTS_DIR="$SCRIPT_DIR/scripts/setup"

# Check if setup scripts directory exists
if [[ ! -d "$SETUP_SCRIPTS_DIR" ]]; then
    echo "Error: Setup scripts directory not found at $SETUP_SCRIPTS_DIR"
    echo "Please ensure the setup scripts are properly installed."
    exit 1
fi

# Source utilities
source "$SETUP_SCRIPTS_DIR/utils.sh"

# Show help
show_help() {
    cat << EOF
Go Monorepo Setup Script v$VERSION

A comprehensive tool for setting up and maintaining a Go monorepo development environment.

USAGE:
    $0 [COMMAND] [OPTIONS]

COMMANDS:
    doctor              Run comprehensive environment diagnosis
    install             Interactive installation wizard
    install <preset>    Install preset tool collection
                       Presets: minimal, recommended, full
    update              Update all installed Go tools
    help                Show this help message

OPTIONS:
    --no-gum           Disable gum UI enhancements
    --verbose          Show detailed output

EXAMPLES:
    $0 doctor                    # Check your environment
    $0 install                   # Interactive setup
    $0 install recommended       # Install recommended tools
    $0 update                    # Update all Go tools

DOCTOR MODE:
    The doctor command performs a comprehensive check of your development
    environment, including:
    - System information
    - Go environment configuration
    - Tool installation status
    - Version compatibility
    - Health score and recommendations

INSTALLATION PRESETS:
    minimal:      Core tools only (git, task, docker, basic Go tools)
    recommended:  Standard development setup with testing and quality tools
    full:         Everything including Kubernetes, cloud CLIs, and infrastructure tools

For more information, visit: https://github.com/yourorg/go-monorepo-template
EOF
}

# Main script logic
main() {
    local command="${1:-}"
    shift || true
    
    # Check for --no-gum flag
    if [[ "$*" == *"--no-gum"* ]]; then
        export HAS_GUM=false
    fi
    
    case "$command" in
        doctor)
            bash "$SETUP_SCRIPTS_DIR/doctor.sh"
            ;;
        install)
            if [[ -n "${1:-}" ]]; then
                bash "$SETUP_SCRIPTS_DIR/installer.sh" "$1"
            else
                bash "$SETUP_SCRIPTS_DIR/installer.sh"
            fi
            ;;
        update)
            bash "$SETUP_SCRIPTS_DIR/updater.sh"
            ;;
        help|--help|-h)
            show_help
            ;;
        "")
            # No command - show interactive menu
            if [[ "$HAS_GUM" == true ]]; then
                print_header "🚀 Go Monorepo Setup"
                choice=$(gum choose "Doctor - Check environment" "Install - Setup tools" "Update - Update Go tools" "Help - Show documentation" "Exit")
                
                case "$choice" in
                    "Doctor"*)
                        bash "$SETUP_SCRIPTS_DIR/doctor.sh"
                        ;;
                    "Install"*)
                        bash "$SETUP_SCRIPTS_DIR/installer.sh"
                        ;;
                    "Update"*)
                        bash "$SETUP_SCRIPTS_DIR/updater.sh"
                        ;;
                    "Help"*)
                        show_help
                        ;;
                    *)
                        exit 0
                        ;;
                esac
            else
                show_help
            fi
            ;;
        *)
            print_error "Unknown command: $command"
            echo "Run '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
