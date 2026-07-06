# Requirements: PocketPlus

This document outlines the functional and non-functional requirements for the initial release (Phase 1) of PocketPlus.

---

## 1. Functional Requirements

### 1.1 Authentication & Onboarding
- **Phone OTP Verification:** Secure sign-in utilizing Firebase Auth OTP delivery for Indian numbers.
- **Onboarding Flow:** Multi-step wizard collecting:
  - Selected role (Personal, Business, CA).
  - Business name (2–200 characters).
  - Background SMS processing consent.
- **Role-Based Tutorial:** Dynamic coach marks tailored to the chosen role (Personal vs. Business vs. CA).

### 1.2 Multi-Profile Management
- **Profile Switching:** Swapping between default, personal, or multiple business ledgers instantly.
- **Quota Restrictions:**
  - *Free Tier:* 1 profile maximum.
  - *Basic Tier:* Up to 3 profiles.
  - *Pro Tier:* Unlimited profiles.
- **UPI & Bank Routing:** Automated sorting of parsed transactions based on account endings (last 4 digits) or UPI IDs.

### 1.3 Core Ledger & Input Assistants
- **Manual Keypad Entry:** Specialized on-screen number keypad preventing invalid decimal spacing.
- **SMS Auto-Capture:** Android BroadcastReceiver analyzing bank SMS text, checking for duplicates using SHA256 hashes, categorising via Gemini, and displaying system prompts.
- **Voice Transcription NLP:** Recording micro-voice memos and converting them into structured transaction fields using Gemini.
- **Vision OCR:** Capturing paper receipt photos, scanning parameters using Gemini Vision, and pre-filling transactions.
- **Paise Precision:** Storing all financial values as `int` paise to eliminate floating-point rounding issues.

### 1.4 Invoicing & Khata Ledger
- **Invoices:** Creating line items, executing GST calculations (0%, 5%, 12%, 18%, 28%), rendering PDF receipts, and automatically logging transactions when marked PAID.
- **Khata Ledger:** Keeping customer credit/repayment ledgers, updating cumulative customer balances, and launching pre-formatted WhatsApp reminders.

### 1.5 CA Connect Sharing
- **Secure Invites:** Generating WhatsApp-sharable connection tokens linking to client books.
- **Read-Only Inspection:** Granting active CAs real-time access to streams of transactions. CAs are strictly blocked from writing/modifying transactions at the database level.
- **Flagging & Comments:** Allowing CAs to attach comment logs and flag anomalies on transactions for client review.

### 1.6 Reporting & Ads
- **PDF Export:** Filtering entries by period (Week, Month, Custom) and saving summaries offline.
- **Monetisation Gates:** Free and Basic users must watch a full AdMob rewarded video ad to export PDFs.

---

## 2. Non-Functional Requirements

### 2.1 Security & Data Privacy
- **Secure Token Storage:** Storing authentication tokens inside Android Keystore using `flutter_secure_storage`.
- **Private Log Audits:** Zero leakage of transaction values, bank numbers, or client names to console logs or Crashlytics.
- **Firestore Isolation:** Security rules enforcing profile separation, user matching, and CA-only read policies.
- **Biometric App Lock:** Prompting for fingerprint/face scanning when returning from the background (after 5 minutes).

### 2.2 Performance & Sync
- **Sub-Second Updates:** Immediate local database writes, updating UI values within 1 second.
- **Offline Operations:** Queuing database modifications in the Firestore local cache during network blackouts.

### 2.3 Regulatory Compliance
- **GST Compliance:** Financial transactions must never be hard deleted; utilize soft deletes (`deletedAt` timestamps) retained for a minimum of 7 years.
- **DPDP Act (India):** Providing a complete JSON data export of all user records and a 30-day grace period account deletion trigger.
