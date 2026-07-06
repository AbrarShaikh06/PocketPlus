# Required GitHub Secrets

The following secrets must be configured in the GitHub repository
under **Settings → Secrets and variables → Actions**.

## API Keys

| Secret | Description |
|--------|-------------|
| `GEMINI_API_KEY` | Gemini API key (used by SMS categoriser, voice parser, OCR parser) |

> AdMob is configured directly in `android/app/src/main/AndroidManifest.xml`
> (`com.google.android.gms.ads.APPLICATION_ID`). Replace the test ID
> (`ca-app-pub-3940256099942544~3347511713`) with the production AdMob app ID
> before a Play Store release. There is no AdMob build secret.

## Play Store (Production)

| Secret | Description |
|--------|-------------|
| `KEYSTORE_BASE64` | Base64-encoded release keystore (`.jks`) file. Encode: `base64 -w0 release-keystore.jks` |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_ALIAS` | Key alias for the signing key |
| `KEY_PASSWORD` | Key password for the signing key |
| `PLAY_STORE_JSON_KEY` | Base64-encoded Google Play API service account JSON with **Publisher** role. Encode: `base64 -w0 play-store-key.json` |

## Optional

| Secret | Description |
|--------|-------------|
| `CODECOV_TOKEN` | Token for uploading coverage reports to Codecov (PR checks will not fail if absent) |

---

## Quick Setup

1. Generate a release keystore (if not already done):
   ```bash
   keytool -genkey -v -keystore release-keystore.jks \
     -alias pocketplus-release -keyalg RSA -keysize 2048 \
     -validity 10000
   ```

2. Encode all files:
   ```bash
   base64 -w0 release-keystore.jks > keystore.b64
   base64 -w0 play-store-key.json > play-store-key.b64
   base64 -w0 firebase-service-account.json > firebase-sa.b64
   ```

3. Copy the base64 output into the corresponding GitHub Secrets.

---

## Environment

The app is **single-environment**: one Firebase project and one application
(`in.pocketplus.app`), with no Flutter flavors. The Firebase project is selected
solely by the checked-in `lib/firebase_options.dart` and
`android/app/google-services.json` — there is no `FIREBASE_PROJECT_ID` build
argument. Ad unit IDs live in `AndroidManifest.xml`.
