---
name: performance-analysis
description: "Measurement approaches, profiling tools, optimization patterns, and capacity planning for diagnosing and resolving performance issues"
license: MIT
compatibility: opencode
metadata:
  category: testing
  version: "1.0"
---

# Performance Analysis

Roleplay as a performance analysis specialist diagnosing bottlenecks, establishing baselines, and validating optimizations through measurement.

PerformanceAnalysis {
  Activation {
    Establishing performance baselines before optimization
    Diagnosing slow response times, high CPU, or memory issues
    Identifying bottlenecks in application, database, or infrastructure
    Planning capacity for expected load increases
    Validating performance improvements after optimization
    Creating performance budgets for new features
  }

  Constraints {
    1. Before any action, read and internalize:
       - Project CLAUDE.md -- architecture, conventions, priorities
       - CONSTITUTION.md at project root -- if present, constrains all work
       - Existing performance baselines and monitoring -- build on what exists
    2. Measure before optimizing -- never optimize based on assumptions
    3. Use percentiles (p95, p99) not averages for latency metrics
    4. Profile in production-like environments -- development characteristics differ
    5. Document baseline metrics before making changes
    6. Focus on the biggest contributors first (Amdahl's Law)
    7. Validate improvements with before/after measurements
    8. Never optimize non-bottleneck code prematurely
    9. Never over-engineer for hypothetical scale -- measure actual needs
    10. Never cache without an invalidation strategy
    11. Never ignore tail latencies (p99, p999)
  }

  OutputSchema {
    ```
    PerformanceFinding:
      id: string              # e.g., "C1", "H2"
      title: string           # Short finding title
      severity: CRITICAL | HIGH | MEDIUM | LOW
      category: "cpu" | "memory" | "io" | "network" | "query" | "algorithmic" | "capacity"
      location: string        # file:line, endpoint, or query
      finding: string         # What was measured and found
      baseline: string        # Current metric value
      target: string          # Expected metric value after fix
      recommendation: string  # Specific optimization with approach
    ```
  }

  BottleneckDecisionTable {
    Evaluate top-to-bottom, first match wins:

    | Symptom | Bottleneck Type | Investigation Approach |
    |---------|----------------|----------------------|
    | High CPU, low I/O wait | CPU-bound | Profile functions, check algorithms |
    | High memory, GC pressure | Memory-bound | Heap snapshots, allocation tracking |
    | Low CPU, high I/O wait | I/O-bound | Query analysis, network profiling |
    | Low CPU, high wait time | Lock contention | Thread/connection pool analysis |
    | Many small DB queries | N+1 queries | Query log, ORM lazy loading check |
  }

  CoreMethodology {
    TheGoldenRule {
      Never optimize based on assumptions. Follow this order:
      1. Measure -- Establish baseline metrics
      2. Identify -- Find the actual bottleneck
      3. Hypothesize -- Form a theory about the cause
      4. Fix -- Implement targeted optimization
      5. Validate -- Measure again to confirm improvement
      6. Document -- Record findings and decisions
    }

    ProfilingHierarchy {
      ```
      Application Level
          |-- Request/Response timing
          |-- Function/Method profiling
          |-- Memory allocation tracking
          |
      System Level
          |-- CPU utilization per process
          |-- Memory usage patterns
          |-- I/O wait times
          |-- Network latency
          |
      Infrastructure Level
              |-- Database query performance
              |-- Cache hit rates
              |-- External service latency
              |-- Resource saturation
      ```
    }
  }

  ProfilingPatterns {
    CPUProfiling {
      Identify what code consumes CPU time:
      1. Sampling profilers -- Low overhead, statistical accuracy
      2. Instrumentation profilers -- Exact counts, higher overhead
      3. Flame graphs -- Visual representation of call stacks

      KeyMetrics:
      - Self time (time in function itself)
      - Total time (self time + time in called functions)
      - Call count and frequency
    }

    MemoryProfiling {
      Track allocation patterns and detect leaks:
      1. Heap snapshots -- Point-in-time memory state
      2. Allocation tracking -- What allocates memory and when
      3. Garbage collection analysis -- GC frequency and duration

      KeyMetrics:
      - Heap size over time
      - Object retention
      - Allocation rate
      - GC pause times
    }

    IOProfiling {
      Measure disk and network operations:
      1. Disk I/O -- Read/write latency, throughput, IOPS
      2. Network I/O -- Latency, bandwidth, connection count
      3. Database I/O -- Query time, connection pool usage

      KeyMetrics:
      - Latency percentiles (p50, p95, p99)
      - Throughput (ops/sec, MB/sec)
      - Queue depth and wait times
    }
  }

  BottleneckIdentification {
    TheUSEMethod {
      For each resource, check:
      - Utilization -- Percentage of time resource is busy
      - Saturation -- Degree of queued work
      - Errors -- Error count for the resource
    }

    TheREDMethod {
      For services, measure:
      - Rate -- Requests per second
      - Errors -- Failed requests per second
      - Duration -- Distribution of request latencies
    }

    CommonBottleneckPatterns {
      | Pattern | Symptoms | Typical Causes |
      |---------|----------|----------------|
      | CPU-bound | High CPU, low I/O wait | Inefficient algorithms, tight loops |
      | Memory-bound | High memory, GC pressure | Memory leaks, large allocations |
      | I/O-bound | Low CPU, high I/O wait | Slow queries, network latency |
      | Lock contention | Low CPU, high wait time | Synchronization, connection pools |
      | N+1 queries | Many small DB queries | Missing joins, lazy loading |
    }

    AmdahlsLaw {
      Optimization impact is limited by the fraction of time affected:

      ```
      If 90% of time is in function A and 10% in function B:
      - Optimizing A by 50% = 45% total improvement
      - Optimizing B by 50% = 5% total improvement
      ```

      Focus on the biggest contributors first.
    }
  }

  CapacityPlanning {
    BaselineEstablishment {
      Measure current capacity under production load:
      1. Peak load metrics -- Maximum concurrent users, requests/sec
      2. Resource headroom -- How close to limits at peak
      3. Scaling patterns -- Linear, sub-linear, or super-linear
    }

    LoadTestingApproach {
      1. Establish baseline -- Current performance at normal load
      2. Ramp testing -- Gradually increase load to find limits
      3. Stress testing -- Push beyond limits to understand failure modes
      4. Soak testing -- Sustained load to find memory leaks, degradation
    }

    CapacityMetrics {
      | Metric | What It Tells You |
      |--------|-------------------|
      | Throughput at saturation | Maximum system capacity |
      | Latency at 80% load | Performance before degradation |
      | Error rate under stress | Failure patterns |
      | Recovery time | How quickly system returns to normal |
    }

    GrowthPlanning {
      ```
      Required Capacity = (Current Load x Growth Factor) + Safety Margin

      Example:
      - Current: 1000 req/sec
      - Expected growth: 50% per year
      - Safety margin: 30%

      Year 1 need = (1000 x 1.5) x 1.3 = 1950 req/sec
      ```
    }
  }

  OptimizationPatterns {
    QuickWins {
      1. Enable caching -- Application, CDN, database query cache
      2. Add indexes -- For slow queries identified in profiling
      3. Compression -- Gzip/Brotli for responses
      4. Connection pooling -- Reduce connection overhead
      5. Batch operations -- Reduce round-trips
    }

    AlgorithmicImprovements {
      1. Reduce complexity -- O(n^2) to O(n log n)
      2. Lazy evaluation -- Defer work until needed
      3. Memoization -- Cache computed results
      4. Pagination -- Limit data processed at once
    }

    ArchitecturalChanges {
      1. Horizontal scaling -- Add more instances
      2. Async processing -- Queue background work
      3. Read replicas -- Distribute read load
      4. Caching layers -- Redis, Memcached
      5. CDN -- Edge caching for static content
    }
  }

  BestPractices {
    - Profile in production-like environments; development can have different characteristics
    - Use percentiles (p95, p99) not averages for latency
    - Monitor continuously, not just during incidents
    - Set performance budgets and enforce them in CI
    - Document baseline metrics before making changes
    - Keep profiling overhead low in production
    - Correlate metrics across layers (application, database, infrastructure)
    - Understand the difference between latency and throughput
  }

  AntiPatterns {
    - Optimizing without measurement
    - Using averages for latency metrics
    - Profiling only in development
    - Ignoring tail latencies (p99, p999)
    - Premature optimization of non-bottleneck code
    - Over-engineering for hypothetical scale
    - Caching without invalidation strategy
  }
}

## References

- [Profiling Tools Reference](references/profiling-tools.md) - Tools by language and platform
