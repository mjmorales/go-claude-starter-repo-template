#!/usr/bin/env bash
# doctor.sh - Comprehensive environment health check

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/tool-definitions.sh"

# Doctor mode - comprehensive system check
doctor_mode() {
    print_header "🏥 Go Monorepo Doctor"
    
    define_tools
    
    print_section "System Information"
    echo "OS: $OS"
    echo "Architecture: $ARCH"
    [[ -n "$DISTRO" ]] && echo "Distribution: $DISTRO"
    echo ""
    
    # Check Go environment
    print_section "Go Environment"
    if check_tool "go"; then
        print_success "Go ${TOOL_VERSIONS[go]} installed"
        
        # Check Go version requirement
        GO_VERSION="${TOOL_VERSIONS[go]}"
        GO_MAJOR=$(echo "$GO_VERSION" | cut -d. -f1)
        GO_MINOR=$(echo "$GO_VERSION" | cut -d. -f2)
        
        if [[ "$GO_MAJOR" -eq 1 && "$GO_MINOR" -ge 23 ]] || [[ "$GO_MAJOR" -gt 1 ]]; then
            print_success "Go version meets requirements (1.23+)"
        else
            print_warning "Go version $GO_VERSION is below recommended 1.23+"
        fi
        
        echo ""
        echo "GOPATH: $(go env GOPATH)"
        echo "GOROOT: $(go env GOROOT)"
        echo "GOBIN: $(go env GOBIN)"
        echo "GO111MODULE: $(go env GO111MODULE)"
        echo "GOPROXY: $(go env GOPROXY)"
    else
        print_error "Go not installed - this is required!"
    fi
    echo ""
    
    # Core tools check
    print_section "Core Tools Status"
    
    local core_tools=("git" "task" "docker" "docker-compose")
    for tool in "${core_tools[@]}"; do
        if check_tool "$tool"; then
            print_success "$tool ${TOOL_VERSIONS[$tool]} - ${TOOL_DESCRIPTIONS[$tool]}"
        else
            print_error "$tool - ${TOOL_DESCRIPTIONS[$tool]}"
            echo "  Install: ${TOOL_INSTALL_CMDS[$tool]}"
        fi
    done
    echo ""
    
    # Development tools check
    print_section "Development Tools"
    
    local dev_tools=("gopls" "goimports" "golangci-lint" "air" "gotestsum" "mockgen" "dlv")
    for tool in "${dev_tools[@]}"; do
        if check_tool "$tool"; then
            print_success "$tool - ${TOOL_DESCRIPTIONS[$tool]}"
        else
            print_warning "$tool - ${TOOL_DESCRIPTIONS[$tool]} (optional)"
        fi
    done
    echo ""
    
    # API Development tools
    print_section "API Development Tools"
    
    local api_tools=("protoc" "buf" "protoc-gen-go" "protoc-gen-go-grpc" "swag")
    local has_api_tools=false
    for tool in "${api_tools[@]}"; do
        if check_tool "$tool"; then
            print_success "$tool - ${TOOL_DESCRIPTIONS[$tool]}"
            has_api_tools=true
        else
            print_info "$tool - ${TOOL_DESCRIPTIONS[$tool]} (needed for API development)"
        fi
    done
    
    if [[ "$has_api_tools" == false ]]; then
        print_info "No API tools installed. Install these if you're building gRPC/REST APIs."
    fi
    echo ""
    
    # Quality tools
    print_section "Code Quality Tools"
    
    local quality_tools=("staticcheck" "gosec" "gofumpt" "pre-commit" "shellcheck" "hadolint")
    for tool in "${quality_tools[@]}"; do
        if check_tool "$tool"; then
            print_success "$tool - ${TOOL_DESCRIPTIONS[$tool]}"
        else
            print_info "$tool - ${TOOL_DESCRIPTIONS[$tool]} (recommended)"
        fi
    done
    echo ""
    
    # Kubernetes tools (if Docker is installed)
    if [[ "${TOOL_STATUS[docker]}" == "installed" ]]; then
        print_section "Container Orchestration"
        
        local k8s_tools=("kubectl" "helm" "kind" "kustomize")
        local has_k8s=false
        for tool in "${k8s_tools[@]}"; do
            if check_tool "$tool"; then
                print_success "$tool - ${TOOL_DESCRIPTIONS[$tool]}"
                has_k8s=true
            else
                print_info "$tool - ${TOOL_DESCRIPTIONS[$tool]} (for Kubernetes development)"
            fi
        done
        
        if [[ "$has_k8s" == true ]]; then
            # Check kubectl connectivity
            if kubectl cluster-info &> /dev/null; then
                print_success "kubectl connected to cluster"
            else
                print_info "kubectl installed but not connected to a cluster"
            fi
        fi
        echo ""
    fi
    
    # Summary and recommendations
    print_section "📋 Diagnosis Summary"
    
    local missing_core=()
    local missing_recommended=()
    local missing_optional=()
    
    for tool in "${!TOOL_STATUS[@]}"; do
        if [[ "${TOOL_STATUS[$tool]}" == "missing" ]]; then
            case "${TOOL_CATEGORIES[$tool]}" in
                core)
                    missing_core+=("$tool")
                    ;;
                go-tools|testing|quality)
                    missing_recommended+=("$tool")
                    ;;
                *)
                    missing_optional+=("$tool")
                    ;;
            esac
        fi
    done
    
    if [[ ${#missing_core[@]} -eq 0 ]]; then
        print_success "All core tools installed!"
    else
        print_error "Missing ${#missing_core[@]} core tools: ${missing_core[*]}"
    fi
    
    if [[ ${#missing_recommended[@]} -gt 0 ]]; then
        print_warning "Missing ${#missing_recommended[@]} recommended tools"
    fi
    
    echo ""
    print_section "💊 Prescriptions"
    
    if [[ ${#missing_core[@]} -gt 0 ]]; then
        echo "🔴 Critical - Install these immediately:"
        for tool in "${missing_core[@]}"; do
            echo "  $tool: ${TOOL_INSTALL_CMDS[$tool]}"
        done
        echo ""
    fi
    
    if [[ ${#missing_recommended[@]} -gt 0 ]]; then
        echo "🟡 Recommended - Install for better development experience:"
        echo "  Run: setup.sh install --recommended"
        echo ""
    fi
    
    # Health score
    local total_tools=${#TOOL_STATUS[@]}
    local installed_tools=0
    for status in "${TOOL_STATUS[@]}"; do
        [[ "$status" == "installed" ]] && ((installed_tools++))
    done
    
    local health_score=$((installed_tools * 100 / total_tools))
    
    print_section "🏆 Health Score: $health_score%"
    
    if [[ $health_score -ge 80 ]]; then
        print_success "Excellent! Your environment is well-configured."
    elif [[ $health_score -ge 60 ]]; then
        print_warning "Good, but could be improved with additional tools."
    elif [[ $health_score -ge 40 ]]; then
        print_warning "Fair. Consider installing recommended tools."
    else
        print_error "Poor. Many essential tools are missing."
    fi
    
    echo ""
    if [[ "$HAS_GUM" == false ]]; then
        print_info "Tip: Install 'gum' for a better experience with this script"
        echo "  go install github.com/charmbracelet/gum@latest"
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    doctor_mode
fi