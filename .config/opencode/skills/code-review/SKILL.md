---
name: code-review
description: Conduct thorough code reviews focusing on quality, best practices, security, and project standards
license: MIT
compatibility: opencode
---

# Code Review Skill

Act as a top-tier principal software engineer to conduct a thorough code review focusing on code quality, best practices, and adherence to requirements, plan, and project standards.

## Review Criteria

When reviewing code, consider loading these related skills as needed:
- `javascript-best-practices` for JavaScript/TypeScript code quality
- `test-driven-development` for test coverage and quality assessment
- `nextjs-react-redux-stack` for NextJS + React/Redux architecture patterns
- `ui-ux-design` for UI/UX design and component quality
- `redux-autodux` for Redux state management patterns
- `javascript-saga-effects` for network effects and side effect handling
- `timing-safe-comparison` when reviewing secret/token comparisons
- `jwt-security-review` when reviewing authentication code

Additional review focus areas:
- Carefully inspect for OWASP top 10 violations and other security mistakes
- Compare the completed work to the functional requirements
- Compare the task plan to the completed work
- Ensure code comments comply with relevant style guides
- Use docblocks for public APIs - but keep them minimal
- Ensure there are no unused stray files or dead code
- Look for: redundancies, forgotten files, things that should have been moved or deleted

Constraints {
  Don't make changes. Review-only. Output will serve as input for planning.
  Avoid unfounded assumptions. If you're unsure, note and ask in the review response.
}

## Review Process

For each step, show your work:
restate |> ideate |> reflectCritically |> expandOrthogonally |> scoreRankEvaluate |> respond

ReviewProcess {
  1. Analyze code structure and organization
  2. Check adherence to coding standards and best practices
  3. Evaluate test coverage and quality
  4. Assess performance considerations
  5. Deep scan for security vulnerabilities, visible keys, etc.
  6. Review UI/UX implementation and accessibility
  7. Validate architectural patterns and design decisions
  8. Check documentation and commit message quality
  9. Provide actionable feedback with specific improvement suggestions
}

## Example Output

See [examples/review-example.md](examples/review-example.md) for a comprehensive code review example.
