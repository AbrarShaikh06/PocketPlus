# Android App Links — Digital Asset Links

PocketPlus uses Android **App Links** (`autoVerify="true"` intent-filters in
`AndroidManifest.xml`) for two deep links:

| Host | Path | Purpose |
|---|---|---|
| `pocketplus.app` | `/ca/accept` | CA invite acceptance |
| `pocketplus-app.firebaseapp.com` | `/auth/email-link` | Firebase Auth email link |

For Android to verify these links (open them in-app without the chooser), each
host must serve a Digital Asset Links file over HTTPS at:

```
https://<host>/.well-known/assetlinks.json
```

## What you must host

- **`pocketplus.app`** → host the `assetlinks.json` in this folder at
  `https://pocketplus.app/.well-known/assetlinks.json` (you control this domain).
- **`pocketplus-app.firebaseapp.com`** → **auto-managed by Firebase.** Firebase
  Auth publishes the assetlinks for its `*.firebaseapp.com` domain automatically
  once your app's SHA-256 is registered in the (new) Firebase project. You do
  **not** host a file there yourself.

## Fill in the fingerprints

Replace the three placeholders in `assetlinks.json` with real SHA-256 cert
fingerprints (you can include all that apply; extra entries are harmless):

```bash
# Release keystore (your in.pocketplus.app signing key)
keytool -list -v -keystore release-keystore.jks -alias igrow \
  | grep "SHA256:"

# Debug keystore (for local App Links testing)
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android -keypass android \
  | grep "SHA256:"
```

- **Play App Signing SHA-256:** Play Console → your app → Setup → App signing →
  *App signing key certificate* → SHA-256. Add this one too, since Google
  re-signs the uploaded bundle.
- Format each as uppercase hex with colons, e.g.
  `AB:CD:EF:...:12` (keytool already prints it this way).

## Verify after deploying

```bash
# Confirm the file is reachable and correct
curl https://pocketplus.app/.well-known/assetlinks.json

# Test verification on a device (Android 12+)
adb shell pm verify-app-links --re-verify in.pocketplus.app
adb shell pm get-app-links in.pocketplus.app   # all hosts should show "verified"
```

> Note: the keystore alias above (`igrow`) is the alias inside the existing
> `release-keystore.jks`. If you generate a new keystore for PocketPlus, use its
> actual alias.
