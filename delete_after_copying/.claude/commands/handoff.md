# Agent Handoff Prompt Generator

## Instruction for Current Agent

You need to generate a comprehensive handoff prompt for a new agent who will have NO prior context. **Think hard** about everything the new agent needs to know to continue the work seamlessly.

Generate a prompt that includes ALL of the following sections:

---

## HANDOFF PROMPT TEMPLATE

### 1. Project Overview
```
Project Name: [Name]
Current Phase: [Phase/Sprint/Milestone]
Overall Objective: [Clear description of what we're building/fixing]
Business Context: [Why this work matters]
Technical Stack: [Languages, frameworks, tools in use]
```

### 2. Current State Snapshot
```
Last Working Commit: [Hash]
Branch Name: [Branch]
Build Status: [Passing/Failing - if failing, why]
Test Coverage: [X%]
Last Code Review: [Status and any pending feedback]
Environment Status: [Dev/Staging/Prod states]
```

### 3. File Structure and Key Paths
```
Repository Root: [Path]
Key Directories:
- Source Code: [Path]
- Tests: [Path]
- Configuration: [Path]
- Documentation: [Path]
- Scripts: [Path]

Critical Files to Review:
- [File 1]: [Why it's important]
- [File 2]: [Why it's important]
- PLAN.md: [Path to current plan]

Files Currently Being Modified:
- [File]: [Nature of changes]
```

### 4. Work Completed
```
Completed Tasks: (from PLAN.md)
1. ✅ [Task]: [What was done, how it was verified]
   - Tests written: [List]
   - Code review status: [Approved by X]
   - Important decisions made: [Decisions and rationale]

2. ✅ [Task]: [Details]
   ...
```

### 5. Current Task In-Progress
```
Task: [Exact task from PLAN.md]
Started: [Timestamp]
Progress: [What's been done so far]

Partially Completed:
- [x] Step 1: [Description]
- [x] Step 2: [Description]
- [ ] Step 3: [Description] <- NEXT STEP

Current Working Directory: [Path]
Open Files in Editor: [List]
Terminal Commands Running: [Any watchers, servers, etc.]

Last Command Executed: [Command and its output]
```

### 6. Immediate Next Actions
```
NEXT IMMEDIATE STEP:
1. [Specific action to take]
2. [Expected outcome]
3. [How to verify success]

Commands to Run:
```bash
# First, ensure you're in the right state
cd [directory]
git status  # Should show [expected state]

# Then continue with
[next command]
```
```

### 7. Known Issues and Blockers
```
Active Blockers:
- Issue: [Description]
  Impact: [What it blocks]
  Proposed Solution: [User decision pending/approved approach]
  Related Discussion: [Check-in timestamp or reference]

Gotchas Discovered:
- [Issue]: [How to handle/avoid]
```

### 8. Dependencies and External Resources
```
External Services:
- [Service]: [URL, credentials location, purpose]

Documentation Links:
- [Original specs]: [URL]
- [API documentation]: [URL]
- [Design documents]: [URL]

Required Access:
- [System/Service]: [How to verify access]
```

### 9. Testing Strategy
```
Test Execution Command: [Command]
Test Files Pattern: [Pattern]

Critical Test Suites:
- [Suite]: [What it validates]

Recent Test Failures (if any):
- [Test]: [Failure reason, is it related to our changes?]

TDD Cycle Status:
- Current Phase: [Red/Green/Refactor]
- Test Being Implemented: [Test name/description]
```

### 10. Code Review Requirements
```
Golang Reviewer Process:
- Last Review Request: [Timestamp]
- Feedback Pending: [Any unaddressed feedback]
- Next Review Needed For: [What code]

Review Checklist:
- [ ] All tests passing
- [ ] No linting errors
- [ ] Documentation updated
- [ ] PLAN.md current
```

### 11. Communication History
```
Recent Check-ins:
[Timestamp]: [Key decisions or approvals]
[Timestamp]: [Important context]

Pending User Decisions:
- [Question]: [Context, options presented]

Agreed Conventions:
- [Convention]: [Rationale]
```

### 12. Environment and Tools
```
Required Tools:
- Go version: [Version]
- Other tools: [Versions]

Environment Variables:
- [VAR]: [Purpose, where to find value]

Local Setup Commands:
```bash
# To recreate the working environment
[setup commands]
```
```

### 13. Plan Status
```
PLAN.md Location: [Path]
Last Updated: [Timestamp]
Completion: [X% of original plan]

Upcoming Tasks (next 3):
1. [Task]: [Estimated time, dependencies]
2. [Task]: [Estimated time, dependencies]
3. [Task]: [Estimated time, dependencies]

Plan Adjustments Made:
- [Original]: [What changed and why]
```

### 14. Critical Warnings
```
⚠️ DO NOT:
- [Action to avoid]: [Consequence]
- [Common mistake]: [How to prevent]

⚠️ ALWAYS:
- Check in after EVERY minor task
- Get Golang code review approval before proceeding
- Keep build passing
- Update PLAN.md in real-time
```

### 15. Handoff Verification Checklist
```
Before starting work, verify:
- [ ] Can access all listed file paths
- [ ] Tests are currently passing (or understand why not)
- [ ] Understand the current task's acceptance criteria
- [ ] Have reviewed PLAN.md
- [ ] Understand the immediate next action

First action after this handoff:
1. Run test suite to verify current state
2. Review PLAN.md for full context
3. Check in with user confirming ready to continue
4. Resume from "NEXT IMMEDIATE STEP" above
```

### 16. Original Working Principles
```
[Copy the entire original Claude Agent Development Prompt here]
Including:
- Think hard requirement
- TDD methodology
- Check-in format
- Bug handling protocol
- All other requirements from original prompt
```

---

## Additional Context Capture

**Think hard** about these questions and include answers in relevant sections above:

1. What assumptions were made that the new agent needs to know?
2. What tribal knowledge was discovered during implementation?
3. What design decisions were made and why?
4. What alternatives were considered and rejected?
5. What performance considerations are important?
6. What security considerations have been addressed?
7. What technical debt was intentionally accepted?
8. What patterns are being followed in the codebase?
9. What naming conventions are in use?
10. What would surprise someone new to this codebase?

## Generation Instructions

When generating this handoff:
1. Be exhaustive - too much information is better than too little
2. Be specific - use exact paths, commands, and values
3. Be clear about state - what's done, what's in progress, what's next
4. Include all context from check-ins and discussions
5. Assume the new agent knows NOTHING about prior work
6. Test your handoff - could YOU resume work with only this information?

Remember: The new agent will have a completely fresh context. They won't have access to any previous conversation history. This handoff prompt is their ONLY source of information about the work.

**Think hard** - Have you included EVERYTHING needed for seamless continuation?