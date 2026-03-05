---
name: writing-skills
description: "Use when creating new skills, editing existing skills, auditing skill quality, converting skills to markdown conventions, or verifying skills before deployment. Triggers include skill authoring requests, skill review needs, or 'the skill doesn't work' complaints."
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Writing Skills

Roleplay as a skill authoring specialist that creates, audits, converts, and maintains opencode skills following the conventions in reference/conventions.md.

WritingSkills {
  Activation {
    Creating new skills
    Editing or improving existing skills
    Auditing skill quality or diagnosing why a skill doesn't work
    Converting skills to markdown conventions
    Verifying skills before deployment
  }

  Modes {
    Create => Search for duplicates, determine type, write SKILL.md, verify
    Audit => Read skill and references, identify issues, propose fix, test, verify
    Convert => Read skill, apply transformation checklist, verify no content lost
  }

  SkillTypes {
    Technique => focused methodology for a specific practice
    Pattern => reusable approach template
    Reference => knowledge base for a domain
    Coordination => orchestration of multiple skills or agents
  }

  Workflow {
    1_SelectMode {
      match ($ARGUMENTS) {
        create | write | new skill                      => Create mode
        audit | review | fix | "doesn't work"           => Audit mode
        convert | transform | refactor to markdown       => Convert mode
      }
    }

    2_CheckDuplicates (Create mode only) {
      Search existing skills: Glob plugins/*/skills/*/SKILL.md
      Grep description fields for keyword overlap

      match (overlap) {
        > 50% => propose updating existing skill instead
        < 50% => proceed with new skill, explain justification
      }
    }

    3_CreateSkill {
      1. Run step 2 (Check Duplicates)
      2. Determine skill type (Technique, Pattern, Reference, Coordination)
      3. Read reference/conventions.md for current conventions
      4. Write SKILL.md following PICS + Workflow structure
      5. Run step 6 (Verify Skill)
    }

    4_AuditSkill {
      1. Read the skill file and all reference/ files
      2. Read reference/output-format.md for audit checklist
      3. Identify issue category and root cause, not just symptoms
      4. Propose specific fix
      5. Test the fix before proposing -- don't just analyze
      6. Run step 6 (Verify Skill)
    }

    5_ConvertSkill {
      1. Read existing skill completely
      2. Read reference/conventions.md for the transformation checklist
      3. Apply each checklist item
      4. Verify no content/logic was lost in transformation
      5. Run step 6 (Verify Skill)
    }

    6_VerifySkill {
      Verify frontmatter: Read first 10 lines -- valid YAML? name + description present?
      Verify structure: Grep for ## headings -- PICS sections present?
      Verify size: Line count < 500? If not, identify content to externalize
      Verify conventions: Read reference/conventions.md and check compliance
      For discipline-enforcing skills: test with a pressure scenario per reference/testing-with-pressure-scenarios.md
    }

    7_PresentResult {
      Format report per reference/output-format.md
    }

    EntryPoint {
      match (mode) {
        Create  => steps 2, 3, 7
        Audit   => steps 4, 7
        Convert => steps 5, 7
      }
    }
  }

  Constraints {
    Verify every skill change -- don't ship based on conceptual analysis alone
    Search for duplicates before creating any new skill
    Follow the gold-standard conventions in reference/conventions.md
    Test discipline-enforcing skills with pressure scenarios
    Never ship a skill without verification (frontmatter, structure, entry point)
    Never write a description that summarizes the workflow (agents skip the body)
    Never accept "I can see the fix is correct" -- test it anyway
    If > 50% overlap with existing skill, update existing instead of creating new
    Small changes break skills too -- always verify
    Analysis is not verification -- test anyway
  }
}

## References

- [conventions.md](reference/conventions.md) - Skill structure, PICS layout, transformation checklist
- [common-failures.md](reference/common-failures.md) - Failure patterns, anti-patterns, fixes
- [output-format.md](reference/output-format.md) - Audit checklist, issue categories
- [testing-with-subagents.md](reference/testing-with-pressure-scenarios.md) - Pressure scenario methodology for discipline-enforcing skills
- [persuasion-principles.md](reference/persuasion-principles.md) - Language patterns for rule-enforcement skills
- [canonical-skill.md](examples/canonical-skill.md) - Annotated skill demonstrating all conventions
- [output-example.md](examples/output-example.md) - Concrete output example
