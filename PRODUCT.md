# Product

## Register

product

## Users

Two distinct audiences share one app:

- **Small Indian business owners** — shopkeepers, retailers, salon owners, tutors, freelancers, and consultants. Often not accountants by training. They use the app on Android phones, in short bursts between serving customers, frequently offline or on patchy networks, in English, Hindi, or Marathi. Their job: keep accurate books with as little manual effort as possible, know their net profit at a glance, and stay GST-compliant without thinking about it.
- **Chartered Accountants (CAs)** — professionals who audit client books remotely. Strictly read-only access. Their job: review entries, flag questionable transactions, and export compliant reports. Lower volume, higher scrutiny.

The owner is the primary user; every default optimizes for their speed and confidence.

## Product Purpose

PocketPlus turns bookkeeping from a chore into a background process. SMS auto-capture, voice logging, and receipt OCR remove manual entry; AI categorization and real-time net-profit math remove the spreadsheet. CAs connect over secure, read-only live sharing so audits happen without file exchange. The app stays fully functional offline via Firestore cache, and protects 7-year financial records with biometric locks, soft deletes, and DPDP-compliant data controls.

Success looks like: a shopkeeper who logs nothing manually yet always knows their month's profit, and a CA who audits without ever asking for a file.

## Brand Personality

**Quietly premium.** Understated, polished, modern-Indian. The app should look more considered and more expensive than the free apps it competes with, and earn trust through craft rather than noise.

- **Voice**: plain, confident, respectful. Speaks to a busy owner as a capable peer, never talks down, never uses accounting jargon unprompted.
- **Tone**: calm and reassuring around money; money UI is precise and never flashy.
- **Three words**: refined, effortless, credible.
- **Emotional goal**: the user feels their finances are in safe, competent hands — and feels a little more like a sharp business operator for using it.

## Anti-references

- **Toy-like or childish** (primary): no oversized cartoon-rounded cards, mascots, candy colors, confetti, or playful illustration that undercuts financial credibility. This is real money; the interface must feel earned.
- **Loud consumer payments apps** (Paytm / PhonePe energy): no busy promo gradients, banner spam, rewards chaos, or neon. Restraint is the brand.
- **Cluttered legacy fintech** (Tally / desktop-accounting density): no jargon-heavy, gray enterprise tables that intimidate non-experts.
- **Generic AI SaaS dashboard**: no cream-background + gradient-accent + identical-card-grid cliche, no hero-metric template.

## Design Principles

1. **Money is sacred — show it with precision.** Amounts are always exact (paise-accurate), green/red coded consistently, and never decorated. The net-profit figure is the most important pixel on any screen; everything else defers to it.
2. **Effort is the enemy.** The best entry is the one the user never made. Favor automation, sensible defaults, and one-tap confirmation over forms. Surface AI suggestions, but never auto-commit a low-confidence guess.
3. **Earn trust through restraint.** Premium reads as calm, spacious, and consistent — not as ornament. When in doubt, remove rather than add.
4. **Offline is the normal case, not the error.** Never blame the network. Reads serve from cache, writes queue silently; the UI behaves as if always-on.
5. **Respect the whole of India.** Indic scripts, large font scales, screen readers, and small/old Android devices are first-class, not afterthoughts.

## Accessibility & Inclusion

- **Standard**: WCAG AA. Body text ≥4.5:1, large text ≥3:1. Existing tokens verified: primary `#0D3A35` and error `#B71C1C` clear AA on white.
- **Touch targets**: minimum 48×48dp on all interactive elements.
- **Text scaling**: support up to 200% system font scale; never hard-code pixel sizes outside the type scale.
- **Internationalization**: Noto Sans for body/labels to guarantee Hindi and Marathi (Devanagari) coverage; test with real Indic input.
- **Screen readers**: TalkBack support on all custom widgets; charts carry textual alternatives; form errors use live regions so they're announced.
- **Reduced motion**: honor the system setting — disable chart animations and transitions when `MediaQuery.disableAnimations` is true.
- **Color independence**: never encode income/expense by color alone; pair with sign, icon, or label.
