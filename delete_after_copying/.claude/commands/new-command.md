# Prompt Generation Template for Claude Code

Generate a concise, actionable prompt for claude-code. It should be saved to `.claude/commands/{command name}.md`. Create it based on the following problem space:

**Problem Space:** {PROBLEM_SPACE_HINT}

## Requirements for Generated Prompt

Your generated prompt must:

1. **Be Direct and Action-Oriented**
   - Start with a clear verb (implement, fix, refactor, analyze, etc.)
   - Specify exactly what needs to be done
   - Avoid unnecessary preamble or explanation

2. **Include Specific Context**
   - Reference exact file paths when known
   - Mention specific functions, classes, or code patterns
   - Include relevant technical constraints or requirements

3. **Follow Claude Code Best Practices**
   - Minimize verbosity - be as concise as possible
   - Focus on the immediate task
   - Avoid requesting documentation unless explicitly needed
   - Prefer editing existing files over creating new ones
   - Include verification steps (lint, test, typecheck) when appropriate

4. **Structure for Clarity**
   - Use bullet points for multiple requirements
   - Separate distinct tasks clearly
   - Order tasks logically (research → implement → verify)

## Output Format

Generate the prompt in this format:

```
[PRIMARY ACTION] [TARGET] in [LOCATION/CONTEXT]

Specific requirements:
- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

[Any critical constraints or notes]
```

## Examples

### Example 1
Problem Space: "Adding error handling to API endpoints"

Generated Prompt:
```
Add comprehensive error handling to all REST API endpoints in src/api/

Requirements:
- Catch and properly format validation errors (400)
- Handle database connection errors (503)
- Log errors with appropriate severity levels
- Return consistent error response format: {error: string, code: number}

Run npm test after implementation to verify error cases.
```

### Example 2
Problem Space: "Performance optimization for React components"

Generated Prompt:
```
Optimize rendering performance in components/Dashboard/*.tsx

- Implement React.memo for components with expensive renders
- Add useMemo for complex calculations in useEffect hooks
- Replace inline arrow functions in props with useCallback
- Verify with React DevTools Profiler after changes
```

## Key Principles

- Assume claude-code has full codebase access - don't ask it to check things unnecessarily
- Be specific about file locations and function names when possible
- Include verification commands (lint, test, build) as final steps
- Never request creation of README or documentation files unless that's the primary goal
- Keep total prompt length under 10 lines when possible