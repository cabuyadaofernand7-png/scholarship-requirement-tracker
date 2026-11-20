# Week 16 Flutter Web Observations

**Status:** PARTIALLY COMPLETED — login-screen loading and basic desktop/mobile responsive-layout observations passed.

## 1. Test identification

| Field | Actual observation |
|---|---|
| Test date | November 21, 2026 |
| Browser | Microsoft Edge |
| Application | Scholarship Requirement Tracker Flutter Web frontend |
| Environment | Local Windows development environment |
| Build reference | Working tree at commit `945e04c` |
| Test method | Manual browser inspection |
| Tested screen | Login screen |

## 2. Observations

| Check | Expected behavior | Actual observation | Result |
|---|---|---|---|
| Initial loading | Application displays without a blank page or loading error | Login screen appeared successfully | PASS |
| Desktop layout | Login screen fits the browser window without obvious clipping | Layout displayed correctly during manual inspection | PASS |
| Mobile layout | Login screen fits the mobile viewport without horizontal scrolling or clipped controls | Layout displayed correctly in Edge device emulation at approximately 390 × 844 | PASS |

## 3. Findings

- Flutter Web launched successfully in Microsoft Edge.
- The login screen appeared without a reported loading error.
- The desktop layout displayed correctly during manual inspection.
- The mobile-emulated layout displayed correctly during manual inspection.
- No visible clipping or horizontal scrolling was observed during the reported checks.
- Desktop and mobile screenshots were captured and saved in this evidence folder.

## 4. Limitations

- The exact desktop viewport dimensions were not recorded.
- The mobile viewport was configured to approximately 390 × 844; the exact device preset was not recorded.
- This was a manual visual inspection, not an automated responsive-layout test.
- Other application screens and authenticated workflows were not included in this observation.
- These results do not establish performance across all browsers, devices, or screen sizes.

## 5. Evidence files

| Screenshot | Description |
|---|---|
| `week-16-login-desktop.png` | Login screen displayed in Microsoft Edge desktop view |
| `week-16-login-mobile.png` | Login screen displayed in Microsoft Edge mobile device emulation |

Both screenshots are stored in this folder.

No production-readiness claim is made from these observations.
