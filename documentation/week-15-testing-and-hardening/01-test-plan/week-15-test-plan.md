# Week 15 Test Plan

**Project:** Scholarship Requirement Tracker  
**Week:** 15 - Testing and Hardening  
**Testing Environment:** Local development environment  
**Backend:** Laravel 13.39.0  
**Frontend:** Flutter Web  
**Database:** MySQL/MariaDB test database

## 1. Purpose

This test plan defines the testing activities for Week 15. Its purpose is to verify important application workflows, identify defects, validate security controls, and check that corrections do not break existing backend functionality.

## 2. Testing Objectives

The objectives are to:

- Verify application submission and status workflow behavior.
- Check document upload, validation, and download operations.
- Verify authentication and role-based authorization.
- Test notification access restrictions.
- Check handling of invalid requests and unavailable document storage.
- Identify, correct, and document defects.
- Execute regression tests after corrections.
- Verify Flutter code analysis, widget testing, and Web production compilation.

## 3. Testing Scope

### Included

**Backend**
- User registration, login, logout, and token validation.
- Student application submission.
- Application status transitions.
- Reviewer assignment and authorization.
- Document upload validation and storage failure handling.
- Document download authorization.
- Notification access restrictions.
- Invalid, unauthenticated, and unauthorized requests.

**Frontend**
- Flutter static code analysis.
- Available Flutter widget test.
- Flutter Web production build.

**Regression**
- Re-execution of the Laravel backend test suite after corrections.
- Verification of previously identified defects.

### Excluded

The following activities are not included in the recorded Week 15 verification:

- Full external penetration testing.
- Production infrastructure outage testing.
- High-volume load and stress testing.
- Independent security audit.
- Comprehensive manual testing of every Flutter screen and user workflow.
- Production deployment verification.

## 4. Testing Methods

| Method | Purpose |
|---|---|
| Automated feature testing | Verify backend API behavior and business rules |
| Negative testing | Check invalid inputs and rejected operations |
| Authorization testing | Verify access restrictions for different user roles |
| Failure simulation | Verify application behavior when document storage fails |
| Regression testing | Check existing functionality after code corrections |
| Static analysis | Detect Flutter code issues |
| Widget testing | Verify the available Flutter widget test |
| Production build testing | Confirm that Flutter Web compiles successfully |

## 5. Test Environment and Tools

| Component | Tool or Environment |
|---|---|
| Backend framework | Laravel 13.39.0 |
| Backend language | PHP |
| Frontend framework | Flutter |
| Frontend target | Web |
| Database | MySQL/MariaDB |
| Backend test runner | PHPUnit through Laravel Artisan |
| Frontend analysis | Flutter Analyzer |
| Frontend test runner | Flutter Test |
| Build verification | Flutter Web Build |
| Development environment | Windows with XAMPP |

Tests must use the designated test database and must not modify the original database or recovery snapshot.

## 6. Main Test Areas

| Test Area | Main Verification |
|---|---|
| Authentication | Valid credentials, invalid credentials, logout, invalid and revoked tokens |
| Application submission | Required documents, missing documents, ownership, submission state |
| Reviewer assignment | Authorized staff assignment, reviewer role, duplicate assignment |
| Application status | Valid transitions, invalid transitions, role restrictions |
| Document upload | File type, file size, program ownership, application ownership |
| Document storage | Handling of simulated storage failure |
| Document download | User role, active reviewer assignment, missing files |
| Notifications | Authentication and ownership restrictions |
| Flutter frontend | Analysis, available widget test, Web build |

## 7. Test Execution and Evidence

Test results are documented in:

`03-api-test-results/`

`04-flutter-web-test-results/`

Security and adverse-test evidence is documented in:

`05-security-and-adverse-tests/`

Defects and corrections are recorded in:

`06-defect-and-fix-records/`

Regression evidence is stored in:

`07-regression-evidence/`

Screenshots are retained in the corresponding evidence folders.

## 8. Entry Criteria

Testing may proceed when:

- The application source code is available.
- The backend and frontend development environments are configured.
- The designated test database is available.
- Automated test files are prepared.
- Relevant application features are implemented sufficiently for testing.

## 9. Exit Criteria

The Week 15 testing activities may be considered complete when:

- Planned and available tests have recorded results.
- Identified defects have documented corrections or limitations.
- The latest backend regression suite has been executed.
- Flutter analysis, widget testing, and Web build results are documented.
- Test evidence and traceability documentation are organized.
- Remaining limitations are clearly identified.

## 10. Current Verification Results

| Verification | Result |
|---|---|
| Laravel backend regression | 54 passed, 114 assertions, 0 failures |
| Application status tests | 9 passed, 20 assertions, 0 failures |
| Flutter analysis | Passed |
| Flutter widget testing | 1 passed, 0 failures |
| Flutter Web production build | Passed |

**Note:** These are the latest recorded results, not a claim that every possible application scenario has been tested.

## 11. Risks and Limitations

- Automated tests cover selected application behaviors and do not guarantee the absence of all defects.
- The document storage failure test uses a mocked storage operation.
- The available Flutter widget test covers only one test case.
- Production infrastructure and high-volume performance have not been independently tested.

## 12. Conclusion

This test plan establishes the scope, methods, environment, and evidence requirements for Week 15 Testing and Hardening. It provides a structured basis for evaluating application functionality, security behavior, failure handling, and regression results.
