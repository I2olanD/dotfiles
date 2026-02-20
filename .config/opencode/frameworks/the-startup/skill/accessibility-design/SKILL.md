---
name: accessibility-design
description: WCAG 2.1 AA compliance patterns, screen reader compatibility, keyboard navigation, and ARIA best practices. Use when implementing accessible interfaces, reviewing UI components, or auditing accessibility compliance. Covers semantic HTML, focus management, color contrast, and assistive technology testing.
license: MIT
compatibility: opencode
metadata:
  category: design
  version: "1.0"
---

# Accessibility Standards

## Overview

This skill provides comprehensive guidance for implementing WCAG 2.1 AA compliance across digital products. It establishes patterns for semantic markup, assistive technology compatibility, and inclusive interaction design.

```sudolang
AccessibilityDesign {
  See: skill/shared/interfaces.sudo.md
  
  State {
    complianceLevel: "AA" | "AAA"
    currentAudit: AuditResult?
    violations: Violation[]
  }
  
  constraints {
    WCAG 2.1 AA is the minimum compliance target
    Semantic HTML must be used before ARIA
    All interactive elements must be keyboard accessible
    Color must never be the sole means of conveying information
    Focus indicators must meet 3:1 contrast ratio
  }
}
```

## Core Principles

### 1. POUR Framework

All accessibility work follows the four POUR principles:

```sudolang
POURFramework {
  Perceivable {
    description: "Information must be presentable in ways users can perceive"
    require {
      Text alternatives exist for all non-text content
      Content is adaptable to different presentations
      Content is distinguishable (color, contrast, audio control)
    }
  }
  
  Operable {
    description: "Interface components must be operable by all users"
    require {
      All functionality is keyboard accessible
      Sufficient time is provided to read and use content
      Content does not cause seizures or physical reactions
      Users can navigate, find content, and determine location
    }
  }
  
  Understandable {
    description: "Information and operation must be understandable"
    require {
      Text is readable and understandable
      Pages appear and operate predictably
      Users can avoid and correct mistakes
    }
  }
  
  Robust {
    description: "Content must be robust enough for diverse user agents"
    require {
      Compatible with current and future assistive technologies
      Valid, semantic markup is used
      Programmatic access exists for all functionality
    }
  }
}
```

### 2. Semantic HTML First

Semantic HTML is the foundation of accessibility. ARIA should enhance, never replace, proper markup.

**Correct approach:**
```html
<button type="submit">Submit Form</button>
```

**Incorrect approach:**
```html
<div role="button" tabindex="0" onclick="submit()">Submit Form</div>
```

```sudolang
SemanticHTMLRules {
  constraints {
    Use native HTML elements whenever possible
    ARIA only fills gaps for complex widgets not covered by HTML
    Never use ARIA to replace semantic HTML
  }
  
  fn selectElement(purpose: String) {
    match (purpose) {
      case "action" | "button" => "<button>"
      case "navigation" | "link" => "<a href>"
      case "text-input" => "<input type='text'>"
      case "selection" => "<select>"
      case "multiline-input" => "<textarea>"
      case "landmark-nav" => "<nav>"
      case "landmark-main" => "<main>"
      case "landmark-aside" => "<aside>"
      case "landmark-header" => "<header>"
      case "landmark-footer" => "<footer>"
      case "heading" => "<h1> through <h6>"
      default => warn "Consider if a native element exists"
    }
  }
}
```

### 3. Progressive Enhancement

Build accessibility in layers:

```sudolang
ProgressiveEnhancement {
  layers: [
    { level: 1, tech: "Semantic HTML", purpose: "Baseline accessibility" },
    { level: 2, tech: "CSS", purpose: "Enhances presentation without breaking structure" },
    { level: 3, tech: "JavaScript", purpose: "Adds interactivity while maintaining keyboard access" },
    { level: 4, tech: "ARIA", purpose: "Fills gaps for complex widgets not covered by HTML" }
  ]
  
  constraints {
    Each layer must build on previous without breaking accessibility
    Higher layers must not remove functionality from lower layers
    Base layer must remain functional when higher layers fail
  }
}
```

## Implementation Patterns

### Document Structure

Every page requires proper document structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Descriptive Page Title - Site Name</title>
</head>
<body>
  <a href="#main-content" class="skip-link">Skip to main content</a>

  <header role="banner">
    <nav aria-label="Main navigation">
      <!-- Navigation content -->
    </nav>
  </header>

  <main id="main-content" role="main">
    <h1>Page Heading</h1>
    <!-- Page content -->
  </main>

  <footer role="contentinfo">
    <!-- Footer content -->
  </footer>
</body>
</html>
```

```sudolang
DocumentStructure {
  require {
    html element has lang attribute
    Page has descriptive title
    Skip link exists for keyboard users
    Landmarks are properly defined (header, main, footer)
    Single h1 exists per page
  }
  
  warn {
    Multiple nav elements should have unique aria-label
    Main landmark should have id for skip link target
  }
}
```

### Heading Hierarchy

Maintain logical heading order without skipping levels:

```html
<h1>Main Page Title</h1>
  <h2>Section Title</h2>
    <h3>Subsection Title</h3>
    <h3>Another Subsection</h3>
  <h2>Another Section</h2>
    <h3>Subsection</h3>
      <h4>Sub-subsection</h4>
```

```sudolang
HeadingHierarchy {
  constraints {
    Only one h1 per page
    Headings must not skip levels (h1 -> h3 is invalid)
    Heading level must reflect document outline
  }
  
  fn validateHeadingOrder(headings: Heading[]) {
    for (i in 1..headings.length) {
      currentLevel = headings[i].level
      previousLevel = headings[i-1].level
      
      require currentLevel <= previousLevel + 1 
        else error "Heading level skipped: h${previousLevel} -> h${currentLevel}"
    }
  }
}
```

### Skip Links

Provide skip links for keyboard users to bypass repetitive content:

```css
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  padding: 8px 16px;
  background: #000;
  color: #fff;
  z-index: 100;
}

.skip-link:focus {
  top: 0;
}
```

### Focus Management

#### Visible Focus Indicators

Focus indicators must be visible and meet contrast requirements:

```css
:focus {
  outline: 2px solid #005fcc;
  outline-offset: 2px;
}

/* Enhanced focus for better visibility */
:focus-visible {
  outline: 3px solid #005fcc;
  outline-offset: 3px;
  box-shadow: 0 0 0 6px rgba(0, 95, 204, 0.25);
}

/* Never remove focus indicators entirely */
:focus:not(:focus-visible) {
  outline: 2px solid transparent;
  box-shadow: 0 0 0 2px #005fcc;
}
```

```sudolang
FocusManagement {
  constraints {
    Focus indicators must never be removed entirely
    Focus indicator must have 3:1 contrast ratio minimum
    Focus must be visible in all color modes
  }
  
  require {
    All focusable elements have visible focus state
    Focus order matches visual reading order
    Programmatic focus changes are intentional and announced
  }
}
```

#### Focus Trapping for Modals

```javascript
function trapFocus(element) {
  const focusableElements = element.querySelectorAll(
    'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
  );
  const firstFocusable = focusableElements[0];
  const lastFocusable = focusableElements[focusableElements.length - 1];

  element.addEventListener('keydown', (e) => {
    if (e.key !== 'Tab') return;

    if (e.shiftKey) {
      if (document.activeElement === firstFocusable) {
        lastFocusable.focus();
        e.preventDefault();
      }
    } else {
      if (document.activeElement === lastFocusable) {
        firstFocusable.focus();
        e.preventDefault();
      }
    }
  });
}
```

### Keyboard Navigation

#### Standard Keyboard Patterns

```sudolang
KeyboardPatterns {
  fn handleKeyPress(key: String, context: String) {
    match (key, context) {
      case ("Tab", _) => "Move focus to next focusable element"
      case ("Shift+Tab", _) => "Move focus to previous focusable element"
      case ("Enter", "button" | "link") => "Activate element"
      case ("Space", "button") => "Activate button"
      case ("Space", "checkbox") => "Toggle checkbox"
      case ("ArrowUp" | "ArrowDown", "menu" | "listbox") => "Navigate within component"
      case ("ArrowLeft" | "ArrowRight", "tabs" | "radio") => "Navigate within component"
      case ("Escape", "modal" | "menu" | "dropdown") => "Close and return focus"
      case ("Home", "list") => "Move to first item"
      case ("End", "list") => "Move to last item"
      default => "No action"
    }
  }
}
```

#### Tab Order

Ensure logical tab order follows visual order:

```html
<!-- Correct: Tab order matches visual order -->
<form>
  <label for="name">Name</label>
  <input id="name" type="text">

  <label for="email">Email</label>
  <input id="email" type="email">

  <button type="submit">Submit</button>
</form>
```

```sudolang
TabIndex {
  constraints {
    Never use positive tabindex values
    tabindex="0" only to make non-interactive elements focusable
    tabindex="-1" only for programmatic focus targets
    Tab order must match visual reading order
  }
  
  fn validateTabindex(value: Number) {
    match (value) {
      case 0 => "Valid: Element in natural tab order"
      case -1 => "Valid: Programmatically focusable only"
      case n if n > 0 => error "Invalid: Positive tabindex creates unpredictable order"
      default => "Valid: Natural tab order"
    }
  }
}
```

### ARIA Patterns

#### When to Use ARIA

Use ARIA only when native HTML cannot achieve the required accessibility:

```sudolang
ARIAUsage {
  validUseCases: [
    "Custom widgets: tabs, accordions, carousels, tree views",
    "Dynamic content: live regions for updates",
    "Relationships: connecting labels to complex controls",
    "States: expanded/collapsed, selected, pressed"
  ]
  
  constraints {
    Native HTML elements are always preferred over ARIA
    ARIA must not conflict with native semantics
    All ARIA roles must have required states and properties
    Dynamic ARIA attributes must be kept in sync with visual state
  }
  
  fn shouldUseARIA(element: Element, requirement: String) {
    match (requirement) {
      case r if nativeHTMLSufficient(r) => false
      case "custom-widget" => true
      case "dynamic-announcement" => true
      case "relationship-mapping" => true
      case "state-indication" => true
      default => false
    }
  }
}
```

#### ARIA Roles

Common roles for custom widgets:

```html
<!-- Tab pattern -->
<div role="tablist" aria-label="Settings tabs">
  <button role="tab" aria-selected="true" aria-controls="panel1" id="tab1">
    General
  </button>
  <button role="tab" aria-selected="false" aria-controls="panel2" id="tab2">
    Security
  </button>
</div>
<div role="tabpanel" id="panel1" aria-labelledby="tab1">
  <!-- Panel content -->
</div>
<div role="tabpanel" id="panel2" aria-labelledby="tab2" hidden>
  <!-- Panel content -->
</div>
```

#### ARIA States and Properties

```sudolang
ARIAAttributes {
  fn selectAttribute(purpose: String, state: Any) {
    match (purpose) {
      case "expandable" => { attr: "aria-expanded", value: state.expanded }
      case "selection" => { attr: "aria-selected", value: state.selected }
      case "toggle" => { attr: "aria-pressed", value: state.pressed }
      case "hide-from-at" => { attr: "aria-hidden", value: "true" }
      case "live-polite" => { attr: "aria-live", value: "polite" }
      case "live-assertive" => { attr: "aria-live", value: "assertive" }
      case "description" => { attr: "aria-describedby", value: state.descriptionId }
      case "label" => { attr: "aria-labelledby", value: state.labelId }
      default => null
    }
  }
}
```

#### Live Regions

Announce dynamic content changes:

```html
<!-- Polite: Announces when user is idle -->
<div aria-live="polite" aria-atomic="true">
  Form saved successfully
</div>

<!-- Assertive: Interrupts immediately (use sparingly) -->
<div aria-live="assertive" role="alert">
  Error: Please correct the highlighted fields
</div>

<!-- Status messages -->
<div role="status">
  Loading... 50% complete
</div>
```

```sudolang
LiveRegions {
  fn selectPoliteness(messageType: String) {
    match (messageType) {
      case "error" | "critical" => "assertive"
      case "success" | "info" | "status" => "polite"
      case "progress" => "polite"
      default => "polite"
    }
  }
  
  warn {
    Assertive live regions should be used sparingly
    Live regions should not update too frequently
    Status messages should use role="status"
  }
}
```

### Form Accessibility

#### Labels and Instructions

Every form control requires a label:

```html
<!-- Explicit label association -->
<label for="username">Username</label>
<input type="text" id="username" name="username"
       aria-describedby="username-hint">
<span id="username-hint">Must be 3-20 characters</span>

<!-- Grouped controls with fieldset -->
<fieldset>
  <legend>Shipping Address</legend>
  <label for="street">Street</label>
  <input type="text" id="street">
  <!-- More fields -->
</fieldset>
```

```sudolang
FormAccessibility {
  require {
    Every form control has an associated label
    Labels use explicit for/id association
    Related controls are grouped with fieldset/legend
    Instructions appear before the input
  }
  
  warn {
    Placeholder text should not replace labels
    Instructions should be associated via aria-describedby
  }
}
```

#### Error Handling

Provide clear, actionable error messages:

```html
<label for="email">Email</label>
<input type="email" id="email"
       aria-invalid="true"
       aria-describedby="email-error">
<span id="email-error" role="alert">
  Please enter a valid email address (example: user@domain.com)
</span>
```

```sudolang
FormErrorHandling {
  require {
    Error message identifies the field in error
    Error message describes what went wrong
    Error message provides guidance for correction
    Field has aria-invalid="true" when invalid
    Error is announced via live region or role="alert"
  }
  
  fn validateErrorMessage(error: FormError) {
    require error.fieldName != null else "Must identify field"
    require error.description != null else "Must describe problem"
    require error.guidance != null else "Must provide fix guidance"
  }
}
```

#### Required Fields

```html
<label for="name">
  Name <span aria-hidden="true">*</span>
  <span class="sr-only">(required)</span>
</label>
<input type="text" id="name" required aria-required="true">
```

### Images and Media

#### Alternative Text

```sudolang
AlternativeText {
  fn selectAltStrategy(imageType: String, context: ImageContext) {
    match (imageType) {
      case "informative" => {
        alt: describeContent(context),
        role: null
      }
      case "decorative" => {
        alt: "",
        role: "presentation"
      }
      case "functional" => {
        alt: describeAction(context),
        role: null
      }
      case "complex" => {
        alt: briefDescription(context),
        ariaDescribedby: extendedDescriptionId
      }
      default => {
        alt: describeContent(context),
        role: null
      }
    }
  }
  
  constraints {
    Informative images must have meaningful alt text
    Decorative images must have empty alt and role="presentation"
    Complex images need extended description via aria-describedby
    Alt text should not start with "image of" or "picture of"
  }
}
```

Provide meaningful alt text for informative images:

```html
<!-- Informative image -->
<img src="chart.png" alt="Q3 revenue increased 15% compared to Q2">

<!-- Decorative image -->
<img src="divider.png" alt="" role="presentation">

<!-- Complex image with extended description -->
<figure>
  <img src="flowchart.png" alt="User registration process"
       aria-describedby="flowchart-desc">
  <figcaption id="flowchart-desc">
    The registration process begins with email verification,
    followed by profile creation, and ends with account activation.
  </figcaption>
</figure>
```

#### Video and Audio

```html
<video controls>
  <source src="video.mp4" type="video/mp4">
  <track kind="captions" src="captions.vtt" srclang="en" label="English">
  <track kind="descriptions" src="descriptions.vtt" srclang="en"
         label="Audio descriptions">
</video>
```

```sudolang
MediaAccessibility {
  require {
    Video has captions track
    Pre-recorded audio has transcript
    Video controls are keyboard accessible
  }
  
  warn {
    Consider audio descriptions for video
    Auto-play should be avoided
  }
}
```

### Color and Contrast

#### Minimum Contrast Ratios

```sudolang
ContrastRequirements {
  fn getMinimumRatio(contentType: String, level: "AA" | "AAA") {
    match (contentType, level) {
      case ("normal-text", "AA") => 4.5
      case ("normal-text", "AAA") => 7.0
      case ("large-text", "AA") => 3.0
      case ("large-text", "AAA") => 4.5
      case ("ui-component", "AA") => 3.0
      case ("ui-component", "AAA") => 3.0
      case ("graphic", "AA") => 3.0
      case ("graphic", "AAA") => 3.0
      default => 4.5
    }
  }
  
  fn isLargeText(size: Number, weight: String) {
    match (size, weight) {
      case (s, _) if s >= 18 => true
      case (s, "bold") if s >= 14 => true
      default => false
    }
  }
}
```

#### Never Rely on Color Alone

```html
<!-- Bad: Color only indicates error -->
<input style="border-color: red">

<!-- Good: Color plus icon and text -->
<input aria-invalid="true" aria-describedby="error">
<span id="error">
  <svg aria-hidden="true"><!-- Error icon --></svg>
  Invalid email format
</span>
```

```sudolang
ColorUsage {
  constraints {
    Color must never be the sole means of conveying information
    Links must be distinguishable from surrounding text beyond color
    Error states must include icon or text indicator
    Charts must use patterns or labels in addition to color
  }
}
```

### Motion and Animation

#### Respect User Preferences

```css
/* Reduce motion for users who prefer it */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

```sudolang
MotionAccessibility {
  constraints {
    Respect prefers-reduced-motion media query
    Auto-playing content must have pause controls
    Animations over 5 seconds need stop mechanism
    No content flashes more than 3 times per second
  }
  
  require {
    Animation respects prefers-reduced-motion
    Moving content has pause/stop control
  }
  
  warn {
    Avoid auto-playing video or audio
    Consider providing reduced-motion alternatives
  }
}
```

## Testing Methodology

### Automated Testing

Run automated tools to catch common issues:

1. **axe DevTools** - Browser extension for page analysis
2. **WAVE** - Web accessibility evaluation tool
3. **Lighthouse** - Chrome DevTools accessibility audit
4. **pa11y** - Command-line accessibility testing

Automated testing catches approximately 30-40% of issues.

### Manual Testing

#### Keyboard Testing

```sudolang
KeyboardTestingChecklist {
  require {
    All interactive elements reachable via Tab
    Focus indicators visible on all focusable elements
    Tab order matches visual reading order
    All functionality operable without mouse
    Escape closes modals and menus
    No keyboard traps (except intentional modal traps)
  }
  
  procedure: [
    "Disconnect or disable mouse",
    "Navigate entire page using Tab/Shift+Tab",
    "Verify all interactive elements are reachable",
    "Verify focus indicators are visible",
    "Test all keyboard shortcuts",
    "Escape from all modals and menus"
  ]
}
```

#### Screen Reader Testing

```sudolang
ScreenReaderTestMatrix {
  combinations: [
    { platform: "Windows", reader: "NVDA", browsers: ["Firefox", "Chrome"] },
    { platform: "Windows", reader: "JAWS", browsers: ["Chrome", "Edge"] },
    { platform: "macOS", reader: "VoiceOver", browsers: ["Safari"] },
    { platform: "iOS", reader: "VoiceOver", browsers: ["Safari"] },
    { platform: "Android", reader: "TalkBack", browsers: ["Chrome"] }
  ]
  
  require {
    All images have appropriate alt text
    Headings convey page structure
    Links and buttons have descriptive names
    Form fields have labels
    Error messages are announced
    Dynamic content updates are announced
    Tables have proper headers
    Custom widgets announce state changes
  }
}
```

#### Visual Testing

```sudolang
VisualTestingChecklist {
  require {
    Content readable at 200% zoom without horizontal scroll
    Content functional in high contrast mode
    Content understandable with images disabled
    Text readable with browser font size increased
  }
}
```

### WCAG Audit

Perform manual audit against WCAG 2.1 AA success criteria. See `checklists/wcag-checklist.md` for the complete checklist.

## Common Patterns

### Modal Dialog

```html
<div role="dialog" aria-modal="true" aria-labelledby="dialog-title">
  <h2 id="dialog-title">Confirm Action</h2>
  <p>Are you sure you want to proceed?</p>
  <button type="button">Cancel</button>
  <button type="button">Confirm</button>
</div>
```

```sudolang
ModalPattern {
  require {
    Focus moves to dialog when opened
    Focus is trapped within dialog
    Escape key closes dialog
    Focus returns to trigger element on close
    Background content has aria-hidden="true"
  }
}
```

### Accordion

```html
<div class="accordion">
  <h3>
    <button aria-expanded="true" aria-controls="section1">
      Section 1
    </button>
  </h3>
  <div id="section1" role="region" aria-labelledby="section1-heading">
    <!-- Content -->
  </div>
</div>
```

```sudolang
AccordionPattern {
  require {
    Trigger is a button element
    Button has aria-expanded state
    Button has aria-controls pointing to panel
    Panel has role="region" when content is significant
    Only one panel expanded at a time (single-select) OR multiple allowed (multi-select)
  }
}
```

### Navigation Menu

```html
<nav aria-label="Main">
  <ul>
    <li><a href="/" aria-current="page">Home</a></li>
    <li>
      <button aria-expanded="false" aria-haspopup="true">
        Products
      </button>
      <ul>
        <li><a href="/products/a">Product A</a></li>
        <li><a href="/products/b">Product B</a></li>
      </ul>
    </li>
  </ul>
</nav>
```

```sudolang
NavigationPattern {
  require {
    Nav element has aria-label when multiple navs exist
    Current page indicated with aria-current="page"
    Dropdown triggers have aria-expanded
    Dropdown triggers have aria-haspopup="true"
    Submenus accessible via keyboard
  }
}
```

### Data Table

```html
<table>
  <caption>Q3 Sales by Region</caption>
  <thead>
    <tr>
      <th scope="col">Region</th>
      <th scope="col">Units Sold</th>
      <th scope="col">Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">North</th>
      <td>1,234</td>
      <td>$45,678</td>
    </tr>
  </tbody>
</table>
```

```sudolang
DataTablePattern {
  require {
    Table has caption or aria-label
    Column headers have scope="col"
    Row headers have scope="row"
    Complex tables use headers attribute for cell associations
  }
  
  warn {
    Avoid using tables for layout
    Consider responsive alternatives for complex tables
  }
}
```

## Resources

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [Inclusive Components](https://inclusive-components.design/)
- [A11y Project Checklist](https://www.a11yproject.com/checklist/)
