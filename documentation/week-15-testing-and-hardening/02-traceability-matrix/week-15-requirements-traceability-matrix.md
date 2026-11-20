# Week 15 Requirements Traceability Matrix

**Project:** Scholarship Requirement Tracker  
**Week:** 15 - Testing and Hardening

## 1. Purpose

This matrix connects the application's functional and security requirements to the automated tests and evidence produced during Week 15.

It helps verify which requirements have corresponding test coverage and identifies areas where further testing may be needed.

## 2. Requirements Traceability

| ID | Requirement / Test Area | Related Test Method | Expected Behavior | Evidence / Location | Status |
|---|---|---|---|---|---|
| W15-RT-001 | User authentication | `AuthApiTest` | Valid login succeeds; invalid credentials are rejected | `03-api-test-results/` | Covered |
| W15-RT-002 | Token security | `AuthApiTest`, `NotificationAccessTest` | Invalid and revoked tokens cannot access protected endpoints | `05-security-and-adverse-tests/screenshots/W15-24-invalid-token-notification-tests-passed.png` | Covered |
| W15-RT-003 | Application submission | `ApplicationSubmissionTest` | Students can submit eligible applications with required documents | `03-api-test-results/` | Covered |
| W15-RT-004 | Submission validation | `ApplicationSubmissionTest` | Missing required documents and invalid submission states are rejected | `03-api-test-results/` | Covered |
| W15-RT-005 | Reviewer assignment | `ReviewerAssignmentTest` | Authorized staff can assign eligible reviewers; duplicate active assignments are prevented | `03-api-test-results/` | Covered |
| W15-RT-006 | Application status authorization | `ApplicationStatusTest` | Unassigned reviewers and unauthorized users cannot update application status | `05-security-and-adverse-tests/screenshots/W15-15-unassigned-reviewer-authorization-failed.png` and `W15-16-reviewer-authorization-fix-passed.png` | Covered |
| W15-RT-007 | Reviewer status workflow | `ApplicationStatusTest` | Reviewers must move submitted applications to `under_review` before making a decision | `03-api-test-results/screenshots/W15-26-application-status-workflow-tests-passed.png` | Covered |
| W15-RT-008 | Document upload validation | `ApplicationDocumentUploadTest` | Invalid file types and files exceeding configured size limits are rejected | `03-api-test-results/` | Covered |
| W15-RT-009 | Document ownership | `ApplicationDocumentUploadTest` | Students cannot upload documents to another student's application | `03-api-test-results/` | Covered |
| W15-RT-010 | Document storage failure | `ApplicationDocumentUploadTest` | Failed storage operation returns HTTP 503 without creating an incomplete document record | `05-security-and-adverse-tests/screenshots/W15-20-document-storage-failure-handled.png` | Covered |
| W15-RT-011 | Document download authorization | `DocumentDownloadTest` | Only authorized users can download application documents; reassigned reviewers are denied | `03-api-test-results/` and `06-defect-and-fix-records/W15-DEF-004-reassigned-reviewer-document-download.md` | Covered |
| W15-RT-012 | Missing document handling | `DocumentDownloadTest` | Missing files and nonexistent document records return HTTP 404 | `03-api-test-results/` | Covered |
| W15-RT-013 | Notification privacy | `NotificationAccessTest` | Students can access their own notifications but not another student's notifications | `05-security-and-adverse-tests/screenshots/W15-24-invalid-token-notification-tests-passed.png` | Covered |
| W15-RT-014 | Flutter code quality | Flutter Analyzer | Static analysis completes without reported issues | `04-flutter-web-test-results/screenshots/W15-26-flutter-analyze-passed.png` | Passed |
| W15-RT-015 | Flutter widget behavior | Flutter Test | Available widget test passes | `04-flutter-web-test-results/screenshots/W15-27-flutter-test-passed.png` | Passed |
| W15-RT-016 | Flutter Web compilation | Flutter Web Build | Production Web build completes successfully | `04-flutter-web-test-results/screenshots/W15-28-flutter-web-build-success.png` | Passed |
| W15-RT-017 | Backend regression | Laravel test suite | Existing backend tests pass after corrections | `03-api-test-results/screenshots/W15-27-full-backend-regression-54-passed.png` and `07-regression-evidence/W15-REG-001-full-backend-regression.md` | Passed |

## 3. Summary of Coverage

| Area | Traceability Status |
|---|---|
| Authentication and token security | Covered |
| Application submission and validation | Covered |
| Reviewer assignment and authorization | Covered |
| Application status workflow | Covered |
| Document upload and storage handling | Covered |
| Document download and access restrictions | Covered |
| Notification privacy | Covered |
| Flutter static analysis | Passed |
| Flutter widget testing | Passed |
| Flutter Web production build | Passed |
| Backend regression | Passed |

## 4. Coverage Limitations

The matrix records the requirements verified by the available Week 15 tests. It does not establish complete coverage of every possible application scenario.

The following areas require additional verification if they become part of the testing scope:

- Comprehensive manual testing of all Flutter screens and workflows.
- External penetration testing.
- Production infrastructure failure and recovery.
- High-volume performance and stress testing.
- Independent security audit.

## 5. Conclusion

The traceability matrix connects the Week 15 test areas to their corresponding automated tests and supporting evidence.

The recorded results demonstrate coverage of important backend workflows, security restrictions, adverse scenarios, frontend checks, and regression testing. Remaining limitations are identified for future verification.
