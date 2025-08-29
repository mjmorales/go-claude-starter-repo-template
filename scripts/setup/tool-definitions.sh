#!/usr/bin/env bash
# tool-definitions.sh - Tool metadata and definitions

# Installation tracking arrays
declare -gA TOOL_STATUS
declare -gA TOOL_VERSIONS
declare -gA TOOL_INSTALL_CMDS
declare -gA TOOL_DESCRIPTIONS
declare -gA TOOL_CATEGORIES
declare -gA MISSING_TOOLS
declare -gA OPTIONAL_TOOLS

# Tool definitions function
define_tools() {
    # Core Tools (Required)
    TOOL_DESCRIPTIONS["go"]="Go programming language (1.23+)"
    TOOL_CATEGORIES["go"]="core"
    TOOL_INSTALL_CMDS["go"]="See https://go.dev/doc/install"
    
    TOOL_DESCRIPTIONS["git"]="Version control system"
    TOOL_CATEGORIES["git"]="core"
    TOOL_INSTALL_CMDS["git"]="brew install git | apt install git"
    
    TOOL_DESCRIPTIONS["task"]="Task runner (Makefile alternative)"
    TOOL_CATEGORIES["task"]="core"
    TOOL_INSTALL_CMDS["task"]='sh -c "$(curl -ssL https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin'
    
    # Container Tools
    TOOL_DESCRIPTIONS["docker"]="Container runtime"
    TOOL_CATEGORIES["docker"]="containers"
    TOOL_INSTALL_CMDS["docker"]="See https://docs.docker.com/get-docker/"
    
    TOOL_DESCRIPTIONS["docker-compose"]="Container orchestration"
    TOOL_CATEGORIES["docker-compose"]="containers"
    TOOL_INSTALL_CMDS["docker-compose"]="Included with Docker Desktop"
    
    # Go Development Tools
    TOOL_DESCRIPTIONS["gopls"]="Go language server"
    TOOL_CATEGORIES["gopls"]="go-tools"
    TOOL_INSTALL_CMDS["gopls"]="go install golang.org/x/tools/gopls@latest"
    
    TOOL_DESCRIPTIONS["goimports"]="Go import formatter"
    TOOL_CATEGORIES["goimports"]="go-tools"
    TOOL_INSTALL_CMDS["goimports"]="go install golang.org/x/tools/cmd/goimports@latest"
    
    TOOL_DESCRIPTIONS["golangci-lint"]="Go linter aggregator"
    TOOL_CATEGORIES["golangci-lint"]="go-tools"
    TOOL_INSTALL_CMDS["golangci-lint"]="go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
    
    TOOL_DESCRIPTIONS["gofumpt"]="Stricter Go formatter"
    TOOL_CATEGORIES["gofumpt"]="go-tools"
    TOOL_INSTALL_CMDS["gofumpt"]="go install mvdan.cc/gofumpt@latest"
    
    TOOL_DESCRIPTIONS["air"]="Hot reload for Go"
    TOOL_CATEGORIES["air"]="go-tools"
    TOOL_INSTALL_CMDS["air"]="go install github.com/air-verse/air@latest"
    
    TOOL_DESCRIPTIONS["gotestsum"]="Better test output"
    TOOL_CATEGORIES["gotestsum"]="testing"
    TOOL_INSTALL_CMDS["gotestsum"]="go install gotest.tools/gotestsum@latest"
    
    TOOL_DESCRIPTIONS["mockgen"]="Mock generator"
    TOOL_CATEGORIES["mockgen"]="testing"
    TOOL_INSTALL_CMDS["mockgen"]="go install go.uber.org/mock/mockgen@latest"
    
    TOOL_DESCRIPTIONS["staticcheck"]="Static analysis"
    TOOL_CATEGORIES["staticcheck"]="quality"
    TOOL_INSTALL_CMDS["staticcheck"]="go install honnef.co/go/tools/cmd/staticcheck@latest"
    
    TOOL_DESCRIPTIONS["gosec"]="Security scanner"
    TOOL_CATEGORIES["gosec"]="security"
    TOOL_INSTALL_CMDS["gosec"]="go install github.com/securego/gosec/v2/cmd/gosec@latest"
    
    TOOL_DESCRIPTIONS["dlv"]="Go debugger"
    TOOL_CATEGORIES["dlv"]="debugging"
    TOOL_INSTALL_CMDS["dlv"]="go install github.com/go-delve/delve/cmd/dlv@latest"
    
    # API Tools
    TOOL_DESCRIPTIONS["protoc"]="Protocol buffer compiler"
    TOOL_CATEGORIES["protoc"]="api"
    TOOL_INSTALL_CMDS["protoc"]="brew install protobuf | apt install protobuf-compiler"
    
    TOOL_DESCRIPTIONS["buf"]="Better protobuf tooling"
    TOOL_CATEGORIES["buf"]="api"
    TOOL_INSTALL_CMDS["buf"]="go install github.com/bufbuild/buf/cmd/buf@latest"
    
    TOOL_DESCRIPTIONS["protoc-gen-go"]="Go protobuf generator"
    TOOL_CATEGORIES["protoc-gen-go"]="api"
    TOOL_INSTALL_CMDS["protoc-gen-go"]="go install google.golang.org/protobuf/cmd/protoc-gen-go@latest"
    
    TOOL_DESCRIPTIONS["protoc-gen-go-grpc"]="Go gRPC generator"
    TOOL_CATEGORIES["protoc-gen-go-grpc"]="api"
    TOOL_INSTALL_CMDS["protoc-gen-go-grpc"]="go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest"
    
    TOOL_DESCRIPTIONS["swag"]="Swagger generator"
    TOOL_CATEGORIES["swag"]="api"
    TOOL_INSTALL_CMDS["swag"]="go install github.com/swaggo/swag/cmd/swag@latest"
    
    TOOL_DESCRIPTIONS["oapi-codegen"]="OpenAPI code generator"
    TOOL_CATEGORIES["oapi-codegen"]="api"
    TOOL_INSTALL_CMDS["oapi-codegen"]="go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@latest"
    
    # Database Tools
    TOOL_DESCRIPTIONS["migrate"]="Database migration tool"
    TOOL_CATEGORIES["migrate"]="database"
    TOOL_INSTALL_CMDS["migrate"]="go install -tags 'postgres mysql' github.com/golang-migrate/migrate/v4/cmd/migrate@latest"
    
    TOOL_DESCRIPTIONS["sqlc"]="SQL compiler"
    TOOL_CATEGORIES["sqlc"]="database"
    TOOL_INSTALL_CMDS["sqlc"]="go install github.com/kyleconroy/sqlc/cmd/sqlc@latest"
    
    # Kubernetes Tools
    TOOL_DESCRIPTIONS["kubectl"]="Kubernetes CLI"
    TOOL_CATEGORIES["kubectl"]="kubernetes"
    TOOL_INSTALL_CMDS["kubectl"]="brew install kubectl | See https://kubernetes.io/docs/tasks/tools/"
    
    TOOL_DESCRIPTIONS["helm"]="Kubernetes package manager"
    TOOL_CATEGORIES["helm"]="kubernetes"
    TOOL_INSTALL_CMDS["helm"]="brew install helm | See https://helm.sh/docs/intro/install/"
    
    TOOL_DESCRIPTIONS["kind"]="Kubernetes in Docker"
    TOOL_CATEGORIES["kind"]="kubernetes"
    TOOL_INSTALL_CMDS["kind"]="go install sigs.k8s.io/kind@latest"
    
    TOOL_DESCRIPTIONS["kustomize"]="Kubernetes customization"
    TOOL_CATEGORIES["kustomize"]="kubernetes"
    TOOL_INSTALL_CMDS["kustomize"]="brew install kustomize | go install sigs.k8s.io/kustomize/kustomize/v5@latest"
    
    # Infrastructure Tools
    TOOL_DESCRIPTIONS["terraform"]="Infrastructure as Code"
    TOOL_CATEGORIES["terraform"]="infrastructure"
    TOOL_INSTALL_CMDS["terraform"]="brew install terraform | See https://www.terraform.io/downloads"
    
    TOOL_DESCRIPTIONS["aws"]="AWS CLI"
    TOOL_CATEGORIES["aws"]="cloud"
    TOOL_INSTALL_CMDS["aws"]="brew install awscli | See https://aws.amazon.com/cli/"
    
    TOOL_DESCRIPTIONS["gcloud"]="Google Cloud CLI"
    TOOL_CATEGORIES["gcloud"]="cloud"
    TOOL_INSTALL_CMDS["gcloud"]="See https://cloud.google.com/sdk/docs/install"
    
    TOOL_DESCRIPTIONS["az"]="Azure CLI"
    TOOL_CATEGORIES["az"]="cloud"
    TOOL_INSTALL_CMDS["az"]="brew install azure-cli | See https://docs.microsoft.com/cli/azure/install"
    
    # Quality Tools
    TOOL_DESCRIPTIONS["pre-commit"]="Git hooks framework"
    TOOL_CATEGORIES["pre-commit"]="quality"
    TOOL_INSTALL_CMDS["pre-commit"]="pip install pre-commit | pipx install pre-commit"
    
    TOOL_DESCRIPTIONS["hadolint"]="Dockerfile linter"
    TOOL_CATEGORIES["hadolint"]="quality"
    TOOL_INSTALL_CMDS["hadolint"]="brew install hadolint | See https://github.com/hadolint/hadolint"
    
    TOOL_DESCRIPTIONS["shellcheck"]="Shell script linter"
    TOOL_CATEGORIES["shellcheck"]="quality"
    TOOL_INSTALL_CMDS["shellcheck"]="brew install shellcheck | apt install shellcheck"
    
    TOOL_DESCRIPTIONS["yamllint"]="YAML linter"
    TOOL_CATEGORIES["yamllint"]="quality"
    TOOL_INSTALL_CMDS["yamllint"]="pip install yamllint"
    
    # Documentation Tools
    TOOL_DESCRIPTIONS["git-chglog"]="Changelog generator"
    TOOL_CATEGORIES["git-chglog"]="documentation"
    TOOL_INSTALL_CMDS["git-chglog"]="go install github.com/git-chglog/git-chglog/cmd/git-chglog@latest"
    
    # Enhancement Tools
    TOOL_DESCRIPTIONS["gum"]="Beautiful CLI interactions"
    TOOL_CATEGORIES["gum"]="enhancement"
    TOOL_INSTALL_CMDS["gum"]="go install github.com/charmbracelet/gum@latest"
}

# Get tools by category
get_tools_by_category() {
    local category="$1"
    local tools=()
    
    for tool in "${!TOOL_CATEGORIES[@]}"; do
        if [[ "${TOOL_CATEGORIES[$tool]}" == "$category" ]]; then
            tools+=("$tool")
        fi
    done
    
    printf '%s\n' "${tools[@]}"
}

# Get all categories
get_all_categories() {
    local categories=()
    for cat in "${TOOL_CATEGORIES[@]}"; do
        if [[ ! " ${categories[@]} " =~ " ${cat} " ]]; then
            categories+=("$cat")
        fi
    done
    printf '%s\n' "${categories[@]}"
}

# Export functions
export -f define_tools
export -f get_tools_by_category
export -f get_all_categories