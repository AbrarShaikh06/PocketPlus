# Project Vision: PocketPlus (Income Grow)

PocketPlus is a modern, mobile-first financial management and bookkeeping application tailored for small Indian business owners, shopkeepers, freelancers, and tutors. It simplifies bookkeeping through background automation and artificial intelligence, while providing Chartered Accountants (CAs) with real-time access to audit client books.

---

## 1. Core Objectives
1. **Frictionless Entry:** Reduce manual logging overhead via SMS auto-capture, voice transaction logging, and receipt OCR.
2. **Real-time Insights:** Offer immediate calculations of Net Profit, monthly expense breakdowns, and visual performance charts.
3. **CA Collaboration:** Enable seamless connection between business owners and CAs via secure, read-only live sharing.
4. **Offline Resilience:** Ensure the app remains fully functional offline using Firestore's local cache persistence.
5. **Strict Security & Compliance:** Protect sensitive financial records with biometric locks, soft deletes for GST compliance, and data sovereignty controls (DPDP Act).

---

## 2. Target Audience
- **Business Owners (Free/Basic/Pro):** Small traders, retailers, salons, tutors, and freelance consultants.
- **Chartered Accountants (CA):** Professionals who audit client books, flag questionable entries, and generate export reports.

---

## 3. Product Architecture (Phase 1)
PocketPlus's MVP runs on a serverless, Firebase-native stack:
- **Client App:** Flutter (Android-focused) written with feature-first Clean Architecture.
- **State Management:** Riverpod 3.x with code generation.
- **Routing:** GoRouter 17.x with deep-linking support.
- **Backend Services (Firebase):**
  - **Auth:** Phone OTP authentication (`+91` focus).
  - **Database:** Cloud Firestore with offline cache.
  - **Storage:** Firebase Storage (receipt photos).
  - **Logic:** Node.js Cloud Functions (scheduled jobs and Firestore triggers).
  - **Notifications:** Firebase Cloud Messaging (FCM).
- **AI Integrations:** Google Gemini API (via serverless endpoints) for transcription parsing and receipt visual analysis.
- **Monetisation:** Google AdMob (rewarded/native ads) & Google Play Billing (subscriptions).
