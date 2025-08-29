# Codebase Architecture Analysis Prompt

## Mission
Perform a comprehensive architectural analysis of the codebase. **Think hard** about the design decisions, patterns, and potential issues. Generate a detailed markdown report with actionable refactoring recommendations and code health metrics.

## Analysis Framework

### Phase 1: Initial Discovery and Mapping

#### 1.1 Codebase Structure Analysis
**Think hard** about the organization before diving into files.

```
Document the following:
- Repository structure and module organization
- Package/namespace hierarchy
- Dependency flow between modules
- Entry points and main execution paths
- Configuration and infrastructure code separation
- Test organization and coverage
```

#### 1.2 Technology Stack Assessment
```
Identify:
- Primary language(s) and versions
- Frameworks and libraries in use
- Build tools and dependency management
- Testing frameworks
- External service integrations
- Database/storage technologies
```

### Phase 2: File-by-File Deep Analysis

For EACH file in the codebase, perform this analysis:

#### 2.1 File Classification
```
File: [path/to/file]
Type: [Domain Logic | Infrastructure | Configuration | Test | Utility | Interface]
Responsibility: [Primary purpose in one sentence]
Dependencies: [List of imports/dependencies]
Dependents: [Files that depend on this one]
Lines of Code: [Total]
Cyclomatic Complexity: [Calculate if possible]
Test Coverage: [If available]
```

#### 2.2 Design Pattern Detection
**Think hard** about intentional patterns vs accidental patterns.

```
✅ Identified Patterns:
- [Pattern Name]: [Where/how implemented]
  - Implementation Quality: [Good/Adequate/Poor]
  - Adherence to Pattern: [Full/Partial/Misused]
  - Notes: [Any deviations or concerns]

⚠️ Misused Patterns:
- [Pattern Name]: [How it's misused]
  - Impact: [Problems it causes]
  - Recommendation: [How to fix]

❌ Missing Patterns:
- [Pattern Name]: [Where it should be used]
  - Benefit: [What it would solve]
  - Implementation Effort: [Low/Medium/High]
```

#### 2.3 Code Smell Detection
Rate severity: 🔴 Critical | 🟠 Major | 🟡 Minor | ⚪ Cosmetic

```
🔴 CRITICAL SMELLS:
- [Smell Type]: [Specific instance]
  - Location: [Line numbers]
  - Impact: [What problems it causes]
  - Example: [Code snippet]
  - Fix Priority: [Immediate/High/Medium]

🟠 MAJOR SMELLS:
- [List with same detail]

🟡 MINOR SMELLS:
- [List with same detail]
```

#### 2.4 Bad Practice Identification
```
Security Issues:
- [Issue]: [Description, location, severity]

Performance Issues:
- [Issue]: [Description, impact, location]

Maintainability Issues:
- [Issue]: [Description, why it matters]

Testability Issues:
- [Issue]: [Description, how it blocks testing]

Concurrency Issues:
- [Issue]: [Description, potential race conditions]
```

#### 2.5 SOLID Principles Evaluation
```
Single Responsibility: [✅/⚠️/❌] [Explanation]
Open/Closed: [✅/⚠️/❌] [Explanation]
Liskov Substitution: [✅/⚠️/❌] [Explanation]
Interface Segregation: [✅/⚠️/❌] [Explanation]
Dependency Inversion: [✅/⚠️/❌] [Explanation]
```

### Phase 3: Architecture-Level Analysis

#### 3.1 Architectural Pattern Assessment
```
Identified Architecture: [Layered/Hexagonal/Microservices/Monolithic/etc.]
Pattern Consistency: [0-100%]
Boundary Violations: [List cross-boundary dependencies]
Architectural Debt: [List major deviations]
```

#### 3.2 Coupling and Cohesion Analysis
```
High Coupling Hotspots:
- [Component A] <-> [Component B]: [Coupling type and severity]

Low Cohesion Areas:
- [Component]: [Why cohesion is low]

Circular Dependencies:
- [Dependency cycle description]
```

#### 3.3 Cross-Cutting Concerns
```
Logging Strategy: [Consistent/Inconsistent] [Details]
Error Handling: [Pattern used, consistency score]
Security Implementation: [Centralized/Scattered] [Details]
Caching Strategy: [Present/Absent] [Implementation]
Transaction Management: [Pattern and consistency]
```

### Phase 4: Metrics Calculation

#### 4.1 Code Health Score Calculation

**Think hard** about weighing these metrics appropriately for the codebase type.

```
COMPONENT SCORES (0-100):

Structure Score: [X/100]
- Module organization: [0-25]
- Dependency management: [0-25]
- Separation of concerns: [0-25]
- Naming consistency: [0-25]

Quality Score: [X/100]
- Test coverage: [0-20]
- Code duplication: [0-20]
- Complexity metrics: [0-20]
- Documentation: [0-20]
- Error handling: [0-20]

Maintainability Score: [X/100]
- Readability: [0-25]
- Modularity: [0-25]
- Testability: [0-25]
- Changeability: [0-25]

Security Score: [X/100]
- Input validation: [0-25]
- Authentication/Authorization: [0-25]
- Data protection: [0-25]
- Security best practices: [0-25]

Performance Score: [X/100]
- Algorithm efficiency: [0-25]
- Resource management: [0-25]
- Caching usage: [0-25]
- Database optimization: [0-25]

OVERALL HEALTH SCORE: [Weighted Average]/100
- Grade: [A: 90-100 | B: 80-89 | C: 70-79 | D: 60-69 | F: <60]
```

#### 4.2 Technical Debt Estimation
```
Technical Debt Score: [Hours estimated to fix all issues]

Breakdown:
- Critical Issues: [X hours]
- Major Issues: [Y hours]
- Minor Issues: [Z hours]
- Nice-to-have Improvements: [W hours]

Debt Ratio: [Debt hours / Total development hours]
```

### Phase 5: Refactoring Recommendations

#### 5.1 Priority Matrix
```
IMMEDIATE (Do Now - Critical Issues):
1. [Issue]: [File/Location]
   - Risk if not fixed: [Description]
   - Effort: [Hours]
   - Implementation: [Step-by-step approach]

HIGH PRIORITY (Do Next Sprint):
1. [Issue]: [Details]
   - Business impact: [Description]
   - Effort: [Hours]
   - Dependencies: [What needs to be done first]

MEDIUM PRIORITY (Do This Quarter):
[List with same structure]

LOW PRIORITY (Nice to Have):
[List with same structure]
```

#### 5.2 Refactoring Strategies

For each major refactoring recommendation:

```
Refactoring: [Name/Description]
Pattern to Apply: [Design pattern or principle]
Files Affected: [List]

Current State:
```[language]
[Code example showing problem]
```

Proposed State:
```[language]
[Code example showing solution]
```

Migration Steps:
1. [First safe step]
2. [Second step with tests]
3. [Continue step by step]

Risks:
- [Risk 1]: [Mitigation strategy]

Benefits:
- [Quantifiable benefit]

Testing Strategy:
- [How to verify the refactoring]
```

### Phase 6: Report Generation

## FINAL MARKDOWN REPORT STRUCTURE

```markdown
# Codebase Architecture Analysis Report

**Generated**: [Date]
**Analyzed**: [Repository/Project Name]
**Total Files**: [Count]
**Lines of Code**: [Total]

## Executive Summary

### Overall Health Score: [X/100] - Grade [A-F]

**Key Findings:**
- 🔴 [Most critical issue]
- 🟠 [Major concern]
- 🟢 [Positive finding]

**Immediate Actions Required:**
1. [Critical fix 1]
2. [Critical fix 2]

## Architecture Overview

### System Architecture
[Diagram or ASCII representation]

### Technology Stack
- **Language**: [Details]
- **Framework**: [Details]
- **Database**: [Details]
- **Testing**: [Coverage %]

## Detailed Analysis

### 🏗️ Architectural Patterns

#### Identified Patterns
[Comprehensive list with quality assessment]

#### Pattern Violations
[List with severity and impact]

### 🔍 Code Quality Metrics

| Metric | Score | Grade | Benchmark |
|--------|-------|-------|-----------|
| Structure | X/100 | A-F | Industry: Y |
| Quality | X/100 | A-F | Industry: Y |
| Maintainability | X/100 | A-F | Industry: Y |
| Security | X/100 | A-F | Industry: Y |
| Performance | X/100 | A-F | Industry: Y |

### 📊 Code Smell Distribution

| Severity | Count | Top Issues |
|----------|-------|------------|
| 🔴 Critical | X | [List] |
| 🟠 Major | Y | [List] |
| 🟡 Minor | Z | [List] |

### 📁 File-by-File Analysis

[Detailed analysis for each file, grouped by module/package]

#### Module: [Name]

**File**: `path/to/file.ext`
- **Health**: [Score/100]
- **Complexity**: [Cyclomatic complexity]
- **Issues**: [Count]
- **Patterns**: [List]
- **Smells**: [List]
- **Recommendations**: [Priority fixes]

[Continue for all files]

## 🚨 Critical Issues

### Issue 1: [Name]
- **Severity**: Critical
- **Location**: [Files affected]
- **Impact**: [Business/Technical impact]
- **Fix Effort**: [Hours]
- **Recommendation**: [Specific solution]

[Continue for all critical issues]

## 💡 Refactoring Roadmap

### Phase 1: Critical Fixes (Week 1-2)
| Task | Files | Effort | Risk | Owner |
|------|-------|--------|------|-------|
| [Task] | [Count] | [Hours] | [L/M/H] | TBD |

### Phase 2: High Priority (Week 3-4)
[Same table structure]

### Phase 3: Medium Priority (Month 2-3)
[Same table structure]

## 📈 Improvement Tracking

### Proposed Metrics After Refactoring
| Metric | Current | Target | Improvement |
|--------|---------|--------|-------------|
| Code Coverage | X% | Y% | +Z% |
| Cyclomatic Complexity | X | Y | -Z |
| Technical Debt | X hrs | Y hrs | -Z hrs |
| Build Time | X min | Y min | -Z min |

## 🎯 Recommendations Summary

### Do Immediately
1. [Action with specific steps]
2. [Action with specific steps]

### Do Next Sprint
1. [Action with reasoning]
2. [Action with reasoning]

### Consider for Roadmap
1. [Long-term improvement]
2. [Long-term improvement]

### Stop Doing
1. [Practice to eliminate]
2. [Practice to eliminate]

## 📚 Appendix

### A. Methodology
[Describe analysis methods and tools used]

### B. Code Examples
[Detailed before/after examples for major refactorings]

### C. Tool Recommendations
[Linters, analyzers, CI/CD improvements]

### D. Team Training Needs
[Identified knowledge gaps and training recommendations]

---
**Next Steps**: Schedule review meeting to discuss priority items and assign ownership.
```

## Analysis Execution Guidelines

1. **Think hard** before scoring - consider the codebase's context and constraints
2. Be specific - avoid generic recommendations
3. Provide code examples for every major issue
4. Include effort estimates for all recommendations
5. Consider the team's skill level and capacity
6. Balance idealism with pragmatism
7. Focus on business value, not just technical perfection
8. Include quick wins alongside major refactorings
9. Provide migration paths, not just end states
10. Consider backward compatibility requirements

## Output Requirements

- Generate the complete markdown report
- Include all sections even if some are empty (mark as N/A)
- Use consistent scoring methodology
- Provide actionable, specific recommendations
- Include code snippets for clarity
- Make the report scannable with clear hierarchy
- Ensure recommendations are prioritized and realistic

**Think hard** - Is your analysis thorough, fair, and actionable? Will the team be able to improve their codebase using your recommendations?