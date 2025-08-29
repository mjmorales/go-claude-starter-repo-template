# Commit Strategy & Complexity Management Framework

## Purpose
Guide agents to create small, focused, verifiable commits that pass complexity checks and maintain code quality. This framework enforces the principle: **One logical change = One commit**.

## Core Principles

### The Golden Rules of Committing
1. **Small is Beautiful** - Each commit should do ONE thing well
2. **Test with Implementation** - Every feature commit includes its test
3. **Pass All Gates** - All pre-commit hooks must pass
4. **Atomic Changes** - Each commit should be independently revertable
5. **Clear Intent** - Commit message clearly states the single purpose

## Pre-Commit Hook Overview

Your repository enforces quality through these checks:
```yaml
Stage 1: File Hygiene
- trailing-whitespace
- end-of-file-fixer
- check-yaml
- check-added-large-files
- check-merge-conflict
- detect-private-key

Stage 2: Go-Specific Checks
- go-mod-tidy
- fmt (formatting)
- vet (static analysis)
- lint (style guide)
- test (unit tests)

Stage 3: Complexity Gates
- check:complexity (commit size/scope)
- check:ai (AI-friendly patterns)
- check:coverage (test coverage)

Stage 4: Commit Message
- Conventional format: type(scope): description
```

## Commit Workflow Strategy

### Phase 1: Planning Your Commits

Before making ANY changes, plan your commit sequence:

```markdown
## Commit Plan for [Feature/Fix Name]

### Commit 1: Add test for [specific behavior]
- File: `pkg/module/feature_test.go`
- Lines: ~30-50
- Complexity: Low (single test file)

### Commit 2: Implement [specific behavior]
- Files: `pkg/module/feature.go`
- Lines: ~20-40
- Complexity: Low (single function/method)

### Commit 3: Add integration test
- File: `tests/integration/feature_test.go`
- Lines: ~40-60
- Complexity: Low (test only)

### Commit 4: Update documentation
- File: `README.md`, `docs/feature.md`
- Lines: ~20-30
- Complexity: Minimal (docs only)
```

### Phase 2: Working Directory Management

Use a three-stage approach to manage changes:

```bash
# 1. WORK AREA - Make all your changes
# 2. STAGING AREA - Cherry-pick specific changes
# 3. COMMIT AREA - Only staged changes get committed

# Set up your work environment
git stash list  # Check existing stashes
git status      # Current state
```

### Phase 3: Implementation Strategy

#### Strategy A: Test-First Development (Recommended)
```bash
# Step 1: Write the test
vim pkg/module/feature_test.go
# Write ONLY the test

# Step 2: Stage and commit the test
git add pkg/module/feature_test.go
git commit -m "test(module): add test for feature X behavior"

# Step 3: Implement the feature
vim pkg/module/feature.go
# Write MINIMAL implementation to pass test

# Step 4: Stage and commit implementation
git add pkg/module/feature.go
git commit -m "feat(module): implement feature X"
```

#### Strategy B: Incremental Building
```bash
# Work on everything, then extract commits

# Step 1: Do all the work
# ... make all changes ...

# Step 2: Stash everything
git stash push -m "Complete feature implementation"

# Step 3: Pop stash and cherry-pick
git stash pop --index

# Step 4: Interactive staging
git add -p  # Interactively select hunks

# Step 5: Commit small piece
git commit -m "feat(module): add data structure for X"

# Step 6: Repeat for next logical piece
git add -p
git commit -m "feat(module): add validation for X"
```

#### Strategy C: Surgical Commits (Advanced)
```bash
# For precise line-by-line control

# Step 1: Start interactive staging
git add -i

# Options:
# 1: status
# 2: update - select files to stage
# 3: revert - unstage files
# 4: add untracked
# 5: patch - select specific hunks/lines
# 6: diff - review staged changes
# 7: quit

# Step 2: Use patch mode for specific lines
git add -p filename.go

# For each hunk:
# y - stage this hunk
# n - don't stage this hunk
# s - split hunk into smaller hunks
# e - manually edit hunk

# Step 3: Verify complexity before committing
python3 commit_complexity_analyzer.py --staged-only

# Step 4: Commit if complexity passes
git commit -m "fix(module): correct boundary condition in validator"
```

### Phase 4: Complexity Management

#### Understanding Complexity Scores
```markdown
## Complexity Thresholds
- Max files: 10 (prefer 1-3)
- Max lines: 500 (prefer < 100)
- Max directories: 5 (prefer 1-2)
- Max file types: 3 (prefer 1)
- Complexity score: < 100

## High-Risk Changes (Commit Separately)
- Configuration files (.env, .yaml, .json)
- Migrations (database schemas)
- Dependencies (go.mod, package.json)
- API changes (routes, handlers)
- Security changes (auth, crypto)
```

#### Reducing Complexity Process
```bash
# Check current complexity
python3 commit_complexity_analyzer.py --staged-only

# If too complex, use this workflow:

# 1. Save current state
python3 commit_complexity_analyzer.py --save-backup

# 2. Reset staging
git reset HEAD

# 3. Add files selectively
git add pkg/specific/file.go

# 4. Check again
python3 commit_complexity_analyzer.py --staged-only

# 5. If still complex, use patch mode
git reset HEAD
git add -p pkg/specific/file.go

# 6. Select only related hunks
# Choose 's' to split large hunks
# Choose 'e' to edit hunks manually
```

### Phase 5: Commit Message Standards

Follow conventional commit format:

```
type(scope): description

[optional body]

[optional footer]
```

#### Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, no code change
- `refactor`: Code restructuring, no behavior change
- `test`: Adding tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `ci`: CI/CD changes
- `build`: Build system changes
- `revert`: Reverting previous commit

#### Examples:
```bash
# Good commits (focused, clear)
git commit -m "test(auth): add test for JWT token expiration"
git commit -m "feat(auth): implement JWT token generation"
git commit -m "fix(auth): correct token expiry calculation"
git commit -m "docs(auth): update JWT configuration guide"

# Bad commits (too broad, unclear)
git commit -m "update auth"  # ❌ Too vague
git commit -m "fix stuff"    # ❌ Unclear
git commit -m "big changes"  # ❌ Too broad
```

## Practical Workflows

### Workflow 1: Feature Implementation
```bash
# 1. Create feature branch
git checkout -b feature/user-authentication

# 2. Write test first
cat > auth_test.go << 'EOF'
func TestGenerateToken(t *testing.T) {
    // Test implementation
}
EOF

# 3. Commit test
git add auth_test.go
python3 commit_complexity_analyzer.py --staged-only
git commit -m "test(auth): add test for token generation"

# 4. Implement feature
cat > auth.go << 'EOF'
func GenerateToken(user User) (string, error) {
    // Implementation
}
EOF

# 5. Commit implementation
git add auth.go
python3 commit_complexity_analyzer.py --staged-only
git commit -m "feat(auth): implement token generation"

# 6. Add validation
# ... modify auth.go ...
git add -p auth.go  # Select only validation changes
git commit -m "feat(auth): add token validation"

# 7. Update documentation
git add README.md
git commit -m "docs(auth): document token generation API"
```

### Workflow 2: Bug Fix
```bash
# 1. Create fix branch
git checkout -b fix/token-expiry

# 2. Add failing test that reproduces bug
vim token_test.go
git add token_test.go
git commit -m "test(auth): add test exposing token expiry bug"

# 3. Fix the bug
vim token.go
git add -p token.go  # Only add the fix, not refactoring
git commit -m "fix(auth): correct token expiry calculation"

# 4. Add regression test if needed
vim regression_test.go
git add regression_test.go
git commit -m "test(auth): add regression test for token expiry"
```

### Workflow 3: Refactoring
```bash
# 1. Ensure tests pass first
task test

# 2. Make refactoring changes
vim module.go

# 3. Commit in logical chunks
git add -p module.go

# Select first refactoring (e.g., extract method)
git commit -m "refactor(module): extract validation into separate method"

# Select second refactoring (e.g., simplify logic)
git add -p module.go
git commit -m "refactor(module): simplify conditional logic"

# Select third refactoring (e.g., rename for clarity)
git add -p module.go
git commit -m "refactor(module): rename variables for clarity"
```

## Emergency Procedures

### When Complexity Check Fails

#### Immediate Response
```bash
# Option 1: Backup and reset
python3 commit_complexity_analyzer.py --save-backup
git reset HEAD
# Re-stage more selectively

# Option 2: Stash and rebuild
git stash push -m "Complex changes - need to split"
# Apply and pick pieces
git stash pop --index
git reset HEAD
git add -p  # Add selectively

# Option 3: Create patch files
git diff > feature.patch
git reset --hard HEAD
# Apply patch in pieces
git apply --reject feature.patch
# Stage specific files
```

#### Strategic Response - Plan Revision

**CRITICAL: Complexity failures indicate planning problems, not just implementation issues.**

When complexity checks fail repeatedly:

```markdown
## Plan Revision Trigger Points

### Single Failure (Tactical Fix)
- Complexity score > 100 once
- Action: Split current commit
- Continue with existing plan

### Multiple Failures (Strategic Review)
- Complexity failures > 2 in a session
- Action: STOP and revise plan
- Break down work into smaller stages

### Systematic Failures (Complete Redesign)
- Complexity failures across multiple stages
- Action: Fundamental restructuring needed
- Return to design phase
```

#### Plan Revision Process

```markdown
## Complexity-Driven Plan Revision

### Step 1: Analyze Failure Pattern
What caused the complexity?
- [ ] Too many concerns mixed (features + tests + config)
- [ ] Changes spanning multiple layers
- [ ] Unclear boundaries between components
- [ ] Attempting too much in one stage

### Step 2: Identify Root Cause
Why did the plan lead to this?
- [ ] Stages too ambitious
- [ ] Dependencies not properly identified
- [ ] Coupling between components underestimated
- [ ] Missing intermediate abstractions

### Step 3: Revise Execution Plan
Break down the problematic stage:

#### Original Stage (Failed):
**Stage 3: Implement Authentication**
- Add JWT service (200 lines)
- Add middleware (150 lines)
- Update handlers (300 lines)
- Total: 650 lines, 15 files ❌

#### Revised Stages (Smaller):
**Stage 3a: JWT Token Core**
- Add token generation only (50 lines)
- Unit test for generation (30 lines)
- Total: 80 lines, 2 files ✅

**Stage 3b: JWT Validation**
- Add token validation (40 lines)
- Unit test for validation (30 lines)
- Total: 70 lines, 2 files ✅

**Stage 3c: JWT Middleware**
- Add middleware skeleton (30 lines)
- Integration test (40 lines)
- Total: 70 lines, 2 files ✅

**Stage 3d: Handler Integration**
- Update one handler (50 lines)
- Update handler test (30 lines)
- Total: 80 lines, 2 files ✅

**Stage 3e: Remaining Handlers**
- Update remaining handlers incrementally
- One handler per commit
- Total: 50-80 lines per commit ✅

### Step 4: Update Documentation
Document why the plan changed:
```yaml
# .plan-revisions.yaml
revisions:
  - date: 2024-01-15
    stage: "Stage 3: Authentication"
    reason: "Complexity score 250, too many concerns"
    changes:
      - Split into 5 sub-stages
      - Separated token ops from middleware
      - One handler per commit
    lessons:
      - JWT implementation more complex than estimated
      - Middleware requires isolated testing
      - Handler updates should be individual
```

### Step 5: Apply Lessons to Future Stages
Review remaining stages for similar issues:
- Do any other stages mix multiple concerns?
- Are there stages touching > 5 files?
- Can we pre-emptively split large stages?
```

#### Workstream Decomposition Patterns

When complexity issues arise, apply these patterns:

```markdown
## Decomposition Patterns

### Pattern 1: Vertical Slicing
Instead of: Complete feature across all layers
Better: One thin slice through all layers

Example:
❌ Bad: Implement all user CRUD operations
✅ Good: 
  - Commit 1: Create user endpoint only
  - Commit 2: Read user endpoint only
  - Commit 3: Update user endpoint only
  - Commit 4: Delete user endpoint only

### Pattern 2: Horizontal Layering
Instead of: Mixed layer changes
Better: One layer at a time

Example:
❌ Bad: API + Service + Database in one commit
✅ Good:
  - Commit 1: Database schema/migration
  - Commit 2: Repository layer
  - Commit 3: Service layer
  - Commit 4: API layer

### Pattern 3: Test-Implementation Pairing
Instead of: All tests then all implementation
Better: Test-implementation pairs

Example:
❌ Bad: 10 tests, then huge implementation
✅ Good:
  - Commit 1: Test for feature A
  - Commit 2: Implement feature A
  - Commit 3: Test for feature B
  - Commit 4: Implement feature B

### Pattern 4: Incremental Refactoring
Instead of: Big bang refactor
Better: Incremental improvements

Example:
❌ Bad: Refactor entire module
✅ Good:
  - Commit 1: Extract one method
  - Commit 2: Rename for clarity
  - Commit 3: Simplify one algorithm
  - Commit 4: Remove duplication
```

### When Pre-commit Hooks Fail
```bash
# See which hook failed
pre-commit run --all-files

# Fix specific issues
task fmt          # Fix formatting
task lint         # Fix linting
task test         # Fix tests
task check:complexity  # Check complexity

# Retry commit
git commit -m "type(scope): message"
```

### Recovery from Bad Commits
```bash
# Undo last commit but keep changes
git reset --soft HEAD~1

# Undo last commit and changes
git reset --hard HEAD~1

# Fix commit message
git commit --amend -m "correct(scope): better message"

# Split last commit
git reset HEAD~1
git add -p
git commit -m "first part"
git add -p
git commit -m "second part"
```

## Best Practices Checklist

### Before Starting Work
- [ ] Plan commit sequence
- [ ] Identify logical boundaries
- [ ] Estimate complexity per commit
- [ ] Set up clean working directory

### While Working
- [ ] Use descriptive branch names
- [ ] Make frequent WIP stashes for backup
- [ ] Test after each logical change
- [ ] Keep changes focused on one concern

### Before Each Commit
- [ ] Run complexity analyzer
- [ ] Verify single responsibility
- [ ] Check test coverage
- [ ] Review staged changes (`git diff --staged`)
- [ ] Write clear commit message

### After Committing
- [ ] Verify CI passes
- [ ] Check commit log is clean (`git log --oneline`)
- [ ] Ensure commits are atomic
- [ ] Document any special considerations

## Git Commands Reference

### Essential Commands for Small Commits
```bash
# Staging Commands
git add -p <file>           # Interactive patch mode
git add -i                  # Interactive staging
git reset HEAD <file>       # Unstage file
git reset HEAD              # Unstage everything

# Stash Commands
git stash push -m "message" # Save current changes
git stash pop              # Restore last stash
git stash list             # List all stashes
git stash show -p stash@{0} # Show stash contents
git stash branch <name>    # Create branch from stash

# Inspection Commands
git diff                   # Changes not staged
git diff --staged          # Changes staged
git diff HEAD             # All changes
git status -s             # Short status
git log --oneline -10     # Recent commits

# Commit Commands
git commit -m "message"    # Commit staged
git commit --amend        # Modify last commit
git commit -v             # Commit with diff view

# Cherry-pick Commands
git cherry-pick <hash>    # Apply specific commit
git cherry-pick -n <hash> # Apply without committing
```

## Complexity Analyzer Integration

### Configuration
```python
# .commit-complexity.json
{
  "max_files": 5,
  "max_lines": 200,
  "max_directories": 3,
  "max_file_types": 2,
  "max_complexity_score": 50.0,
  "warn_on_config_changes": true,
  "warn_on_migration_changes": true,
  "block_mixed_concerns": true
}
```

### Usage in Workflow
```bash
# Check before staging
python3 commit_complexity_analyzer.py

# Check staged changes
python3 commit_complexity_analyzer.py --staged-only

# Auto-stash if too complex
python3 commit_complexity_analyzer.py --staged-only --auto-stash

# Save backup before reset
python3 commit_complexity_analyzer.py --staged-only --save-backup

# Get JSON output for scripting
python3 commit_complexity_analyzer.py --staged-only --json
```

## Example: Complete Feature Implementation

Let's implement a user registration feature with proper commit strategy:

```bash
# Initial setup
git checkout -b feat/user-registration

# Commit 1: Add user model test
cat > models/user_test.go << 'EOF'
func TestUserValidation(t *testing.T) {
    tests := []struct{
        name string
        user User
        wantErr bool
    }{
        {"valid user", User{Email: "test@example.com"}, false},
        {"invalid email", User{Email: "invalid"}, true},
    }
    // ... test implementation
}
EOF

git add models/user_test.go
python3 commit_complexity_analyzer.py --staged-only
# Output: ✅ Complexity: 15.0 (PASS)
git commit -m "test(user): add validation tests for User model"

# Commit 2: Add user model
cat > models/user.go << 'EOF'
type User struct {
    ID        string
    Email     string
    CreatedAt time.Time
}

func (u User) Validate() error {
    if !isValidEmail(u.Email) {
        return ErrInvalidEmail
    }
    return nil
}
EOF

git add models/user.go
python3 commit_complexity_analyzer.py --staged-only
# Output: ✅ Complexity: 20.0 (PASS)
git commit -m "feat(user): implement User model with validation"

# Commit 3: Add registration handler test
cat > handlers/registration_test.go << 'EOF'
func TestRegistrationHandler(t *testing.T) {
    // Test implementation
}
EOF

git add handlers/registration_test.go
python3 commit_complexity_analyzer.py --staged-only
# Output: ✅ Complexity: 25.0 (PASS)
git commit -m "test(registration): add handler tests"

# Commit 4: Add registration handler
cat > handlers/registration.go << 'EOF'
func HandleRegistration(w http.ResponseWriter, r *http.Request) {
    // Implementation
}
EOF

git add handlers/registration.go
python3 commit_complexity_analyzer.py --staged-only
# Output: ✅ Complexity: 30.0 (PASS)
git commit -m "feat(registration): implement registration handler"

# Commit 5: Add database migration
cat > migrations/001_create_users.sql << 'EOF'
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
EOF

git add migrations/001_create_users.sql
python3 commit_complexity_analyzer.py --staged-only
# Output: ⚠️  Complexity: 45.0 (PASS with warning - migration detected)
git commit -m "migration(user): add users table"

# Commit 6: Update documentation
cat >> README.md << 'EOF'
## User Registration
API endpoint for user registration...
EOF

git add README.md
python3 commit_complexity_analyzer.py --staged-only
# Output: ✅ Complexity: 5.0 (PASS)
git commit -m "docs(registration): document registration API"

# Final check
git log --oneline -6
# f8a1b2c docs(registration): document registration API
# e7d9c3b migration(user): add users table
# d6c8b4a feat(registration): implement registration handler
# c5b7a3d test(registration): add handler tests
# b4a6c2e feat(user): implement User model with validation
# a3b5c1f test(user): add validation tests for User model
```

## Continuous Improvement Loop

### Metrics Tracking
Track complexity patterns to improve future planning:

```bash
# Create metrics file
cat > .complexity-metrics.json << 'EOF'
{
  "sessions": [
    {
      "date": "2024-01-15",
      "feature": "authentication",
      "planned_stages": 3,
      "actual_stages": 5,
      "complexity_failures": 2,
      "average_commit_size": 75,
      "plan_revisions": 1,
      "root_causes": ["mixed_concerns", "underestimated_coupling"]
    }
  ]
}
EOF
```

### Learning Repository
Maintain a knowledge base of patterns:

```markdown
# .lessons-learned.md

## Authentication Implementation
- **Problem**: JWT implementation hit 250 complexity score
- **Root Cause**: Mixed token generation, validation, and middleware
- **Solution**: Split into 5 separate commits
- **Future Prevention**: Always separate token operations from middleware

## Database Migrations
- **Problem**: Migration + code changes = high complexity
- **Root Cause**: Trying to ship feature complete
- **Solution**: Migration first, then code in separate commits
- **Future Prevention**: Migrations always standalone

## API Changes
- **Problem**: Multiple endpoints in one commit
- **Root Cause**: Viewing CRUD as single unit
- **Solution**: One endpoint per commit
- **Future Prevention**: Vertical slicing by operation
```

### Preventive Planning Checklist
Before starting ANY stage, verify:

```markdown
## Pre-Stage Complexity Check

### Size Estimates
- [ ] Will this touch < 5 files?
- [ ] Will this be < 200 lines total?
- [ ] Will this affect only 1-2 directories?
- [ ] Is this a single logical concern?

### Risk Factors
- [ ] No config file changes mixed with code?
- [ ] No migration mixed with implementation?
- [ ] No dependency updates mixed with features?
- [ ] No API changes mixed with business logic?

### Decomposition Opportunity
- [ ] Can this be split into test + implementation?
- [ ] Can this be split by operation (CRUD)?
- [ ] Can this be split by layer?
- [ ] Can this be split by component?

If ANY checkbox is "No", STOP and decompose further.
```