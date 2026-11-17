# Release and hosting kit: Prep Simulator for USAT

## Build
- Package `com.homilabs.usat_prep` (locked after the first Play upload). Version 1.0.0 (versionCode 1).
- Build: `jobq run --name usat-release-aab -- flutter build appbundle --release`, then `./gradlew --stop` in `android/`.
- Release 1.0.0+1: `releases/1.0.0+1/usat-prep-1.0.0+1.aab` (upload to Play) and `.apk` (sideload test). SHA-256 in `releases/1.0.0+1/SHA256SUMS`.
- Upload key created 18 Nov 2026: `.secrets/usat-upload.keystore` (alias `usat-upload`, RSA 2048, 10,000 days), passwords in `.secrets/usat-upload-keystore-credentials.txt`, read by `android/key.properties`. SHA-1 `63:51:46:8A:E1:28:C2:02:A2:13:04:1B:BF:08:7C:FD:97:BD:35:B2`, SHA-256 `15:7C:BA:4E:CA:5C:0C:90:DC:13:35:5F:98:24:0D:81:E2:B3:A6:19:C3:D5:CD:E6:0C:16:2E:16:27:69:83:0E`. `.secrets/` goes to the local and Drive backups, never GitHub.
- Before every release: `bash scripts/check-release-ad-ids.sh`, `python3 tool/validate.py`, `flutter test`.
- Store listing text: `docs/store-listing.md`; screenshots `store-assets/screenshots/`.

## Website: https://usat.homilabs.org
- Hostinger: subdomain `usat.homilabs.org` created 17 Nov 2026 (folder `public_html/usat` of the homilabs.org website), Lifetime SSL active (Let's Encrypt cert seen 18 Nov 2026).
- `public_html/usat` is a git checkout of this repo's `deploy` branch (cloned over HTTPS; hPanel's one Git slot for homilabs.org belongs to the games site).
- Change `website/`, commit, then `bash scripts/publish-site.sh` (pushes `deploy`, then pulls it on the server over SSH). Flush the CDN cache in hPanel if pages look stale.
- Pages: landing, `/privacy.html`, `/terms.html`, `/app-ads.txt`.
- After Play launch: replace "Coming soon on Google Play" with the Play link, and add the app to homilabs.org.

## AdMob (account homilabs.smc@gmail.com)
- Created 17 Nov 2026: app "Prep Simulator for USAT", App ID `ca-app-pub-2087846699268567~8383175362`; units `usat_home_banner` (`/4904250306`) and `usat_results_interstitial` (`/5276444535`). Status: requires review until the Play listing is linked.
- Privacy & messaging: European regulations message "Prep Simulator for USAT consent" published 17 Nov 2026 (Consent / Do not consent / Manage options, privacy URL https://usat.homilabs.org/privacy.html).
- After Play launch: link the store listing to the AdMob app.

## Play Console
| Item | Value |
|---|---|
| App icon 512×512 | `store-assets/icon-512.png` |
| Feature graphic | `store-assets/feature-graphic.png` |
| Privacy policy URL | https://usat.homilabs.org/privacy.html |
| Website | https://usat.homilabs.org |
| Contact email | homilabs.smc@gmail.com |
| Ads | Yes (AdMob banner on home tabs; one interstitial after results or practice) |
| App access | All functionality available without login |
| Data safety | Collected and shared: Device or other IDs (advertising ID) and app activity via the ads SDK, purpose Advertising, shared with Google AdMob; encrypted in transit. Test attempts stay on the device. Declare Advertising ID use as Advertising |
| Content rating | Reference/educational; No to violence, sexuality, language, drugs, gambling, purchases, user interaction |
| Target audience | 13+ |
| Category | Education |
| Track | Internal testing, then Closed testing; a new personal developer account needs 12 testers for 14 days before production |

**App name** (22 characters): `Prep Simulator for USAT`

**Short description** (80 max): `Timed NAT, GAT and job test practice with scores and every answer explained.`

**Full description**:
```
Prepare for USAT tests in Pakistan the way they feel on the day. Prep Simulator for USAT gives you full-length timed mock tests, topic practice in every area tested, and clear guidance on what to expect.

20 FULL-LENGTH TESTS FOR EACH PATH
• NAT: 90 questions in 120 minutes, following the pattern USAT publishes. Papers for Pre-Engineering (IE), Pre-Medical (IM), Computer Science (ICS) and Arts (IA).
• GAT General: 100 questions in 120 minutes across verbal, analytical and quantitative reasoning.
• Recruitment: a typical job-test mix of English, maths, analytical reasoning, General Knowledge, Islamic Studies or Ethics, and Pakistan Studies.

SCORES THAT HELP
• Your result by section, with the topics to work on next.
• Every question explained after the test, with the working and why the tempting option is wrong.
• Progress across your attempts.

TOPIC PRACTICE
• Short sets with instant answers in English, analytical reasoning, quantitative, Physics, Chemistry, Mathematics, Biology, Computer Science, General Knowledge, Islamic Studies, Ethics and Pakistan Studies.
• Practice questions are separate from the 20 tests.

GUIDANCE AND TIPS
• Test patterns, study plans, time management, bubble sheet advice and tips for each section.

PRIVATE AND OFFLINE
• Tests and practice work offline, with no account.
• Your scores stay on your phone.
• Free, with light ads, never during a test.

Prep Simulator for USAT is independent practice material by HomiLabs. It is not affiliated with, endorsed by or connected to the National Testing Service (USAT). All questions are original practice material, not real papers, and scores are for practice only. Always follow your own test notice.
```

## AdMob
- Account homilabs.smc@gmail.com. App ID `ca-app-pub-2087846699268567~6482489070`; units in `config/admob.json`. Debug builds use Google test units.
- "Limited ad serving" until the Play listing is live: after publishing, AdMob → Apps → this app → Add store (com.homilabs.usat_prep).
- `app-ads.txt` is live at https://usat.homilabs.org/app-ads.txt.
- Consent: the app logs "no form(s) configured" because no European message is published. Ads still load in Pakistan. To serve EEA/UK users properly, publish the draft message "Prep Simulator for USAT consent" (Privacy & messaging → European regulations).

## Before production (open items)
- Homi reviews Islamic Studies, Pakistan Studies and flagged items: `docs/review-flags.md`.
- Trademark: the name uses "USAT" descriptively, and the notice is in the About screen, listing and website, but Play can still ask for proof of permission.
- Phone screenshots (2-8) for the listing.
