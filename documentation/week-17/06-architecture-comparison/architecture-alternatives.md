# Architecture Alternatives and Recommendation

## 1. Current architecture

The Week 17 source review confirms the following architecture:

| Layer | Current implementation | Evidence / observation |
|---|---|---|
| Frontend | Flutter Web | Application source is under `frontend/`. |
| Backend | Laravel 13 REST API | API routes and controllers are under `backend/`. |
| Authentication | Laravel Sanctum bearer tokens | Login and registration create personal access tokens; protected routes use `auth:sanctum`. |
| Authorization | Role and ownership checks in API controllers | Controllers check student, staff, and reviewer roles and enforce ownership or reviewer assignment where applicable. |
| Database | MySQL/MariaDB | Laravel database configuration uses the MySQL connection. The local test environment uses MariaDB. |
| Document storage | Laravel `local` storage disk | Uploaded documents are stored privately and downloaded through an authenticated controller. |
| Source control | Git | The project is maintained in a Git repository. |

The Flutter API service currently uses the hard-coded local base URL `http://127.0.0.1:8000/api`. This is suitable only for the current local development setup. A deployed browser client will require an environment-appropriate API URL and deployment configuration.

## 2. Architecture alternatives

| Alternative | Advantages | Trade-offs / risks | Fit for this project |
|---|---|---|---|
| A. Flutter Web + Laravel API + MySQL/MariaDB | Reuses the existing frontend, backend, database, tests, and documentation; keeps a clear API boundary; relational storage suits applications, required documents, assignments, and status history | Requires coordinated API contracts, secure hosting, HTTPS, CORS configuration where applicable, database backups, private file-storage operations, and environment-specific frontend configuration | Strongest fit for the current prototype because it is already implemented and has supporting test evidence |
| B. Laravel-rendered frontend + Laravel backend | Uses one main application framework; may simplify deployment and reduce the need for a separate frontend API client | Requires replacing or substantially reworking the existing Flutter interface; existing Flutter workflow and test evidence would need to be recreated | Technically possible, but the migration is not justified by a demonstrated project requirement |
| C. Flutter Web + a different backend framework | Retains the Flutter interface while allowing a different backend technology | Requires rewriting API behavior, authentication, authorization, validation, database integration, and tests; increases migration and maintenance work | No demonstrated need currently justifies replacing the Laravel backend |

## 3. Evaluation criteria

The alternatives were considered using these criteria:

- Reuse of existing working code and test evidence.
- Suitability for the bounded scholarship application workflow.
- Authentication, authorization, and document privacy requirements.
- Maintainability for the project team.
- Deployment and operational complexity.
- Testability and continuity of evidence.
- Infrastructure and migration effort.

This is a qualitative comparison based on the inspected implementation. No numerical scores, performance benchmarks, or cost measurements have been claimed because no comparative benchmark or cost study was performed.

## 4. Recommendation

**Provisional recommendation: retain Flutter Web + Laravel API + MySQL/MariaDB for the current project prototype.**

The existing architecture already supports the implemented student application workflow, document upload, application submission, notifications, reviewer assignment, status updates, and deadline-reminder endpoints. It also has backend and Flutter test evidence. Replacing a major layer during the current project stage would introduce migration work without a demonstrated benefit.

This recommendation applies to the current prototype and does not establish production readiness.

Before deployment beyond the local test environment, the project still requires:

- Environment-specific frontend API configuration instead of relying on the hard-coded localhost URL.
- HTTPS and appropriate server, CORS, and browser-origin configuration.
- Secure production secret management.
- A verified database backup and restoration procedure.
- A private document-storage backup and recovery procedure.
- Deployment configuration and operational ownership.
- Further role-based browser UAT and security verification.
- Review of the OpenAPI contract against actual API responses.

## 5. Decision record

- Recommended alternative: Alternative A — Flutter Web + Laravel API + MySQL/MariaDB.
- Decision status: Provisional project recommendation; awaiting reviewer confirmation.
- Basis: Existing source implementation, registered API routes, current test evidence, and qualitative comparison above.
- Comparative performance benchmark: Not performed.
- Comparative cost study: Not performed.
- Reviewer:
- Decision date:
- Conditions or required changes before final approval:
