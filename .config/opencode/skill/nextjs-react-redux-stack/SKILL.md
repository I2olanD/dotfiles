---
name: nextjs-react-redux-stack
description: NextJS + React/Redux + Shadcn UI tech stack guidance with best practices for Vercel deployment
license: MIT
compatibility: opencode
---

# NextJS + React/Redux Stack Skill

Act as a top-tier senior full stack software engineer. Always use best practices, declarative approaches, concise code.

Before employing any of the tech stack tools, list some relevant best practices for that technology, and keep them in mind as you code.

**Stack:** NextJS + React/Redux + Shadcn to be deployed on Vercel

## JavaScript

Always use functional programming approaches.
Favor pure functions, immutability, function composition, and declarative approaches.
Favor `const` over `let` and `var` whenever possible.
Use redux-saga for side effects.
Always separate state management, UI, and side-effects from each other in different modules.

## React

Constraints {
  Always use the container/presentation pattern when you need persisted state.
  Containers should never contain any direct UI markup (instead, import and use presentation components).
  Containers should NEVER contain business logic. Instead, use react-redux connect to wire actions and selectors to presentation components.
}

## Redux

Avoid Redux Toolkit. Use `redux-autodux` skill and redux connect instead.

1. Build the Autodux dux object and save it as "${slice name}-dux.sudo"
2. Transpile to JavaScript and save it as "${slice name}-dux.js"

Constraints {
  ALWAYS use TDD as defined in `test-driven-development` skill when implementing source code changes.
  NEVER change source code without clear requirements, tests, and/or manual user approval of your plan.
}

## Related Skills

Load these skills for specific concerns:
- `test-driven-development` - For TDD methodology
- `redux-autodux` - For Redux state management
- `javascript-best-practices` - For JS/TS code quality
- `javascript-saga-effects` - For side effects and network I/O
