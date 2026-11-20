# Week 15 – Authentication API Test Results

## 1. Test Information
- Project: Scholarship Requirement Tracker
- Testing Area: Authentication API
- Testing Tool: Laravel PHPUnit
- Test File: `AuthApiTest.php`
- Test Status: PASSED

## 2. Test Execution

Command: `php artisan test --filter=AuthApiTest`

Actual Results:
- Total tests passed: 9
- Total assertions: 33
- Failed tests: 0
- Execution time: 0.88 seconds

## 3. Test Coverage

- Successful student registration.
- Rejection of duplicate email addresses.
- Rejection of passwords shorter than the required length.
- Rejection of unconfirmed passwords.
- Successful login with correct credentials.
- Rejection of incorrect passwords.
- Rejection of unknown email addresses.
- Validation of missing login credentials.
- Successful logout and access-token revocation.

## 4. Test Result

Overall Result: PASSED

All 9 authentication tests passed with 33 assertions. The results provide evidence that the tested registration, login, validation, and logout behaviors work as expected.

## 5. Evidence

- `W15-09-auth-api-tests-passed.png`

## 6. Limitations

These tests cover the authentication scenarios listed above. They do not establish that all security risks, authentication edge cases, or production authentication configurations have been verified.

## Additional Security Test – Token Revocation

**Test:** Revoked token cannot access protected endpoint

**Procedure:**
1. Create a Sanctum access token.
2. Log out using the token.
3. Clear cached authentication guards in the test environment.
4. Attempt to access `/api/user` using the revoked token.

**Expected Result:** HTTP 401 Unauthorized.

**Actual Result:** HTTP 401 Unauthorized.

**Test Result:** PASS

**Authentication Test Suite:** 10 passed, 35 assertions, 0 failures.