# Data-Flow and Protection-Requirements Matrix

**Project:** Scholarship Requirement Tracker
**Week:** 14 â€“ Secure Data Exchange and Encryption
**Student:** Cabuyadao, Fernand
**Technology:** Flutter Web, Laravel REST API, MySQL, and Laravel Sanctum

## 1. Purpose

This document identifies the information exchanged between the Flutter Web frontend and Laravel backend, where the information is stored, and the security measures applied to protect it.

The matrix describes the current implementation and identifies additional protections required before deployment.

## 2. Data-Flow Overview

The system follows this general process:

1. The student uses the Flutter Web application.
2. Flutter sends requests to the Laravel REST API.
3. Laravel validates requests and checks authentication and user permissions.
4. Approved information is processed and stored in the MySQL database or private file storage.
5. Laravel returns the appropriate response to Flutter.
6. The user can log out, which revokes the current Sanctum access token.

## 3. Data-Flow and Protection-Requirements Matrix

| Data Flow | Information Involved | Destination | Protection Applied | Remaining Requirement |
|---|---|---|---|---|
| Student login | Email and password | Laravel API and authentication system | Login endpoint; Laravel authentication; password is submitted through the API | HTTPS must be configured before deployment |
| API authentication | Sanctum access token | Laravel API | Bearer token authentication; protected routes use `auth:sanctum` | Review token lifetime and secure session handling |
| Application submission | Application ID and submitted application data | Laravel API and MySQL database | Authentication, ownership checks, server-side validation, and database transaction | Continue reviewing validation and access permissions |
| Document upload | Uploaded document file and related application information | Laravel private storage and MySQL metadata | Authentication, student ownership checks, required-document validation, file extension and size validation | Add file-content verification and malware scanning where appropriate |
| Document download | Document ID and stored file | Laravel API and authorized user | Staff/reviewer role checks; reviewers must be assigned to the application; private file storage | Review download auditing and additional file protection |
| Notifications | Authenticated user's notification records | Laravel API and Flutter Web | Protected endpoint; notifications are filtered by authenticated user | Review notification data exposure and retention |
| Logout | Current Sanctum access token | Laravel authentication system | Current access token is deleted; subsequent use of the revoked token is rejected | Review session behavior across browser tabs and deployed environments |

## 4. Information Classification

| Information Type | Classification | Protection Requirement |
|---|---|---|
| Student account information | Confidential | Restrict access to authenticated and authorized users |
| Scholarship application information | Confidential | Check application ownership and user roles |
| Uploaded scholarship documents | Sensitive | Store privately and restrict downloads |
| Authentication tokens | Secret | Never expose in source code, screenshots, logs, or submitted evidence |
| Application status and review information | Confidential | Restrict changes to authorized staff and reviewers |
| General application responses | Internal | Avoid exposing unnecessary information in API responses |

## 5. Storage and Communication Protection

### Database

- MySQL stores application information and document metadata.
- Database credentials are maintained in the Laravel environment configuration.
- Server-side validation and authorization checks are applied before protected operations.

### Document Storage

- Uploaded documents are stored using Laravel's private local storage disk.
- The configured storage root is `storage/app/private`.
- Document downloads pass through an authenticated controller.
- Direct public access to the uploaded document files is not intended.

### API Communication

- Flutter communicates with the Laravel REST API.
- Protected requests use Sanctum Bearer token authentication.
- The current local development API uses HTTP at `http://127.0.0.1:8000/api`.
- HTTPS is required before deployment because HTTP does not encrypt communication in transit.

### Secret Management

- Laravel environment variables are used for application configuration and credentials.
- The `.env` file is excluded from Git tracking.
- Secrets and real access tokens must not be included in screenshots, documentation, or source code.

## 6. Security Limitations and Additional Requirements

The following limitations remain:

1. The current local API uses HTTP instead of HTTPS.
2. Flutter currently keeps the authentication token in memory, so users must log in again after refreshing the browser.
3. File validation checks extensions and file sizes, but additional file-content inspection and malware scanning may be needed.
4. Staff and reviewer status permissions still need more specific separation.
5. Automated tests use SQLite and fake storage, so further verification in the actual deployment environment is necessary.
6. Database and private-file encryption at rest have not been established by the current implementation.

## 7. Conclusion

The current implementation applies authentication, authorization, server-side validation, private document storage, and token revocation to important data flows.

However, these protections do not mean the system is production-ready. HTTPS, stronger file inspection, more detailed permission controls, and additional deployment security checks are still required.

**Evidence and verification:** The implementation and security tests are documented in the Week 14 key and secret-handling evidence, document download security tests, and residual-risk statement.
