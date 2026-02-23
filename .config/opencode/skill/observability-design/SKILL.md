---
name: observability-design
description: "Monitoring strategies, distributed tracing, SLI/SLO design, and alerting patterns. Use when designing monitoring infrastructure, defining service level objectives, implementing distributed tracing, creating alert rules, building dashboards, or establishing incident response procedures."
license: MIT
compatibility: opencode
metadata:
  category: infrastructure
  version: "1.0"
---

# Observability Design

Roleplay as an observability design specialist for building monitoring, alerting, and diagnostic systems that turn telemetry into actionable insight.

ObservabilityDesign {
  Activation {
    Designing monitoring infrastructure for new services
    Defining SLIs, SLOs, and error budgets for reliability
    Implementing distributed tracing across microservices
    Creating alert rules that minimize noise and maximize signal
    Building dashboards for operations and business stakeholders
    Establishing incident response and postmortem processes
    Diagnosing production issues through telemetry correlation
  }

  Constraints {
    1. You cannot fix what you cannot see
    2. Observability is about answering questions you have not thought to ask yet
    3. Turn every incident into a learning opportunity
    4. Turn every metric into actionable insight
    5. Correlate metrics, logs, and traces with shared identifiers
  }

  ThreePillars {
    Metrics {
      Description: "Numeric measurements aggregated over time. Best for understanding system behavior at scale."

      Characteristics {
        Highly efficient storage (aggregated values)
        Support mathematical operations (rates, percentiles)
        Enable alerting on thresholds
        Limited cardinality (avoid high-cardinality labels)
      }

      Types {
        | Type | Use Case | Example |
        |------|----------|---------|
        | Counter | Cumulative values that only increase | Total requests, errors, bytes sent |
        | Gauge | Values that go up and down | Current memory, active connections |
        | Histogram | Distribution of values in buckets | Request latency, payload sizes |
        | Summary | Similar to histogram, calculated client-side | Pre-computed percentiles |
      }
    }

    Logs {
      Description: "Immutable records of discrete events. Best for understanding specific occurrences."

      Characteristics {
        Rich context and arbitrary data
        Expensive to store and query at scale
        Essential for debugging specific issues
        Should be structured (JSON) for parseability
      }

      Structure {
        ```
        Required fields:
        - timestamp: ISO 8601 format with timezone
        - level: ERROR, WARN, INFO, DEBUG
        - message: Human-readable description
        - service: Service identifier
        - trace_id: Correlation identifier

        Context fields:
        - user_id: Sanitized user identifier
        - request_id: Request correlation
        - duration_ms: Operation timing
        - error_type: Classification for errors
        ```
      }
    }

    Traces {
      Description: "Records of request flow across distributed systems. Best for understanding causality and latency."

      Characteristics {
        Show request path through services
        Identify latency bottlenecks
        Reveal dependencies and failure points
        Higher overhead than metrics
      }

      Components {
        Trace: "Complete request journey"
        Span: "Single operation within a trace"
        Context: "Metadata propagated across services"
      }
    }
  }

  SLISLOFramework {
    ServiceLevelIndicators {
      Description: "Quantitative measures of service behavior from the user perspective"

      Categories {
        | Category | Measures | Example SLI |
        |----------|----------|-------------|
        | Availability | Service is responding | % of successful requests |
        | Latency | Response speed | % of requests < 200ms |
        | Throughput | Capacity | Requests processed per second |
        | Error Rate | Correctness | % of requests without errors |
        | Freshness | Data currency | % of data < 1 minute old |
      }

      SpecificationExample {
        ```
        SLI: Request Latency
        Definition: Time from request received to response sent
        Measurement: Server-side histogram at p50, p95, p99
        Exclusions: Health checks, internal tooling
        Data source: Application metrics
        ```
      }
    }

    ServiceLevelObjectives {
      Description: "Target reliability levels for SLIs over a time window"

      Formula {
        ```
        SLO = (Good events / Total events) >= Target over Window

        Example:
        99.9% of requests complete successfully in < 200ms
        measured over a 30-day rolling window
        ```
      }

      SettingTargets {
        Start with current baseline performance
        Consider user expectations and business impact
        Balance reliability investment against feature velocity
        Document error budget policy
      }
    }

    ErrorBudgets {
      Description: "The allowed amount of unreliability within an SLO"

      Calculation {
        ```
        Error Budget = 1 - SLO Target

        99.9% SLO = 0.1% error budget
        = 43.2 minutes downtime per 30 days
        = 8.64 seconds per day
        ```
      }

      Policies {
        BudgetRemaining: "Continue feature development"
        BudgetDepleted: "Focus on reliability work"
        BudgetBurningFast: "Freeze deploys, investigate"
      }
    }
  }

  AlertingStrategies {
    SymptomBasedAlerts {
      Description: "Alert on user-visible symptoms, not internal causes"

      GoodAlerts {
        Error rate exceeds threshold (users experiencing failures)
        Latency SLO at risk (users experiencing slowness)
        Queue depth growing (backlog affecting users)
      }

      PoorAlerts {
        CPU at 80% (may not affect users)
        Pod restarted (self-healing, may not affect users)
        Disk at 70% (not yet impacting service)
      }
    }

    MultiWindowMultiBurnRate {
      Description: "Detect fast burns quickly, slow burns before budget depletion"

      Configuration {
        ```
        Fast burn: 14.4x burn rate over 1 hour
          - Fires in 1 hour if issue persists
          - Catches severe incidents quickly

        Slow burn: 3x burn rate over 3 days
          - Fires before 30-day budget depletes
          - Catches gradual degradation
        ```
      }
    }

    AlertFatiguePrevention {
      Strategies {
        Alert only on actionable issues
        Consolidate related alerts
        Set meaningful thresholds (not arbitrary)
        Require sustained condition before firing
        Include runbook links in every alert
        Review and prune alerts quarterly
      }

      QualityChecklist {
        Can someone take action right now?
        Is the severity appropriate?
        Does it include enough context?
        Is there a runbook linked?
        Has it fired false positives recently?
      }
    }
  }

  DashboardDesign {
    Hierarchy {
      ServiceHealthOverview {
        High-level SLO status
        Error budget consumption
        Key business metrics
        Designed for quick triage
      }

      DeepDiveDiagnostic {
        Detailed metrics breakdown
        Resource utilization
        Dependency health
        Designed for investigation
      }

      BusinessMetrics {
        User-facing KPIs
        Conversion and engagement
        Revenue impact
        Designed for stakeholders
      }
    }

    Principles {
      Answer specific questions, not show all data
      Use consistent color coding (green=good, red=bad)
      Show time ranges appropriate to the metric
      Include context (deployments, incidents) on graphs
      Mobile-responsive for on-call use
      Provide drill-down paths to detailed views
    }

    EssentialPanels {
      | Panel | Purpose | Audience |
      |-------|---------|----------|
      | SLO Status | Current reliability vs target | Everyone |
      | Error Budget | Remaining budget and burn rate | Engineering |
      | Request Rate | Traffic patterns and anomalies | Operations |
      | Latency Distribution | p50, p95, p99 over time | Engineering |
      | Error Breakdown | Errors by type and endpoint | Engineering |
      | Dependency Health | Status of upstream services | Operations |
    }
  }

  BestPractices {
    Correlate metrics, logs, and traces with shared identifiers
    Instrument code at service boundaries, not everywhere
    Use structured logging with consistent field names
    Set retention policies appropriate to data value
    Test alerts in staging before production
    Document SLOs and share with stakeholders
    Conduct regular game days to validate observability
    Automate common diagnostic procedures in runbooks
  }

  AntiPatterns {
    Alert on every possible metric (alert fatigue)
    Create dashboards without specific questions in mind
    Log without structure or correlation IDs
    Set SLOs without measuring current baseline
    Ignore error budget policies when convenient
    Treat all alerts with equal severity
    Store high-cardinality data in metrics (use logs/traces)
    Skip postmortems when issues resolve themselves
  }
}

## References

- [references/monitoring-patterns.md](references/monitoring-patterns.md) - Detailed implementation patterns and examples
