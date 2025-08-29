# Setup Guide

This project uses an intelligent setup script (`setup.sh`) integrated with Taskfile for streamlined development environment configuration.

## Quick Start

```bash
# 1. Check your environment health
task doctor

# 2. Run interactive setup (if needed)
task setup

# 3. Initialize the project
task init

# 4. Verify everything works
task check
```

## Setup Script Features

The `setup.sh` script provides comprehensive environment management:

### 🏥 Doctor Mode
```bash
./setup.sh doctor
# or
task doctor
```

Performs a complete health check of your development environment:
- System information and compatibility
- Go version and environment variables
- Installed tools and their versions
- Missing dependencies identification
- Health score calculation
- Personalized recommendations

### 🚀 Installation Modes

#### Interactive Installation
```bash
./setup.sh install
# or
task setup
```
- Interactive feature selection
- Category-based tool grouping
- Smart dependency resolution

#### Preset Installations
```bash
# Minimal setup (core tools only)
./setup.sh install minimal
task tools:install:minimal

# Recommended setup (standard development)
./setup.sh install recommended
task tools:install

# Full setup (everything)
./setup.sh install full
task tools:install:full
```

### 📦 Tool Categories

- **Core**: git, task, docker, docker-compose
- **Go Tools**: gopls, golangci-lint, goimports, gofumpt, air
- **Testing**: gotestsum, mockgen, testify
- **API Development**: protoc, buf, protoc-gen-go, swag
- **Database**: migrate, sqlc
- **Quality**: staticcheck, gosec, pre-commit, shellcheck
- **Kubernetes**: kubectl, helm, kind, kustomize
- **Cloud**: AWS CLI, gcloud, Azure CLI
- **Infrastructure**: Terraform

### 🔄 Update Tools
```bash
# Update all Go tools
./setup.sh update
# or
task tools:update
```

## Taskfile Integration

The Taskfile is fully integrated with `setup.sh`:

### Environment Commands
- `task doctor` - Run environment health check
- `task setup` - Interactive setup wizard
- `task init` - Initialize complete environment

### Tool Management
- `task tools:install` - Install recommended tools
- `task tools:install:minimal` - Install minimal toolset
- `task tools:install:full` - Install everything
- `task tools:update` - Update all Go tools
- `task tools:check` - Check installed versions

### Individual Tool Installation
If you prefer installing tools individually:
```bash
task tools:install:golangci-lint
task tools:install:air
task tools:install:mockgen
# ... etc
```

## Environment Requirements

### Minimum Requirements
- Go 1.23+ (required)
- Git (required)
- Bash 4+ (for setup.sh)

### Recommended Requirements
- Docker & Docker Compose
- Task (Taskfile runner)
- golangci-lint
- Air (hot reload)

## Platform Support

The setup script automatically detects and adapts to:
- macOS (Intel & Apple Silicon)
- Linux (Ubuntu, Debian, Fedora, etc.)
- Windows (via WSL2)

## Troubleshooting

### Permission Issues
```bash
chmod +x setup.sh
```

### Path Issues
Ensure Go's bin directory is in your PATH:
```bash
export PATH=$PATH:$(go env GOPATH)/bin
```

### Tool Not Found After Installation
1. Check PATH includes `$(go env GOPATH)/bin`
2. Restart your terminal
3. Run `task doctor` to verify

### Docker Issues
- Ensure Docker daemon is running
- Check Docker permissions (Linux may need user in docker group)

## CI/CD Integration

For CI environments, use non-interactive installation:
```bash
# Install minimal tools for CI
./setup.sh install minimal

# Or use specific Taskfile commands
task tools:install:golangci-lint
task tools:install:gotestsum
```

## Health Score Interpretation

The doctor command provides a health score:
- **80-100%**: Excellent - fully configured environment
- **60-79%**: Good - missing optional tools
- **40-59%**: Fair - missing recommended tools
- **0-39%**: Poor - missing critical tools

## Best Practices

1. **Run doctor regularly**: `task doctor` to ensure environment health
2. **Use recommended preset**: Best balance of tools and complexity
3. **Update tools monthly**: `task tools:update` to stay current
4. **Commit go.work**: Keep workspace configuration in version control
5. **Document custom tools**: Add project-specific tools to setup.sh

## Adding Custom Tools

To add project-specific tools, edit `setup.sh`:

```bash
# In define_tools() function
TOOL_DESCRIPTIONS["mytool"]="My custom tool"
TOOL_CATEGORIES["mytool"]="custom"
TOOL_INSTALL_CMDS["mytool"]="go install github.com/myorg/mytool@latest"
```

## Getting Help

```bash
# Show setup script help
./setup.sh help

# Show Taskfile help
task help

# Show all available tasks
task --list
```