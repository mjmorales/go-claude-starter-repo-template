# Claude AI Configuration Guide

This project includes advanced Claude AI configuration with custom agents and commands designed specifically for Go development.

## 🚀 Quick Setup

```bash
# Install Claude configuration
task claude:setup

# Or with cleanup of source files
task claude:setup:cleanup

# Verify installation
task claude:verify
```

## 📁 Configuration Structure

```
.claude/
├── agents/           # Specialized AI agents
│   ├── go-expert-engineer.md
│   ├── golang-test-engineer.md
│   └── dx-systems-engineer.md
├── commands/         # Custom slash commands
│   ├── plan.md      # Project planning
│   ├── commit.md    # Git commit helper
│   ├── test-module.md
│   └── arch-review.md
.mcp.json            # Model Context Protocol servers
```

## 🤖 Available Agents

Agents are specialized personas that Claude can adopt for specific tasks. Use them with `@agent-name`.

### @go-expert-engineer
Expert Go engineering assistant for:
- Writing production-grade Go code
- Refactoring and optimization
- Clean architecture implementation
- Concurrency patterns
- Performance tuning

### @golang-test-engineer
Specialized in Go testing:
- Table-driven test creation
- Testify framework usage
- Mock generation
- Test coverage optimization
- Integration and unit testing

### @dx-systems-engineer
Developer experience and tooling expert:
- Taskfile optimization
- CI/CD pipeline design
- Build system improvements
- Development environment setup
- Automation workflows

## 🎯 Available Commands

Commands provide structured workflows. Use them with `/command-name`.

### /plan
Create structured project plans with:
- Task breakdown
- Implementation steps
- Dependencies identification
- Time estimates

### /commit
Intelligent git commit assistant:
- Analyzes staged changes
- Generates semantic commit messages
- Follows conventional commits
- Includes relevant context

### /test-module
Comprehensive module testing:
- Generates test cases
- Creates test fixtures
- Implements mocks
- Ensures coverage

### /arch-review
Architecture review and recommendations:
- Analyzes project structure
- Identifies improvements
- Suggests patterns
- Reviews dependencies

### /pickup
Resume work from previous session:
- Recovers context
- Shows work history
- Continues tasks

### /handoff
Prepare work for handoff:
- Summarizes completed work
- Documents pending tasks
- Creates transition notes

## 🔧 MCP Servers

The `.mcp.json` file configures Model Context Protocol servers:

### gopls
Go language server integration:
- Code navigation
- Symbol lookup
- Type information
- Refactoring support

### memory
Persistent context storage:
- Project knowledge
- Decision history
- Learning retention

### sequential-thinking
Complex problem solving:
- Step-by-step reasoning
- Multi-phase solutions
- Verification loops

### go-debugger
Debugging integration:
- Breakpoint management
- Variable inspection
- Stack trace analysis

### serena
Advanced code understanding:
- Semantic search
- Code analysis
- Project navigation

## 📋 Task Commands

```bash
# Setup and Management
task claude:setup         # Install configuration
task claude:verify        # Verify installation
task claude:info          # Show status
task claude:backup        # Backup configuration
task claude:clean         # Remove configuration

# Discovery
task claude:agents        # List agents
task claude:commands      # List commands
task claude:help          # Show help
```

## 💡 Usage Examples

### Using Agents

```
User: @go-expert-engineer help me optimize this function for performance

User: @golang-test-engineer create table-driven tests for the user service

User: @dx-systems-engineer improve our build pipeline
```

### Using Commands

```
User: /plan implement a new authentication system

User: /commit (after staging changes)

User: /test-module internal/auth

User: /arch-review
```

### Combining Features

```
User: /plan implement caching layer
(Claude creates plan)

User: @go-expert-engineer let's implement step 1 from the plan

User: @golang-test-engineer now create tests for the cache

User: /commit
```

## 🔍 Troubleshooting

### Configuration Not Loading

1. Restart Claude Desktop after installation
2. Check file permissions:
   ```bash
   ls -la .claude/
   ls -la .mcp.json
   ```
3. Verify workspace path in `.mcp.json`

### Agents Not Available

1. Check installation:
   ```bash
   task claude:verify
   ```
2. Ensure `.claude/agents/` contains `.md` files
3. Restart Claude Desktop

### Commands Not Working

1. Commands require `/` prefix
2. Check `.claude/commands/` directory
3. Verify command file format

### MCP Servers Not Connecting

1. Check dependencies:
   ```bash
   # For Node.js servers
   which npx
   
   # For Python servers
   which uvx
   ```
2. Verify server commands in `.mcp.json`
3. Check Claude Desktop logs

## 🛡️ Security Considerations

1. **`.mcp.json` contains workspace paths** - Don't commit with absolute paths
2. **Agents have full codebase access** - Review agent capabilities
3. **Commands can execute code** - Understand command actions
4. **Add to `.gitignore`**:
   ```
   .claude/
   .mcp.json
   .claude-backup-*
   ```

## 📚 Best Practices

### Agent Selection
- Use specialized agents for their domains
- Switch agents for different task phases
- Combine agents for comprehensive solutions

### Command Usage
- Start complex tasks with `/plan`
- Use `/commit` for consistent commit messages
- Run `/arch-review` periodically
- Use `/handoff` before breaks

### Workflow Integration
1. **Planning Phase**: `/plan` → breakdown tasks
2. **Implementation**: `@go-expert-engineer` → write code
3. **Testing**: `@golang-test-engineer` → create tests
4. **Review**: `/arch-review` → validate approach
5. **Commit**: `/commit` → document changes

## 🔄 Updating Configuration

To update Claude configuration:

```bash
# Backup current configuration
task claude:backup

# Get new configuration files
# (place in delete_after_copying/)

# Install new configuration
task claude:setup:cleanup
```

## 📖 Additional Resources

- [Claude Desktop Documentation](https://claude.ai/docs)
- [Model Context Protocol](https://github.com/anthropics/mcp)
- [Project Task Commands](./SETUP.md)
- [Development Guide](./development/README.md)

## 🤝 Contributing

To add new agents or commands:

1. Create `.md` file in appropriate directory
2. Follow existing format conventions
3. Test with Claude Desktop
4. Document in this guide
5. Share with team

## 📝 Notes

- Configuration is local and not committed to repository
- Each developer can customize their setup
- Backup before making changes
- Share useful agents/commands with team