#!/usr/bin/env python3
"""
The Agentic Engineer - Spec Generation Script
Creates numbered spec directories with auto-incrementing IDs

Location: plugins/start/skills/specify-meta/spec.py
Template resolution: skills/[template-name]/template.md
"""

import argparse
import re
import sys
from pathlib import Path
from typing import Optional


# Get plugin root from script location
# This script is at: plugins/start/skills/specify-meta/spec.py
# Plugin root is: plugins/start/
script_dir = Path(__file__).resolve().parent
plugin_root = script_dir.parent.parent

# Specs are created in the current working directory
SPECS_DIR = Path(".engineer/specs")
# Skills directory for template lookup
SKILLS_DIR = plugin_root / "skills"


def get_template_path(template_name: str) -> Path:
    """Resolve template path from skill directory."""
    template = SKILLS_DIR / template_name / "template.md"
    if template.exists():
        return template
    raise FileNotFoundError(f"Template not found: {template_name}")


def get_next_spec_id() -> str:
    """Get next available spec ID by scanning existing directories."""
    max_id = 0
    if SPECS_DIR.exists():
        for dir_path in SPECS_DIR.iterdir():
            if dir_path.is_dir():
                match = re.match(r'^(\d{3})-', dir_path.name)
                if match:
                    num = int(match.group(1))
                    if num > max_id:
                        max_id = num
    return f"{max_id + 1:03d}"


def sanitize_name(name: str) -> str:
    """Convert feature name to URL-friendly directory name."""
    name = name.lower()
    name = re.sub(r'[^a-z0-9]+', '-', name)
    name = name.strip('-')
    return name


def find_spec_dir(spec_id: str) -> Optional[Path]:
    """Find a spec directory by ID in .engineer/specs/."""
    if SPECS_DIR.exists():
        for dir_path in SPECS_DIR.iterdir():
            if dir_path.is_dir() and dir_path.name.startswith(f"{spec_id}-"):
                return dir_path
    return None


def read_spec(spec_id: str) -> None:
    """Read spec metadata and output TOML format."""
    spec_dir = find_spec_dir(spec_id)

    if not spec_dir:
        print(f"Error: Spec {spec_id} not found", file=sys.stderr)
        sys.exit(1)

    # Extract name from directory
    name = spec_dir.name[len(spec_id) + 1:]  # Remove "001-" prefix

    # Generate TOML output
    print(f'id = "{spec_id}"')
    print(f'name = "{name}"')
    print(f'dir = "{spec_dir}"')

    # List spec documents
    print()
    print("[spec]")

    prd_path = spec_dir / "requirements.md"
    if prd_path.exists():
        print(f'prd = "{prd_path}"')

    sdd_path = spec_dir / "solution.md"
    if sdd_path.exists():
        print(f'sdd = "{sdd_path}"')

    # Plan: check for plan/ directory
    plan_dir = spec_dir / "plan"
    if plan_dir.is_dir():
        print(f'plan_dir = "{plan_dir}"')
        plan_readme = plan_dir / "README.md"
        if plan_readme.exists():
            print(f'plan = "{plan_readme}"')
        # List phase files
        phase_files = sorted(plan_dir.glob("phase-*.md"))
        if phase_files:
            phases_str = ", ".join(f'"{f}"' for f in phase_files)
            print(f"phases = [{phases_str}]")

    # List quality gates if they exist
    gate_files = [
        ("definition-of-ready.md", "definition_of_ready"),
        ("definition-of-done.md", "definition_of_done"),
        ("task-definition-of-done.md", "task_definition_of_done"),
    ]

    gate_exists = any((spec_dir / file).exists() for file, _ in gate_files)
    if gate_exists:
        print()
        print("[gates]")
        for file, key in gate_files:
            if (spec_dir / file).exists():
                print(f'{key} = "{spec_dir / file}"')

    # List all files (including plan/ directory contents)
    print()
    print("files = [")
    files = sorted([f.name for f in spec_dir.iterdir() if f.is_file()])
    if (spec_dir / "plan").is_dir():
        plan_files = sorted([f"plan/{f.name}" for f in (spec_dir / "plan").iterdir() if f.is_file()])
        files.extend(plan_files)
    for i, file in enumerate(files):
        comma = "," if i < len(files) - 1 else ""
        print(f'  "{file}"{comma}')
    print("]")


def create_plan_directory(spec_dir: Path, template_name: str) -> None:
    """Create plan/ directory with README.md from plan template."""
    plan_dir = spec_dir / "plan"
    plan_dir.mkdir(parents=True, exist_ok=True)

    try:
        template_file = get_template_path(template_name)
        dest_file = plan_dir / "README.md"
        dest_file.write_text(template_file.read_text())
        print(f"Generated template: plan/README.md")
    except FileNotFoundError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


def create_spec(feature_name: str, template: Optional[str] = None) -> None:
    """Create a new spec directory with optional template."""
    # Check if feature_name is an existing spec ID (3 digits)
    is_spec_id = re.match(r'^\d{3}$', feature_name)

    if is_spec_id and template:
        # Try to find existing directory with this ID
        spec_dir = find_spec_dir(feature_name)

        if spec_dir:
            print(f"Adding template to existing spec: {spec_dir}")

            if template == "specify-plan":
                create_plan_directory(spec_dir, "specify-plan")
                return

            filename_map = {
                "specify-requirements": "requirements.md",
                "specify-solution": "solution.md",
            }
            dest_name = filename_map.get(template, f"{template}.md")

            try:
                template_file = get_template_path(template)
                dest_file = spec_dir / dest_name
                dest_file.write_text(template_file.read_text())
                print(f"Generated template: {dest_name}")
            except FileNotFoundError as e:
                print(f"Error: {e}", file=sys.stderr)
                sys.exit(1)
            return

        # If we get here, the spec ID was not found
        print(f"Error: Spec {feature_name} not found", file=sys.stderr)
        sys.exit(1)

    # Create new spec directory
    spec_id = get_next_spec_id()
    sanitized_name = sanitize_name(feature_name)
    spec_dir = SPECS_DIR / f"{spec_id}-{sanitized_name}"

    # Create spec directory with plan/ subdirectory
    spec_dir.mkdir(parents=True, exist_ok=True)
    (spec_dir / "plan").mkdir(parents=True, exist_ok=True)

    print(f"Created spec directory: {spec_dir}")
    print(f"Spec ID: {spec_id}")

    # Copy template if requested
    if template:
        if template == "specify-plan":
            create_plan_directory(spec_dir, "specify-plan")
        else:
            filename_map = {
                "specify-requirements": "requirements.md",
                "specify-solution": "solution.md",
            }
            dest_name = filename_map.get(template, f"{template}.md")

            try:
                template_file = get_template_path(template)
                dest_file = spec_dir / dest_name
                dest_file.write_text(template_file.read_text())
                print(f"Generated template: {dest_name}")
            except FileNotFoundError as e:
                print(f"Warning: {e}", file=sys.stderr)

    print("Specification directory created successfully")


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="The Agentic Engineer - Spec Generation Script"
    )
    parser.add_argument(
        "feature_name",
        help="Feature name or spec ID (for --read mode)"
    )
    parser.add_argument(
        "--add",
        metavar="TEMPLATE",
        help="Add template file to spec directory"
    )
    parser.add_argument(
        "--read",
        action="store_true",
        help="Read spec metadata and output TOML"
    )

    args = parser.parse_args()

    # Handle read mode
    if args.read:
        read_spec(args.feature_name)
    else:
        # Handle spec creation
        create_spec(args.feature_name, args.add)


if __name__ == "__main__":
    main()
