# OpenAPI Live Response Comparison

**Date:** November 21, 2026 (Philippine Time)
**API:** Local Laravel server at `http://127.0.0.1:8000/api`
**Request:** Exact registered methods; `Accept: application/json`; no bearer token
**Data changes:** None; requests were read-only.

| Method and endpoint | Expected | Actual | Result |
|---|---:|---|---|
| GET `/applications` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| POST `/applications` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| GET `/scholarship-programs` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| GET `/staff/applications` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| GET `/staff/reviewers` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| GET `/reviewer/applications` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| GET `/documents/999999/download` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| POST `/applications/999999/submit` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| POST `/applications/999999/check-missing-documents` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| POST `/applications/999999/documents` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| POST `/applications/999999/assign-reviewer` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| PATCH `/applications/999999/status` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| GET `/notifications` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| POST `/automation/check-deadlines` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| POST `/logout` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| GET `/user` | 401 JSON | 401, `application/json`, `{"message":"Unauthenticated."}` | Match |
| POST `/login` with `{}` | 422 JSON validation response | 422, `application/json` | Status/content type match |
| POST `/register` with `{}` | 422 JSON validation response | 422, `application/json` | Status/content type match |

The OpenAPI specification describes the 401 response through the reusable `Unauthenticated` response schema and documents 422 validation responses for login and registration. All 18 operations have `operationId` values. Redocly lint passes with one warning because the project has not declared a license.

The 16 protected route checks are recorded in `../08-repository-and-maintenance/verification-20261121-role-dashboards/openapi-live-all-protected-routes.json`; the two public validation checks are recorded in `../08-repository-and-maintenance/verification-20261121-role-dashboards/openapi-live-public-validation.json`.

## Limits

This comparison verifies unauthenticated handling and invalid-body validation only. The isolated MariaDB test instance is now available, but no authenticated requests have been made in this comparison. Authenticated API responses, role-denial responses, successful downloads, and live data-bearing responses remain unverified. The JSON body of the two 422 validation responses was not compared field by field. Automated PHPUnit role and application tests use SQLite in memory and are recorded separately; they are not authenticated live API checks or browser UAT.


## Follow-up authenticated checks (22 November 2026)

This file records the initial unauthenticated comparison only. Later controlled Sanctum requests and state assertions are recorded in `../08-repository-and-maintenance/verification-20261121-role-dashboards/openapi-live-authenticated-uat-20261122.json` and the UAT-17 files in the same verification directory. Those follow-up checks cover selected authenticated operations, including uploads, submissions, notifications, role authorization, reviewer downloads, status transitions, reminders, and storage failure/recovery. They do not establish full response-schema conformance for every authenticated operation.
