# Week 14 – Adverse Security Testing Report

## 1. Objective

To verify that the Scholarship Requirement Tracker rejects unauthorized access, enforces document-download permissions, and revokes authentication tokens after logout.

## 2. Document Download Security Tests

The following automated tests were executed:

| No. | Test scenario | Expected result | Actual result |
|---|---|---|---|
| 1 | Unauthenticated document download | HTTP 401 | Passed |
| 2 | Student attempts document download | HTTP 403 | Passed |
| 3 | Staff downloads a document | Successful download | Passed |
| 4 | Assigned reviewer downloads a document | Successful download | Passed |
| 5 | Unassigned reviewer downloads a document | HTTP 403 | Passed |
| 6 | Staff requests a document with a missing file | HTTP 404 | Passed |
| 7 | Staff requests a document with an empty file path | HTTP 404 | Passed |
| 8 | Request uses a nonexistent document ID | HTTP 404 | Passed |

**Command executed:**

`php artisan test --filter=DocumentDownloadTest`

**Result:** 8 tests passed, 8 assertions, 0 failures.

The complete backend test suite was also executed.

**Command:** `php artisan test`

**Result:** 10 tests passed, 10 assertions, 0 failures.

## 3. Authentication and Token Security Tests

| No. | Test scenario | Expected result | Actual result |
|---|---|---|---|
| 1 | Request notifications with an invalid Bearer token | HTTP 401 | HTTP 401 |
| 2 | Request notifications without an authentication token | HTTP 401 | HTTP 401 |
| 3 | Access notifications using a valid test token before logout | Successful response | Successful |
| 4 | Send logout request using the valid test token | Successful logout | Logout successful |
| 5 | Reuse the same token after logout | HTTP 401 | HTTP 401 |

### Token Revocation Test

A test token was obtained through the demo student login endpoint and stored locally in PowerShell.

The following sequence was verified:

1. The token successfully accessed the protected notifications endpoint.
2. The logout endpoint returned `Logout successful.`
3. The same token was reused to request notifications.
4. Laravel returned HTTP 401 Unauthorized.

**Conclusion:** The test confirmed that the Sanctum access token was revoked after logout and could no longer access the protected endpoint.

No actual authentication token or password was included in this report.

## 4. Test Setup Observation

An initial invalid-token request without an `Accept: application/json` header returned HTTP 500 because Laravel attempted to redirect the unauthenticated request to a named `login` route.

After adding the JSON request header, the same invalid-token test correctly returned HTTP 401.

The initial HTTP 500 was treated as a request-format issue, not a successful security test.

## 5. Test Environment and Limitations

- Testing was performed using the local Laravel development server.
- Document-download automated tests used SQLite and fake storage.
- Actual Flutter Web document uploads and application submission were separately verified using the local MySQL database and private storage.
- The tests do not establish production readiness.
- Additional deployment, HTTPS, and broader security testing remain necessary.

## 6. Overall Conclusion

The completed tests confirmed that protected API endpoints reject invalid and missing authentication tokens, document downloads enforce role and assignment restrictions, and Laravel successfully revokes the current Sanctum token during logout.

The tested security controls behaved according to their expected results in the local development environment.

**Status:** Initial adverse security testing completed.