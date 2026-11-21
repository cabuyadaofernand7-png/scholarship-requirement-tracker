# OpenAPI Review Notes

## 1. Source inspected

The following project sources were inspected:

- `backend/routes/api.php`
- Registered Laravel API routes using `php artisan route:list --path=api -v`
- API controllers under `backend/app/Http/Controllers/Api/`
- `frontend/lib/services/api_service.dart`
- Role relationships and role checks in the backend application source

## 2. Registered route inventory

The baseline route review reported 13 API routes. Week 17 implementation adds five routes for student program browsing/application creation and staff/reviewer work queues, for 18 routes in the current source. The current `php artisan route:list --path=api -v` output was verified on 21 November 2026 and reports 18 registered routes.

| Method | Path | Controller/action | Authentication |
|---|---|---|---|
| POST | `/api/register` | `AuthController@register` | Public |
| POST | `/api/login` | `AuthController@login` | Public |
| GET | `/api/applications` | `StudentApplicationController@index` | `auth:sanctum` |
| POST | `/api/applications` | `StudentApplicationController@store` | `auth:sanctum`, student role |
| GET | `/api/scholarship-programs` | `ScholarshipProgramController@index` | `auth:sanctum`, student role |
| GET | `/api/staff/applications` | `StaffApplicationController@index` | `auth:sanctum`, staff role |
| GET | `/api/staff/reviewers` | `StaffApplicationController@reviewers` | `auth:sanctum`, staff role |
| GET | `/api/reviewer/applications` | `ReviewerApplicationController@index` | `auth:sanctum`, reviewer role and active assignment |
| GET | `/api/documents/{document}/download` | `ApplicationDocumentDownloadController@download` | `auth:sanctum` |
| POST | `/api/applications/{application}/submit` | `ApplicationSubmissionController@submit` | `auth:sanctum` |
| POST | `/api/applications/{application}/check-missing-documents` | `MissingDocumentReminderController@check` | `auth:sanctum` |
| POST | `/api/applications/{application}/documents` | `ApplicationDocumentController@upload` | `auth:sanctum` |
| POST | `/api/applications/{application}/assign-reviewer` | `ReviewerAssignmentController@assign` | `auth:sanctum` |
| PATCH | `/api/applications/{application}/status` | `ApplicationStatusController@update` | `auth:sanctum` |
| GET | `/api/notifications` | `NotificationController@index` | `auth:sanctum` |
| POST | `/api/automation/check-deadlines` | `ScholarshipDeadlineController@check` | `auth:sanctum` |
| POST | `/api/logout` | `AuthController@logout` | `auth:sanctum` |
| GET | `/api/user` | Closure in `routes/api.php` | `auth:sanctum` |

The route list confirms the methods, paths, controller actions, and authentication middleware. It does not by itself prove that every role and ownership rule works in a live browser session. The role API feature tests and full backend suite passed using SQLite in-memory; see `../08-repository-and-maintenance/verification-20261121-role-dashboards/backend-verification.txt`.

The five added routes have feature-test coverage for staff-wide application access, staff reviewer lookup, student role denial, and reviewer assignment scoping. These automated tests do not count as browser UAT. The route inventory must be regenerated after dependencies are restored and the registered Laravel route list is available.

## 3. Authentication and authorization observations

- Registration and login are public routes.
- All other registered API routes use `auth:sanctum`.
- Login and registration create Sanctum personal access tokens.
- The Flutter API service sends the bearer token on protected requests.
- Role and ownership checks are implemented in the controllers rather than by relying on authentication middleware alone.
- Student application listing, submission, document upload, and missing-document checks require the authenticated user to be the owning student.
- Reviewer assignment is restricted to staff.
- Document download is restricted to staff and reviewers; reviewers must have an active assignment.
- Application status updates are restricted to staff and reviewers; reviewers must have an active assignment and follow the controller's status-transition rules.
- Deadline automation is restricted to staff.

## 4. Contract corrections made

The OpenAPI draft was updated to:

1. Add `GET /applications`, which was missing from the earlier specification and is used by the Flutter dashboard.
2. Include the 13 baseline routes and five newly added routes (18 total in current source).
3. Match the registered HTTP methods and route parameter names.
4. Document `auth:sanctum` as the global security requirement, with public security overrides for registration and login.
5. Document the controller-level role and ownership restrictions.
6. Include the upload endpoint's `409` response for applications outside `draft` and `for_correction`.
7. Include the upload endpoint's `503` storage-unavailable response with a generic JSON error schema; UAT-17 confirmed the live response after UAT-FND-003 retest.
8. Include the submit endpoint's `403` authorization and `409` application-state responses.
9. Describe notifications as a paginated response whose records are in the `data` property.
10. Describe document download as a file response rather than a JSON response.
11. Clarify that file extension and size restrictions are configured through required-document records.
12. Clarify that the local server URL is not a production endpoint.

## 5. Flutter client observations

The inspected `frontend/lib/services/api_service.dart` calls:

- `POST /login`
- `POST /logout`
- `GET /applications`
- `GET /scholarship-programs`
- `POST /applications`
- `GET /staff/applications`
- `GET /staff/reviewers`
- `GET /reviewer/applications`
- `GET /notifications`
- `POST /applications/{applicationId}/documents`
- `POST /applications/{applicationId}/submit`

The Flutter API service currently defines its base URL as `http://127.0.0.1:8000/api`. This is a local development setting. It must be changed to an appropriate environment-specific URL before a deployed browser client can use the API.

The Flutter service now includes scholarship program listing, draft application creation, staff application/reviewer reads, reviewer application reads, reviewer assignment, status update, and authorized document download calls. Student, staff, and reviewer dashboards exist; browser UAT has since passed for role login, reviewer assignment and review flow, student draft creation, and responsive/outage behavior.

## 6. Contract limitations and remaining validation

- The earlier 13-route revision had 14 Redocly warnings. The current 18-operation specification passed Redocly lint on November 21, 2026, using the built-in recommended configuration.
- Current validation exit code is `0`. All operations define an `operationId`; one non-fatal warning remains because the project has not declared a license.
- The current validation output is saved in `../08-repository-and-maintenance/verification-20261121-role-dashboards/openapi-lint.txt`.
- All 16 protected route operations returned HTTP 401 with `application/json` and `{"message":"Unauthenticated."}` when called without a bearer token. Empty JSON requests to public login and registration returned HTTP 422 `application/json`, matching their documented validation statuses. The reusable OpenAPI response schema reflects the protected-route result.
- At the time of the initial comparison, authenticated live responses had not yet been checked. Subsequent checks covered selected authenticated operations, including successful document downloads; full schema comparison remains pending.
- Several response descriptions intentionally remain high-level rather than claiming exhaustive JSON schemas.
- Laravel validation error responses should be confirmed with actual API requests.
- The document download response should be checked against an actual successful download.
- The local server URL is not a production server URL.
- Browser UAT for invalid credentials, non-student login, upload, submission, unauthorized roles, and backend-unavailable recovery remains separate from this source review.
- The OpenAPI specification does not establish that the application is production-ready.
- The isolated test instance is running on port 3308 using `restore_test.ini`. An earlier duplicate startup attempt collided with the active process holding `ibdata1`; no permission changes or database writes were made for that attempt. Authenticated API response comparison remains pending browser sign-in.

## 7. Review record

- Route inventory: Checked against the Laravel registered route list.
- Baseline route count: 13; current source adds five role/application routes (18 total).
- Route-list command: `php artisan route:list --path=api -v`, executed from `backend/`; exit code `0`.
- Saved route inventory: `08-repository-and-maintenance/verification-20261121-191048/api-routes-verbose.txt`.
- Laravel version command: `php artisan --version`, executed from `backend/`; Laravel Framework 13.39.0, exit code `0`.
- Source review and verification date: 21 November 2026.
- Build reference: Baseline commit `3fb56db6f33889f1cb530cf71282dc6768224d50`; Week 17 changes are uncommitted.
- OpenAPI validator: Redocly CLI using its built-in recommended configuration.
- Earlier baseline validation: the 13-route draft produced 14 warnings (13 missing operation IDs and one missing `info.license`). This result applies only to the earlier draft.
- Current validation: Passed; exit code `0`; one warning remains because the project has not declared an `info.license` field. All operations have operation IDs.
- Current validation log: `08-repository-and-maintenance/verification-20261121-role-dashboards/openapi-lint.txt`.
- Current unauthenticated comparison covered all 16 protected route operations; each returned HTTP 401 JSON `Unauthenticated.`. Empty JSON requests to public login and registration returned HTTP 422 JSON, matching the documented validation status.
- Current evidence: `openapi-live-response-comparison.md`, plus `08-repository-and-maintenance/verification-20261121-role-dashboards/openapi-live-all-protected-routes.json` and `openapi-live-public-validation.json`.
- Successful document-download response comparison: Pending.
- Differences found: Earlier draft omitted `GET /applications` and did not fully describe several controller response conditions.
- Corrections made: Updated `openapi.yaml` to align paths, methods, middleware, and documented controller behavior with the inspected source.
- Reviewer/sign-off: Pending.
- Current-source route-list recheck after the five additions: Passed; 18 routes registered on 21 Nov 2026.


## 8. Live-response comparison

Live response checks were performed against the local Laravel API on November 21, 2026.

Request conditions:
- HTTP methods: All 16 protected operations were invoked with their registered methods; login and registration were invoked as POST.
- Authentication: No bearer token supplied; no credentials entered.
- Request header: `Accept: application/json`.
- Request bodies: Empty JSON for protected POST/PATCH operations and public login/registration validation checks.
- Base URL: `http://127.0.0.1:8000/api`.
- No database records were intentionally created, changed, or deleted.

All 16 protected route operations returned HTTP 401 with `application/json` and `{"message":"Unauthenticated."}`. The login and registration endpoints each returned HTTP 422 with `application/json` for an empty JSON body. See `openapi-live-response-comparison.md` for the route-by-route table and the saved response JSON files for raw results.

The current OpenAPI specification includes a reusable JSON schema for the unauthenticated response and documents 422 validation responses for the public auth routes. The validation response bodies were not compared field by field.

Initial request behavior:
- The first requests omitted the `Accept: application/json` header.
- Those requests returned HTTP 500 with the message `Route [login] not defined.`
- Repeating the same GET requests with `Accept: application/json` returned HTTP 401 JSON responses.
- The initial result is retained as a content-negotiation observation. It is not recorded as a successful authentication test or as proof that all unauthenticated request formats are handled correctly.

Earlier comparison evidence (four endpoints, later expanded to eight) is preserved under `verification-20261121-191048/` as historical evidence. Current full results are in `verification-20261121-role-dashboards/`.

Scope limitations:
- All 16 protected operations were checked without authentication; the public login and registration routes were checked with empty JSON bodies. This does not cover successful authenticated responses or detailed 422 body schemas.
- No authenticated requests were performed.
- No successful document download was tested.
- The nonexistent document ID was not evaluated because authentication rejected the request first.
- Subsequent authenticated checks exercised role authorization, upload and submission responses, and unavailable-storage behavior (UAT-17). Full field-by-field response-schema comparison remains incomplete.
- This limited comparison does not establish complete API contract conformance.
