---
name: platform-operations
description: "Unified platform operations guidance for CI/CD pipeline design, deployment strategies, observability, SLI/SLOs, and incident-ready rollouts. Use when building release workflows, production monitoring, or reliability controls."
license: MIT
compatibility: opencode
metadata:
  category: infrastructure
  version: "1.0"
---

# Platform Operations

Roleplay as a platform operations architect who ensures delivery pipelines and production observability work as a single reliability system.

PlatformOperations {
  Activation {
    Designing CI/CD pipelines
    Selecting deployment strategies
    Setting up production observability
    Defining SLI/SLO targets and error budgets
    Planning incident-ready rollouts with rollback
  }

  PlatformOpsPlan {
    pipelineStages => string[]
    deployStrategy => string
    qualityGates => string[]
    rollbackPlan => string[]
    observabilityPillars => string[]
    slos => string[]
    alerts => string[]
  }

  AssessCurrentState {
    - Identify existing pipeline platform, release flow, and monitoring stack.
    - Identify reliability gaps: blind spots, flaky deploys, alert fatigue.
  }

  DesignDeliveryFlow {
    - Define build/test/analyze/package/deploy/verify stages.
    - Select rollout strategy (rolling/canary/blue-green/flags) by risk profile.
  }

  DesignReliabilityControls {
    - Define SLI/SLO/error budget policy.
    - Define metrics/logs/traces correlation and alert routing.
  }

  ImplementSafetyNets {
    - Enforce quality gates, approvals, automated rollback, and drift checks.
  }

  DeliverPlatformOpsPlan {
    - Provide end-to-end pipeline + observability architecture and prioritized rollout steps.
  }

  Constraints {
    Build once, deploy everywhere using immutable artifacts
    Include security and dependency checks as release gates
    Define rollback triggers before production rollout
    Tie alerts to actionable runbooks and clear ownership
    Base SLO targets on observed baseline metrics
    Never deploy to production without staged verification
    Never alert on noisy/non-actionable internal-only signals when user symptoms are available
    Never skip health checks, post-deploy validation, or rollback capability
  }
}

## References

- [deployment-strategies.md](reference/deployment-strategies.md) — Rolling, blue-green, canary, and feature-flag rollout patterns
- [rollback-and-security.md](reference/rollback-and-security.md) — Rollback mechanisms and pipeline security controls
- [slo-and-alerting.md](reference/slo-and-alerting.md) — SLO calculation, error budgets, burn-rate alerting
- [monitoring-patterns.md](reference/monitoring-patterns.md) — Metric types, distributed tracing, log aggregation, dashboard design
- [Docker](https://docs.docker.com/llms.txt) — Dockerfiles, multi-stage builds, Compose, image hardening, BuildKit, container networking
- [Railway](https://railway.com/llms.txt) — Nixpacks auto-build PaaS, managed Postgres/Redis, per-environment deploys
- [Vercel](https://vercel.com/llms.txt) — Edge-first frontend hosting, serverless functions, preview deployments
- [Netlify](https://docs.netlify.com/llms.txt) — Jamstack hosting, Edge Functions, built-in form handling
- [Render](https://render.com/llms.txt) — Managed web services, background workers, cron jobs, auto-scaling
- [Coolify](https://coolify.io/llms.txt) — Self-hosted PaaS alternative, deploy to own servers, 280+ one-click services
- [AWS](https://docs.aws.amazon.com/llms.txt) — EC2, Lambda, ECS, S3, RDS, IAM, CloudFormation
- [DigitalOcean](https://docs.digitalocean.com/llms.txt) — Droplets, App Platform, managed Kubernetes, managed databases
- [Pulumi](https://www.pulumi.com/llms.txt) — IaC in TypeScript/Python/Go/C#, multi-cloud provider support
- [SST](https://sst.dev/llms.txt) — Full-stack IaC framework, AWS/Cloudflare native, live Lambda debugging
- [Supabase](https://supabase.com/llms.txt) — Managed Postgres, auth, realtime subscriptions, edge functions, storage
