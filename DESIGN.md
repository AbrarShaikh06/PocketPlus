---
name: PocketPlus
description: Income Grow — quiet bookkeeping for Indian small businesses
colors:
  primary: "#0D3A35"
  primary-light: "#E2EBEA"
  primary-dark: "#062320"
  neutral-surface: "#FBF6F0"
  neutral-card: "#FFFFFF"
  neutral-ink: "#1B1C1C"
  neutral-muted: "#5A6657"
  neutral-outline: "#B1B7AB"
  error: "#B71C1C"
  error-light: "#FFEBEE"
  semantic-income: "#0D3A35"
  semantic-expense: "#B71C1C"
  semantic-warning: "#E65100"
  source-blue: "#1565C0"
  source-purple: "#7B1FA2"
  source-teal: "#00897B"
  source-indigo: "#3949AB"
  source-green: "#4CAF50"
typography:
  display:
    fontFamily: "Plus Jakarta Sans, sans-serif"
    fontSize: "40px"
    fontWeight: 800
    lineHeight: 1.1
  headline:
    fontFamily: "Plus Jakarta Sans, sans-serif"
    fontSize: "32px"
    fontWeight: 700
    lineHeight: 1.2
  title-large:
    fontFamily: "Plus Jakarta Sans, sans-serif"
    fontSize: "22px"
    fontWeight: 700
    lineHeight: 1.3
  title-medium:
    fontFamily: "Plus Jakarta Sans, sans-serif"
    fontSize: "16px"
    fontWeight: 600
    lineHeight: 1.3
  body:
    fontFamily: "Noto Sans, sans-serif"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "Noto Sans, sans-serif"
    fontSize: "12px"
    fontWeight: 600
    lineHeight: 1.3
    letterSpacing: "0.01em"
rounded:
  sm: "4px"
  md: "8px"
  lg: "12px"
  xl: "16px"
  full: "9999px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "16px"
  lg: "24px"
  xl: "32px"
  xxl: "48px"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.neutral-card}"
    rounded: "{rounded.lg}"
    padding: "16px 24px"
    typography: "{typography.label}"
  button-primary-hover:
    backgroundColor: "{colors.primary-dark}"
    textColor: "{colors.neutral-card}"
    rounded: "{rounded.lg}"
    padding: "16px 24px"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.primary}"
    rounded: "{rounded.lg}"
    padding: "16px 24px"
  card:
    backgroundColor: "{colors.neutral-card}"
    rounded: "{rounded.lg}"
    padding: "{spacing.md}"
  input:
    backgroundColor: "{colors.neutral-card}"
    rounded: "{rounded.md}"
    padding: "{spacing.sm} {spacing.md}"
  input-focus:
    backgroundColor: "{colors.neutral-card}"
    rounded: "{rounded.md}"
    padding: "{spacing.sm} {spacing.md}"
  chip-filter:
    backgroundColor: "{colors.primary-light}"
    textColor: "{colors.primary}"
    rounded: "{rounded.full}"
  chip-filter-selected:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.neutral-card}"
    rounded: "{rounded.full}"
---

# Design System: PocketPlus

## 1. Overview

**Creative North Star: "The Ledger"**

PocketPlus is a quietly premium bookkeeping tool for Indian small business owners. The ledger is the central metaphor — every screen is a page in a master book: calm, exact, never decorative. The interface earns trust through precision and restraint, not ornament.

This system rejects the cluttered energy of consumer payments apps and the cold density of legacy accounting software. It feels more like a well-bound notebook than a dashboard — spacious, considered, and authoritative. Money is shown as fact, not decoration.

**Key Characteristics:**
- Refined and restrained — components use gentle 12px corners, minimal borders, and forgiving whitespace
- Tonal depth is carried by surface shifts, not drop shadows — cards sit on a warm off-white field, not floating
- Money is precise and never decorated — income in Deep Verdigris, expense in red, always paise-accurate
- Typography distinguishes display (Plus Jakarta Sans, for headings) from body (Noto Sans, for Indic-script safety)
- The palette is restrained — one dark accent (Deep Verdigris) carries the brand; surfaces stay near-white and near-black

## 2. Colors

The palette is restrained: a single dark teal-green accent against warm paper and cool near-black ink.

### Primary
- **Deep Verdigris** (`#0D3A35`): The brand's sole accent. Used for primary buttons, selected states, income figures, and navigation markers. Never decorative. Usage targets ≤10% of any screen.
- **Deep Verdigris Light** (`#E2EBEA`): Tinted background for selected filter chips and subtle active states.
- **Deep Verdigris Dark** (`#062320`): Hover state for primary buttons and interactive elements.

### Neutral
- **Warm Paper** (`#FBF6F0`): The default body background. A barely-tinted off-white that reads as warm paper, not tinted cream.
- **White** (`#FFFFFF`): Card surfaces, modals, and elevated panels.
- **Near-Black Ink** (`#1B1C1C`): Body text and high-emphasis content. 16.1:1 against cards — full AAA.
- **Muted Ink** (`#5A6657`): Secondary text, labels, captions. 6.0:1 against cards — AA.
- **Warm Gray Outline** (`#B1B7AB`): Borders, dividers, and disabled state edges.

### Semantic
- **Income** — Deep Verdigris. Paired with a + sign or arrow so it's never color-dependent.
- **Expense** — Vermillion Red (`#B71C1C`). Paired with a − sign or arrow.
- **Warning** — Burnt Orange (`#E65100`). Medium-confidence AI predictions and approaching limits.

### Source Accents (transaction tagging)
A muted palette of blue, purple, teal, indigo, and green for source badges and categorization chips. Used at low saturation to avoid competing with primary content.

### Named Rules
**The One Voice Rule.** Deep Verdigris is the sole primary accent. Secondary is identical to primary by design — there is no second brand color. Variety comes from neutral surface shifts, not from introducing competing hues.

## 3. Typography

**Display Font:** Plus Jakarta Sans (800 weight, geometric character)
**Body Font:** Noto Sans (humanist, Devanagari-safe)
**Label/Mono Font:** Courier New (code/receipt references only)

**Character:** A deliberate pairing of two personalities. Plus Jakarta Sans is sharp and contemporary — used sparingly for titles where the brand needs presence. Noto Sans is the workhorse — disciplined, legible across English, Hindi, and Marathi, and never decorative.

### Hierarchy
- **Display** (800, 40px, 1.1): Hero screens and the net-profit card. Appears once per page.
- **Headline** (700, 32px, 1.2): Section titles and modal headers.
- **Title Large** (700, 22px, 1.3): Card titles, screen headings.
- **Title Medium** (600, 16px, 1.3): Subsection headers, list item titles.
- **Body Large** (400, 16px, 1.5): Long-form content, empty states.
- **Body** (400, 14px, 1.5): Data rows, descriptions, paragraph text. Cap at 75ch for prose.
- **Label** (600, 12px, 1.3, 0.01em): Button text, chip labels, captions.
- **Label Small** (600, 11px, 1.3, 0.01em): Tab counters, metadata.

### Named Rules
**The Noto Sans Rule.** Every text widget that could render Devanagari script (Hindi, Marathi) must use Noto Sans. Plus Jakarta Sans is display-only and never used for body copy or labels.

## 4. Elevation

**Tonal layering, no shadows.** Depth is conveyed by surface color, not drop shadows. Cards sit at `#FFFFFF` on a `#FBF6F0` field; modals and dialogs sit at `#FFFFFF` with a subtle semi-transparent overlay backdrop. No blur, no box-shadow.

This is a deliberate departure from Material 3 defaults. The system reads as flat, calm, and premium — like pages on a desk rather than floating windows in a glass pane.

## 5. Components

### Buttons
- **Shape:** Gently rounded (12px radius).
- **Primary:** Deep Verdigris background, White text, 16px vertical / 24px horizontal padding. Transitions to Deep Verdigris Dark on hover.
- **Ghost:** Transparent, Deep Verdigris text, same padding and radius.
- **Danger:** Vermillion background, White text. Same shape as primary.

### Chips / Filters
- **Shape:** Full-pill radius (9999px).
- **Unselected:** Deep Verdigris Light background, Deep Verdigris text.
- **Selected:** Deep Verdigris background, White text.
- **Transition:** 0.15s background-color ease.

### Cards / Containers
- **Corner Style:** Gentle curve (12px radius).
- **Background:** White (`#FFFFFF`).
- **Shadow Strategy:** None. Cards are distinguished from the body background by color, not shadow.
- **Border:** 1px Warm Gray Outline (`#B1B7AB`) on interactive cards only.
- **Internal Padding:** 16px (scale `md`).

### Inputs / Fields
- **Style:** 1px Warm Gray Outline stroke, White background, 8px radius.
- **Focus:** Border shifts to Deep Verdigris. No glow.
- **Error:** Border shifts to Vermillion. Supporting text appears below in Vermillion at Label size.
- **Disabled:** Background fades to Warm Paper, text to Muted Ink.

### Navigation (Bottom Tab Bar)
- **Style:** Icons + labels, standard Material 3 bottom nav pattern.
- **Selected:** Deep Verdigris icon + label.
- **Unselected:** Muted Ink icon + label.
- No badge dots, no animated indicators. Restraint is the brand.

## 6. Do's and Don'ts

### Do:
- **Do** use exact paise values for money — never rounded rupees or doubles.
- **Do** pair income with a + sign and expense with a − sign so meaning is not color-dependent.
- **Do** keep the primary accent to ≤10% of any screen.
- **Do** use Deep Verdigris Dark for button hover states to give tactile feedback.
- **Do** use tonal layering (card white on surface warm paper) rather than shadows.
- **Do** use Noto Sans for any text that may render Devanagari.
- **Do** keep the net-profit figure as the most prominent number on any dashboard screen.

### Don't:
- **Don't** use gradient text, glassmorphism, or decorative blur.
- **Don't** use the hero-metric template (big number, small label, supporting stats, gradient accent). Money is shown as fact, not theater.
- **Don't** use side-stripe borders (border-left/right greater than 1px as colored accent).
- **Don't** invent card grids of identical icon + heading + text patterns.
- **Don't** use display fonts (Plus Jakarta Sans) for body copy, labels, or buttons.
- **Don't** hard-delete financial data — soft delete only with deletedAt timestamp.
- **Don't** show "No internet" errors for Firestore reads; serve from cache silently.
- **Don't** auto-confirm AI categorization when geminiConfidence < 0.60.
- **Don't** use Paytm/PhonePe energy — no busy promo gradients, banner spam, or neon.
- **Don't** use Tally density — no jargon-heavy gray enterprise tables.
- **Don't** use cartoon mascots, oversized rounded cards, or confetti.
