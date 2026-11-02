# Week 14 – Key and Secret-Handling Evidence

## 1. Purpose

This document records the checks performed to reduce the risk of exposing application keys, credentials, access tokens, and other sensitive configuration values in the Scholarship Requirement Tracker.

## 2. Environment Configuration

| Verification | Result |
|---|---|
| Backend `.env` file exists | Passed |
| Backend `.env.example` file exists | Passed |
| `.env` is excluded by Git | Passed |
| `.env` is not tracked by Git | Passed |
| Laravel application key is configured | Confirmed |
| Example environment file uses placeholders for sensitive settings | Confirmed |

Actual secret values were not copied into this report.

## 3. Source-Code Checks

The following checks were performed:

- Searched Flutter source files for common hardcoded API key, client secret, and access token patterns.
- Searched Laravel application, route, and configuration files for common hardcoded secret and password patterns.
- Checked for browser storage and persistent token-storage implementations in Flutter source files.

No matches were found for the searched hardcoded-secret patterns or browser-storage patterns.

## 4. Token Handling

The Flutter API service currently stores the authentication token in an in-memory variable.

The token is sent through the HTTP Authorization Bearer header when making protected API requests. No browser storage implementation was found in the inspected Flutter source files.

The token is cleared when the logout method completes.

## 5. API Configuration

The current development API URL is:

`http://127.0.0.1:8000/api`

This configuration is intended for local development. It is not suitable for production deployment because it uses a local address and unencrypted HTTP.

A production deployment must use an appropriate HTTPS endpoint and undergo additional security review.

## 6. Archive Check

The Week 13 evidence archive was checked for filenames matching common sensitive-file patterns, including `.env`, `.pem`, `.key`, `credentials`, and `secrets`.

No matching filenames were found.

This check only examined filenames and does not prove that ordinary documents inside the archive contain no sensitive information.
## 7. Flutter Web Build Inspection

The Flutter Web application was successfully built using:

`flutter build web`

The generated files were inspected for common hardcoded API key, client secret, access token, and password patterns.

**Result:** No matches were found in the generated build files.

This check is limited to the selected search patterns and does not guarantee that all sensitive information is absent from the compiled application.

The generated build used the local development API URL. It must be configured appropriately before deployment.

## 8. Limitations

- The Flutter Web build directory did not exist during these checks.
- Generated build files have not yet been inspected.
- Source-code searches only detect the patterns included in the searches.
- No complete automated secret-scanning tool was used.
- The current local HTTP configuration is not production-ready.
- Additional review is required before deployment.

## 9. Conclusion

The checks confirmed that the backend environment file is ignored by Git and is not tracked. The Laravel application key is configured, and the example environment file uses placeholders for sensitive settings.

The inspected source files and Week 13 archive did not contain filenames or code patterns matching the selected common secret indicators. These checks provide initial evidence of secret-handling practices but do not guarantee that all sensitive information has been eliminated.

**Status:** Initial key and secret-handling checks completed. Flutter Web build inspection and further security verification remain pending.