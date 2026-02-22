---
name: performance-analysis
description: Measurement approaches, profiling tools, optimization patterns, and capacity planning. Use when diagnosing performance issues, establishing baselines, identifying bottlenecks, or planning for scale. Always measure before optimizing.
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Performance Profiling

## When to Use

- Establishing performance baselines before optimization
- Diagnosing slow response times, high CPU, or memory issues
- Identifying bottlenecks in application, database, or infrastructure
- Planning capacity for expected load increases
- Validating performance improvements after optimization
- Creating performance budgets for new features

## Core Methodology

```sudolang
PerformanceAnalysis {
  State {
    baseline
    bottleneck
    hypothesis
    measurements
  }

  Constraints {
    Never optimize based on assumptions.
    Always measure before and after changes.
    Profile in production-like environments.
    Use percentiles (p95, p99) not averages for latency.
  }

  The Golden Rule: Measure First.

  Workflow {
    1. Measure   => Establish baseline metrics
    2. Identify  => Find the actual bottleneck
    3. Hypothesize => Form theory about cause
    4. Fix       => Implement targeted optimization
    5. Validate  => Measure again to confirm improvement
    6. Document  => Record findings and decisions
  }
}
```

### Profiling Hierarchy

Profile at the right level to find the actual bottleneck:

```sudolang
ProfilingLevels {
  ApplicationLevel {
    - Request/Response timing
    - Function/Method profiling
    - Memory allocation tracking
  }

  SystemLevel {
    - CPU utilization per process
    - Memory usage patterns
    - I/O wait times
    - Network latency
  }

  InfrastructureLevel {
    - Database query performance
    - Cache hit rates
    - External service latency
    - Resource saturation
  }
}
```

## Profiling Patterns

### CPU Profiling

Identify what code consumes CPU time:

1. **Sampling profilers** - Low overhead, statistical accuracy
2. **Instrumentation profilers** - Exact counts, higher overhead
3. **Flame graphs** - Visual representation of call stacks

```sudolang
CPUMetrics {
  selfTime        Time in function itself.
  totalTime       Self time plus time in called functions.
  callCount       Number of invocations.
  frequency       Calls per second.
}
```

### Memory Profiling

Track allocation patterns and detect leaks:

1. **Heap snapshots** - Point-in-time memory state
2. **Allocation tracking** - What allocates memory and when
3. **Garbage collection analysis** - GC frequency and duration

```sudolang
MemoryMetrics {
  heapSize            Heap size over time.
  objectRetention     Objects held in memory.
  allocationRate      Bytes allocated per second.
  gcPauseTimes        GC pause durations.
}
```

### I/O Profiling

Measure disk and network operations:

1. **Disk I/O** - Read/write latency, throughput, IOPS
2. **Network I/O** - Latency, bandwidth, connection count
3. **Database I/O** - Query time, connection pool usage

```sudolang
IOMetrics {
  latencyPercentiles {
    p50
    p95
    p99
  }
  throughput
  queueDepth
  waitTimes
}
```

## Bottleneck Identification

### The USE Method

For each resource, check:
- **U**tilization - Percentage of time resource is busy
- **S**aturation - Degree of queued work
- **E**rrors - Error count for the resource

### The RED Method

For services, measure:
- **R**ate - Requests per second
- **E**rrors - Failed requests per second
- **D**uration - Distribution of request latencies

### Common Bottleneck Patterns

```sudolang
identifyBottleneck(symptoms) {
  match symptoms {
    { cpu: high, ioWait: low } => {
      type: "CPU-bound"
      causes: ["Inefficient algorithms", "Tight loops"]
      focus: "Algorithmic optimization"
    }
    { memory: high, gcPressure: high } => {
      type: "Memory-bound"
      causes: ["Memory leaks", "Large allocations"]
      focus: "Memory profiling and leak detection"
    }
    { cpu: low, ioWait: high } => {
      type: "I/O-bound"
      causes: ["Slow queries", "Network latency"]
      focus: "Query optimization, caching"
    }
    { cpu: low, waitTime: high } => {
      type: "Lock contention"
      causes: ["Synchronization", "Connection pools"]
      focus: "Concurrency analysis"
    }
    { dbQueries: many, querySize: small } => {
      type: "N+1 queries"
      causes: ["Missing joins", "Lazy loading"]
      focus: "Query batching, eager loading"
    }
  }
}
```

### Amdahl's Law

Optimization impact is limited by the fraction of time affected:

```sudolang
calculateOptimizationImpact(fractionAffected, speedupFactor) {
  If 90% of time is in function A:
    Optimizing A by 50% = 45% total improvement.
    Optimizing B (10%) by 50% = 5% total improvement.

  totalSpeedup = 1 / ((1 - fractionAffected) + (fractionAffected / speedupFactor))

  warn if fractionAffected < 0.1: "Focus on the biggest contributors first"
}
```

## Capacity Planning

### Baseline Establishment

Measure current capacity under production load:

```sudolang
BaselineMetrics {
  peakLoad {
    concurrentUsers
    requestsPerSec
  }
  resourceHeadroom {
    cpu       How close to limits at peak.
    memory
    io
  }
  scalingPattern   "linear" | "sub-linear" | "super-linear"
}
```

### Load Testing Approach

```sudolang
LoadTestingPhases {
  1. EstablishBaseline => Current performance at normal load
  2. RampTesting       => Gradually increase load to find limits
  3. StressTesting     => Push beyond limits to understand failure modes
  4. SoakTesting       => Sustained load to find memory leaks, degradation
}
```

### Capacity Metrics

```sudolang
interpretCapacityMetric(metric) {
  match metric {
    "throughputAtSaturation" => "Maximum system capacity"
    "latencyAt80PercentLoad" => "Performance before degradation"
    "errorRateUnderStress"   => "Failure patterns"
    "recoveryTime"           => "How quickly system returns to normal"
  }
}
```

### Growth Planning

```sudolang
calculateRequiredCapacity(currentLoad, growthFactor, safetyMargin = 0.30) {
  Required Capacity = (Current Load x Growth Factor) + Safety Margin.

  projectedLoad = currentLoad * (1 + growthFactor)
  requiredCapacity = projectedLoad * (1 + safetyMargin)

  Example:
    Current: 1000 req/sec.
    Expected growth: 50% per year.
    Safety margin: 30%.
    Year 1 need = (1000 x 1.5) x 1.3 = 1950 req/sec.
}
```

## Optimization Patterns

### Quick Wins

```sudolang
QuickWins {
  1. EnableCaching      => "Application, CDN, database query cache"
  2. AddIndexes         => "For slow queries identified in profiling"
  3. Compression        => "Gzip/Brotli for responses"
  4. ConnectionPooling  => "Reduce connection overhead"
  5. BatchOperations    => "Reduce round-trips"
}
```

### Algorithmic Improvements

```sudolang
AlgorithmicOptimizations {
  1. ReduceComplexity   => "O(n^2) to O(n log n)"
  2. LazyEvaluation     => "Defer work until needed"
  3. Memoization        => "Cache computed results"
  4. Pagination         => "Limit data processed at once"
}
```

### Architectural Changes

```sudolang
ArchitecturalScaling {
  1. HorizontalScaling  => "Add more instances"
  2. AsyncProcessing    => "Queue background work"
  3. ReadReplicas       => "Distribute read load"
  4. CachingLayers      => "Redis, Memcached"
  5. CDN                => "Edge caching for static content"
}
```

## Best Practices

```sudolang
PerformanceBestPractices {
  require {
    Profile in production-like environments.
    Use percentiles (p95, p99) not averages for latency.
    Monitor continuously, not just during incidents.
    Document baseline metrics before making changes.
    Correlate metrics across layers.
  }

  warn {
    Development can have different characteristics than production.
    Profiling overhead should be low in production.
    Latency and throughput are different concerns.
  }

  Constraints {
    Set performance budgets and enforce them in CI.
    Keep profiling overhead low in production.
    Understand the difference between latency and throughput.
  }
}
```

## Anti-Patterns

```sudolang
PerformanceAntiPatterns {
  warn if any {
    Optimizing without measurement.
    Using averages for latency metrics.
    Profiling only in development.
    Ignoring tail latencies (p99, p999).
    Premature optimization of non-bottleneck code.
    Over-engineering for hypothetical scale.
    Caching without invalidation strategy.
  }
}
```

## References

- [Profiling Tools Reference](references/profiling-tools.md) - Tools by language and platform
