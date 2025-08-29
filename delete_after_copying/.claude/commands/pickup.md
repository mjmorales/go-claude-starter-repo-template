# Agent Handoff Pickup Protocol

## You are receiving a handoff from another agent. **Think hard** before taking any action.

### STOP - Do Not Proceed Until All Steps Are Complete

## Phase 1: Initial Handoff Processing (READ ONLY - NO ACTIONS)

### 1.1 Full Handoff Review
- [ ] Read the ENTIRE handoff document thoroughly
- [ ] Identify all 16 sections and confirm they are present
- [ ] Note any missing sections or unclear information
- [ ] **Think hard** about what you've read - do you understand the full context?

### 1.2 Critical Information Extraction
Document the following from the handoff:
```
Project Name: [Extract]
Current Task: [Extract exact task]
Next Immediate Step: [Extract verbatim]
Last Command Executed: [Extract]
Current Working Directory: [Extract]
Build Status: [Extract - Passing/Failing]
Test Status: [Extract - X passing/Y total]
Blockers: [List any active blockers]
Pending Decisions: [List any waiting on user]
```

### 1.3 Requirements Comprehension
From Section 16 (Original Working Principles), confirm you understand:
- [ ] TDD methodology requirements
- [ ] Check-in after EVERY minor task requirement  
- [ ] Golang code review requirement after each task
- [ ] Never leave build/tests broken rule
- [ ] No TODOs/NOTEs rule - only plan updates
- [ ] Bug/blocker handling protocol (never skip without approval)
- [ ] Plan documentation requirements
- [ ] **"Think hard"** directive

## Phase 2: Environment Verification (READ ONLY)

### 2.1 Access Verification Checklist
Verify you can access (just check, don't modify):
```
✓/✗ Repository root: [Path]
✓/✗ PLAN.md file: [Path]
✓/✗ Source code directory: [Path]
✓/✗ Test directory: [Path]
✓/✗ Configuration files: [Path]

Critical Files Check:
✓/✗ [File 1 from handoff]: [Exists?]
✓/✗ [File 2 from handoff]: [Exists?]
✓/✗ Currently modified files: [List]
```

### 2.2 Tool Verification
```
✓/✗ Go version matches: [Required version]
✓/✗ Git repository accessible
✓/✗ Other required tools: [List]
```

## Phase 3: State Validation

### 3.1 Git State Verification
Execute and record results:
```bash
pwd  # Confirm you're in [expected directory from handoff]
git status
git log -1 --oneline  # Should show [expected commit from handoff]
git diff  # Document any uncommitted changes
```

### 3.2 Test Suite Verification
Execute and record:
```bash
[Test command from handoff]
```

Expected: [X tests passing according to handoff]
Actual: [Your result]
- [ ] Results match handoff (or you understand why not)

### 3.3 Build Verification
```bash
[Build command if provided]
```
- [ ] Build status matches handoff

### 3.4 PLAN.md Review
Open and review PLAN.md:
- [ ] Located at specified path
- [ ] Last updated timestamp matches handoff
- [ ] Current task in plan matches handoff
- [ ] Completed tasks list matches handoff
- [ ] Upcoming tasks clear

## Phase 4: Context Validation

### 4.1 Current Task Analysis
From the handoff, document:
```
Current Task: [Full description]
Progress Status:
- Completed steps: [List]
- Next uncompleted step: [Identify]
- Acceptance criteria: [List]
- Related tests: [List]

TDD Cycle Position:
- Current phase: [Red/Green/Refactor]
- Test being implemented: [Name/description]
```

### 4.2 Code Review Status
```
Last Review: [Timestamp from handoff]
Pending Feedback: [List any]
Next Review Needed: [For what code]
```

### 4.3 Known Issues Comprehension
For each blocker/gotcha from handoff:
```
Issue 1: [Description]
- Impact: [What it affects]
- Workaround/Solution: [Approach]
- Your understanding: [Explain in your words]
```

## Phase 5: Handoff Acceptance Check-in

### 5.1 Pre-Continuation Checklist
Before proceeding, confirm:
- [ ] All handoff sections reviewed and understood
- [ ] Environment accessible and verified
- [ ] Tests match expected state (or discrepancies understood)
- [ ] Current task and next step are clear
- [ ] PLAN.md has been reviewed
- [ ] Original working principles understood
- [ ] Know exactly what command/action to take next

### 5.2 Discrepancy Report
If ANY discrepancies found:
```
⚠️ HANDOFF DISCREPANCIES DETECTED:

1. [Discrepancy]: 
   - Expected: [From handoff]
   - Found: [Actual]
   - Impact: [Assessment]

2. [Continue for all discrepancies]

RECOMMENDATION: [How to proceed]
```

### 5.3 MANDATORY First Check-in
**STOP - Do not proceed without user confirmation**

Format your check-in:
```
📋 HANDOFF PICKUP CONFIRMATION

Project: [Name]
Handoff Received From: Previous agent at [timestamp from handoff]

✅ Validated:
- Environment access confirmed
- Tests status: [X/Y passing] [matches/differs from handoff]
- Build status: [passing/failing] [matches/differs from handoff]  
- PLAN.md located and reviewed
- Current task understood: [Task name]

📍 Current Position:
- Last completed: [Previous task/step]
- Currently on: [Current task from PLAN.md]
- Next immediate action: [Specific next step]

🔄 TDD Status:
- Phase: [Red/Green/Refactor]
- Test: [Current test focus]

⚠️ Discrepancies (if any):
[List any differences from handoff]

❓ Questions Before Proceeding:
[Any clarifications needed]

Ready to continue with: [Exact next action from handoff]
Shall I proceed?
```

## Phase 6: Work Resumption Protocol

### 6.1 ONLY After User Confirmation

**Think hard** - Have you:
- Completed all verification steps?
- Reported all discrepancies?
- Received explicit approval to continue?

### 6.2 First Action Execution
1. Execute the EXACT next step from the handoff "Immediate Next Actions" section
2. Do not deviate or optimize - follow the handoff precisely
3. After completing the immediate next action, check in again

### 6.3 Resumption Check-in Format
```
✅ Resumed Work Successfully
Completed: [The immediate next action from handoff]
Result: [What happened]
Tests: [Still passing?]
Next: [Next step from PLAN.md]
Proceeding with normal work cadence and check-ins.
```

## Phase 7: Ongoing Work Protocol

After successful resumption, follow these rules:

### 7.1 Working Principles (from original prompt)
- **Think hard** before every action
- Check in after EVERY minor task
- Maintain TDD discipline (Red-Green-Refactor)
- Get Golang code review after each task
- Never leave tests/build broken
- Update PLAN.md continuously
- Never use TODOs or NOTEs
- Never skip bugs without approval

### 7.2 Check-in Cadence
Continue with the standard format from the original prompt:
```
✅ Completed: [Task description]
📊 Tests: [X passed / Y total]
🔍 Code Review Status: [Pending/Approved]
⏭️ Next Task: [Description]
❓ Any concerns or decisions needed?
```

## Critical Reminders

⚠️ **NEVER**:
- Skip the verification phases
- Assume the handoff is complete without checking
- Proceed without user confirmation after initial check-in
- Deviate from the plan without approval
- Make changes before understanding current state

✅ **ALWAYS**:
- **Think hard** about the context before acting
- Validate everything in the handoff
- Report any discrepancies immediately
- Follow the exact next step from the handoff first
- Maintain the established working principles
- Keep PLAN.md updated

## Handoff Pickup Complete

Once you've successfully completed the first task after handoff and checked in, you're fully integrated and should continue following the original working principles and check-in cadence.

Remember: Your first priority is to maintain continuity. Don't optimize or refactor until you've successfully picked up where the previous agent left off.

**Think hard** - Are you ready to be a seamless continuation of the work?