---
name: requirements-elicitation
description: "Requirement gathering techniques, stakeholder analysis, user story patterns, and specification validation."
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Requirements Elicitation

Roleplay as a requirements elicitation specialist transforming vague ideas into clear, testable specifications that align stakeholders and guide implementation.

RequirementsElicitation {
  Activation {
    When to use this skill:
    - Gathering requirements for new features
    - Clarifying vague or ambiguous requests
    - Resolving conflicting stakeholder needs
    - Documenting formal specifications
    - Creating user stories with acceptance criteria
    - Validating requirements before implementation
  }

  ElicitationTechniques {
    The5Whys {
      Purpose: Drill past surface requests to discover root needs

      Example {
        ```
        Surface Request: "We need a dashboard"

        Why 1: Why do you need a dashboard?
        -> "To see our metrics in one place"

        Why 2: Why do you need to see metrics in one place?
        -> "To identify problems quickly"

        Why 3: Why do you need to identify problems quickly?
        -> "Because slow response affects customer satisfaction"

        Why 4: Why does customer satisfaction matter right now?
        -> "We're losing customers and don't know why until it's too late"

        Why 5: Why don't you know until it's too late?
        -> "We only see issues in monthly reports"

        Root Need: Real-time alerting for customer-impacting issues
        (Not just a dashboard - the dashboard was a solution, not the need)
        ```
      }
    }

    ConcreteExamples {
      Purpose: Transform abstract requirements into specific, testable scenarios

      | Abstract | Concrete |
      |----------|----------|
      | "The system should be fast" | "Page loads in under 2 seconds on 3G" |
      | "Users should be able to search" | "Find orders by customer name, date range, or status" |
      | "It needs to be secure" | "All PII encrypted at rest, session timeout after 15 min inactive" |
      | "Good error handling" | "Network failures retry 3x with exponential backoff, then show offline mode" |
    }

    BoundaryIdentification {
      Purpose: Define what's explicitly in and out of scope

      Example {
        ```
        Feature: User Registration

        IN SCOPE:
        - Email/password registration
        - Email verification
        - Password strength requirements
        - Terms of service acceptance

        OUT OF SCOPE:
        - Social login (Google, Facebook)
        - Two-factor authentication
        - Password recovery (separate feature)

        DEFERRED:
        - SSO integration (planned for Q3)
        - Biometric login (pending security review)
        ```
      }
    }

    StakeholderInterviews {
      Purpose: Structured conversation to extract requirements

      Structure {
        ```
        Interview Structure (45 min):

        1. CONTEXT (10 min)
           - What's your role in this project?
           - What does success look like for you?
           - What's driving this initiative?

        2. CURRENT STATE (10 min)
           - How do you do this today?
           - What works well?
           - What are the pain points?

        3. DESIRED STATE (15 min)
           - What would the ideal solution look like?
           - Walk me through a typical scenario...
           - What would make your job easier?

        4. CONSTRAINTS (5 min)
           - What absolutely must be included?
           - What's definitely out of scope?
           - Any timeline or budget constraints?

        5. WRAP-UP (5 min)
           - What haven't I asked that I should?
           - Who else should I talk to?
           - Can I follow up if I have questions?
        ```
      }
    }

    ObservationAndShadowing {
      Purpose: Watch users perform tasks in their environment

      Protocol {
        ```
        Observation Protocol:

        PREPARE:
        - Define what you're observing
        - Get permission to observe
        - Prepare note-taking template

        OBSERVE:
        - Note actions, not interpretations
        - Record workarounds and pain points
        - Note environmental factors
        - Time key activities

        DEBRIEF:
        - "I noticed you did X, can you tell me more?"
        - "What would make that easier?"
        - "How often does this happen?"

        Document:
        +-------------------------------------------------------------+
        | Observation: Order Processing                               |
        +-------------------------------------------------------------+
        | Action: Copied customer email from order to support tool    |
        | Time: 15 seconds per order                                  |
        | Frequency: ~50 orders/day                                   |
        | Pain Point: Manual copy-paste, error-prone                  |
        | Opportunity: Direct integration between systems             |
        +-------------------------------------------------------------+
        ```
      }
    }
  }

  RequirementDocumentation {
    UserStoryFormat {
      Format {
        ```
        Format:
        As a [role],
        I want [capability],
        So that [benefit].

        Components:
        - Role: Who benefits (be specific)
        - Capability: What they can do (action, not solution)
        - Benefit: Why it matters (business value)

        Example:
        As a customer service representative,
        I want to see a customer's order history when they call,
        So that I can resolve their issues without asking them to repeat information.
        ```
      }
    }

    AcceptanceCriteria_GivenWhenThen {
      Format {
        ```
        Format:
        Given [context/precondition]
        When [action/event]
        Then [expected outcome]

        Example:
        Feature: Order Cancellation

        Scenario: Cancel order before shipping
        Given an order in "confirmed" status
        And the order has not been shipped
        When the customer requests cancellation
        Then the order status changes to "cancelled"
        And the customer receives a cancellation confirmation email
        And the payment is refunded within 3-5 business days

        Scenario: Cannot cancel shipped order
        Given an order in "shipped" status
        When the customer requests cancellation
        Then the cancellation is rejected
        And the customer is directed to the returns process
        ```
      }
    }

    EdgeCasesAndExceptions {
      Purpose: Document what happens when things go wrong

      Example {
        ```
        Feature: Password Reset

        Happy Path:
        - User requests reset -> Email sent -> User clicks link -> Sets new password

        Edge Cases:
        | Scenario | Expected Behavior |
        |----------|-------------------|
        | Email not found | Show same success message (security) |
        | Link expired (>24h) | Show "link expired" with new reset option |
        | Link already used | Show "link already used" message |
        | Weak password | Show requirements, block submission |
        | Same as old password | Show error, require different password |
        | User locked out | Still send reset email (unlock flow) |
        ```
      }
    }

    NonFunctionalRequirements {
      Template {
        ```
        NFR Template:
        +-------------------------------------------------------------+
        | Category: Performance                                        |
        +-------------------------------------------------------------+
        | Requirement: Response Time                                   |
        | Measure: 95th percentile page load time                     |
        | Target: < 2 seconds                                          |
        | Context: Desktop browser, 4G connection                     |
        | Priority: Must Have                                          |
        +-------------------------------------------------------------+

        Common Categories:
        - Performance: Speed, throughput, latency
        - Scalability: Users, data volume, geographic distribution
        - Availability: Uptime, recovery time, disaster recovery
        - Security: Authentication, authorization, encryption
        - Usability: Accessibility, learnability, efficiency
        - Maintainability: Modularity, testability, documentation
        ```
      }
    }
  }

  StakeholderManagement {
    StakeholderAnalysis {
      Purpose: Identify and categorize stakeholders

      Map {
        ```
        Stakeholder Map:

                     High Influence
                           |
            +--------------+--------------+
            |   Manage     |    Partner   |
            |   Closely    |    With      |
            |              |              |
        Low +--------------+--------------+ High
        Interest          |              Interest
            |   Monitor    |    Keep      |
            |   Only       |    Informed  |
            |              |              |
            +--------------+--------------+
                           |
                     Low Influence

        Stakeholder Register:
        | Name | Role | Interest | Influence | Communication |
        |------|------|----------|-----------|---------------|
        | VP Sales | Sponsor | High | High | Weekly update |
        | Dev Team | Implementer | High | Medium | Daily standup |
        | Legal | Advisor | Low | High | As needed |
        ```
      }
    }

    RACIMatrix {
      Purpose: Define roles for each requirement

      Format {
        ```
        R = Responsible (does the work)
        A = Accountable (final decision maker)
        C = Consulted (provides input)
        I = Informed (kept updated)

        | Requirement | Product | Dev | Design | Legal |
        |-------------|---------|-----|--------|-------|
        | User stories | R,A | C | C | I |
        | UI mockups | C | I | R,A | I |
        | API contracts | C | R,A | I | I |
        | Privacy policy | C | I | I | R,A |
        ```
      }
    }

    ConflictResolution {
      Purpose: When stakeholders disagree

      Process {
        ```
        Resolution Process:

        1. UNDERSTAND both positions
           - "Help me understand why X is important to you"
           - Identify underlying needs vs stated positions

        2. FIND COMMON GROUND
           - What do both parties agree on?
           - What's the shared goal?

        3. EXPLORE OPTIONS
           - Can we do both? (phased approach)
           - Is there a third option that addresses both needs?
           - What's the minimum viable for each?

        4. ESCALATE if needed
           - Present options with trade-offs
           - Let decision-maker decide
           - Document the decision and rationale

        Example:
        Marketing wants: Launch by Q1 with all features
        Engineering says: Can't do all features by Q1

        Resolution: Launch Q1 with core features (MVP), Phase 2 in Q2
        Documented: ADR-2024-03: MVP Scope Decision
        ```
      }
    }
  }

  ValidationTechniques {
    RequirementsReviewChecklist {
      | Criterion | Question | Pass/Fail |
      |-----------|----------|-----------|
      | Complete | Is everything needed documented? | |
      | Consistent | Are there contradictions? | |
      | Correct | Does it match stakeholder intent? | |
      | Unambiguous | Is there only one interpretation? | |
      | Testable | Can we verify it's met? | |
      | Traceable | Can we link to business goal? | |
      | Feasible | Can it be implemented? | |
      | Prioritized | Is importance clear? | |
    }

    PrototypeValidation {
      Purpose: Use prototypes to validate understanding

      Levels {
        ```
        Prototype Levels:

        Low Fidelity (Paper/Whiteboard):
        - Quick to create (minutes)
        - Good for: Overall flow, major screens
        - Validate: "Is this the right approach?"

        Medium Fidelity (Clickable mockups):
        - Moderate effort (hours)
        - Good for: Detailed interactions, UI layout
        - Validate: "Does this workflow make sense?"

        High Fidelity (Functional prototype):
        - Significant effort (days)
        - Good for: Complex interactions, performance
        - Validate: "Will this actually work?"
        ```
      }
    }

    AcceptanceCriteriaReview {
      Purpose: Validate with stakeholders before implementation

      Format {
        ```
        Review Format:

        "Here's my understanding of [feature]. Please correct me if I'm wrong."

        [Read each scenario aloud]

        Questions:
        - "Is this what you expected?"
        - "What did I miss?"
        - "What edge cases should we handle?"
        - "Is the priority right?"

        Document changes and get sign-off.
        ```
      }
    }
  }

  Traceability {
    TraceabilityMatrix {
      Purpose: Link requirements to their sources and verification

      Format {
        ```
        | Req ID | Description | Source | Priority | Status | Test Cases |
        |--------|-------------|--------|----------|--------|------------|
        | REQ-001 | User login | Stakeholder interview | Must | Approved | TC-001, TC-002 |
        | REQ-002 | Order history | User observation | Should | Draft | TC-015 |
        | REQ-003 | Export CSV | Sales team request | Could | Approved | TC-020 |
        ```
      }
    }

    RequirementStates {
      Purpose: Track requirement lifecycle

      Diagram {
        ```
        States:
        +---------+     +----------+     +----------+     +------------+
        | Draft   |---->| Reviewed |---->| Approved |---->| Implemented|
        +---------+     +----------+     +----------+     +------------+
                             |                                   |
                             v                                   v
                        +----------+                      +----------+
                        | Rejected |                      | Verified |
                        +----------+                      +----------+
        ```
      }
    }
  }

  AntiPatterns {
    | Anti-Pattern | Problem | Solution |
    |--------------|---------|----------|
    | **Solution First** | "We need a dashboard" | Ask "Why?" to find the real need |
    | **Assumed Obvious** | Undocumented "common sense" | Document everything explicitly |
    | **Gold Plating** | Adding unrequested features | Stick to documented requirements |
    | **Moving Baseline** | Requirements keep changing | Change control process |
    | **Single Stakeholder** | Missing perspectives | Identify all stakeholders |
    | **Technical Jargon** | Users don't understand | Use domain language |
  }

  Templates {
    FeatureRequestTemplate {
      ```markdown
      # Feature: [Name]

      ## Problem Statement
      [What problem does this solve?]

      ## User Stories
      - As a [role], I want [what] so that [why]

      ## Acceptance Criteria
      - Given [context] when [action] then [outcome]

      ## Out of Scope
      - [What this feature does NOT include]

      ## Dependencies
      - [Other features or systems required]

      ## Open Questions
      - [Unresolved issues needing discussion]
      ```
    }

    RequirementsDocumentTemplate {
      ```markdown
      # [Project Name] Requirements Specification

      ## 1. Introduction
      ### 1.1 Purpose
      ### 1.2 Scope
      ### 1.3 Definitions

      ## 2. Overall Description
      ### 2.1 Product Perspective
      ### 2.2 User Classes
      ### 2.3 Constraints

      ## 3. Functional Requirements
      ### 3.1 [Feature Area 1]
      ### 3.2 [Feature Area 2]

      ## 4. Non-Functional Requirements
      ### 4.1 Performance
      ### 4.2 Security
      ### 4.3 Usability

      ## 5. Appendices
      ### A. Stakeholder Register
      ### B. Traceability Matrix
      ```
    }
  }

  References {
    - [Interview Question Bank](examples/interview-questions.md) - Questions by domain
    - [User Story Examples](examples/user-stories.md) - Well-written story examples
  }
}
