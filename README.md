# Go Monorepo Template

A comprehensive Go monorepo template with intelligent setup, automated tooling, and best practices for scalable microservice development.

## 🚀 Quick Start

```bash
# 1. Check your environment
task doctor

# 2. Interactive setup (if needed)
task setup

# 3. Initialize project
task init

# 4. Run all checks
task check
```

## 📋 Features

- **🏥 Intelligent Setup**: Comprehensive environment health checks with `setup.sh`
- **📦 Automated Tooling**: Task-based build system with dynamic service discovery
- **🧪 Testing Suite**: Unit, integration, E2E tests with coverage reporting
- **🔍 Code Quality**: AI-optimized linting with golangci-lint
- **🤖 Claude AI Integration**: Custom agents and commands for enhanced development
- **🐳 Container Ready**: Docker multi-stage builds with security scanning
- **📡 API First**: Protocol Buffers, gRPC, and OpenAPI support
- **♻️ Hot Reload**: Development mode with Air
- **🔒 Security First**: Built-in vulnerability scanning
- **📊 Observability**: Metrics, tracing, and logging ready

## 🛠️ Setup

### Prerequisites

- Go 1.23+ (required)
- Git (required)
- Task runner (recommended)
- Docker (recommended)

### Installation

```bash
# Clone the template
git clone https://github.com/yourorg/go-monorepo-template myproject
cd myproject

# Run doctor to check your environment
./setup.sh doctor

# Interactive setup wizard
./setup.sh install

# Or use Task commands
task init
```

For detailed setup instructions, see [docs/SETUP.md](docs/SETUP.md).

## 📁 Project Structure

```
.
├── .task/              # Shared Taskfile definitions
├── cmd/                # Service entry points
│   └── example-service/
├── internal/           # Private shared packages
├── pkg/                # Public packages
├── api/                # API definitions
├── deployments/        # Deployment configurations
├── scripts/            # Utility scripts
├── docs/               # Documentation
├── setup.sh            # Intelligent setup script
└── Taskfile.yml        # Task orchestration
```

## 🎯 Common Tasks

### Development

```bash
# Build all services
task build:all

# Run tests with coverage
task test:coverage

# Run linters
task lint:all

# Auto-fix issues
task lint:fix

# Watch mode with hot reload
task watch
```

### Docker Operations

```bash
# Build Docker images
task docker:build

# Run services locally
task docker:compose:up

# Security scan images
task docker:scan
```

### Dependencies

```bash
# Update dependencies
task deps:update

# Check for vulnerabilities
task deps:check:security

# Tidy all modules
task deps:tidy
```

### Release

```bash
# Build release binaries
task release:all

# Create version tag
task release:tag TAG=v1.0.0

# Generate changelog
task release:changelog
```

## 🏗️ Adding a New Service

1. Create service directory:
```bash
mkdir -p cmd/my-service
```

2. Copy example Taskfile:
```bash
cp cmd/example-service/Taskfile.yml cmd/my-service/
```

3. Update service name in Taskfile

4. Build and run:
```bash
cd cmd/my-service
task build
task run
```

## 🤖 Claude AI Integration

This template includes advanced Claude AI configuration:

```bash
# Install Claude configuration
task claude:setup

# View available AI agents
task claude:agents

# View available commands
task claude:commands
```

**Available Agents:**
- `@go-expert-engineer` - Go development expert
- `@golang-test-engineer` - Testing specialist
- `@dx-systems-engineer` - DevEx and tooling expert

**Available Commands:**
- `/plan` - Project planning
- `/commit` - Smart commits
- `/test-module` - Test generation
- `/arch-review` - Architecture review

See [Claude AI Guide](docs/CLAUDE.md) for detailed usage.

## 🧪 Testing

The project supports multiple testing strategies:

- **Unit Tests**: `task test:unit`
- **Integration Tests**: `task test:integration`
- **E2E Tests**: `task test:e2e`
- **Benchmarks**: `task test:bench`
- **Coverage Report**: `task test:coverage`

## 🔍 Code Quality

Comprehensive linting configuration optimized for AI-assisted development:

```bash
# Run all checks
task check

# Run specific linters
task lint:golangci
task lint:security
task lint:complexity

# Auto-fix issues
task lint:fix
```

## 📚 Documentation

- [Setup Guide](docs/SETUP.md) - Detailed setup instructions
- [Claude AI Guide](docs/CLAUDE.md) - AI-enhanced development with Claude
- [Architecture](docs/architecture/) - System design and decisions
- [API Documentation](docs/api/) - API specifications
- [Development Guide](docs/development/) - Developer guidelines

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Run checks: `task check`
4. Commit your changes
5. Push to the branch
6. Create a Pull Request

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🛟 Support

- Create an issue for bugs or feature requests
- Check [docs/](docs/) for detailed documentation
- Run `task help` for available commands
- Run `./setup.sh help` for setup assistance

## 🏆 Health Check

Always ensure your environment is healthy:

```bash
task doctor
```

This will provide a comprehensive report of your development environment with personalized recommendations.