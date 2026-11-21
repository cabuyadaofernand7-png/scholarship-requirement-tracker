# OpenAPI Live-Response Comparison

**Project:** Scholarship Requirement Tracker
**Date:** November 21, 2026
**Environment:** Local Laravel API
**Base URL:** `http://127.0.0.1:8000/api`

## Purpose

Compare selected unauthenticated API responses with the response statuses documented in `07-openapi-documentation/openapi.yaml`.

## Request conditions

- Method: GET
- Authentication: No token
- Header: `Accept: application/json`
- No request bodies submitted
- No intentional database modifications

## Results

| Endpoint | HTTP status | Content type | JSON message | Result |
|---|---:|---|---|---|
| `/applications` | 401 | application/json | `Unauthenticated.` | Documented status matched |
| `/notifications` | 401 | application/json | `Unauthenticated.` | Documented status matched |
| `/user` | 401 | application/json | `Unauthenticated.` | Documented status matched |
| `/documents/999999/download` | 401 | application/json | `Unauthenticated.` | Documented status matched; resource existence not evaluated |

## Initial request observation

The initial requests omitted the `Accept: application/json` header and returned HTTP 500 with `Route [login] not defined.`

Repeating the same requests with the JSON Accept header returned HTTP 401 with the JSON message `Unauthenticated.`.

The initial result is retained as an observation of different unauthenticated request handling. It is not counted as a successful endpoint test.

## Contract comparison

The OpenAPI specification already documents HTTP 401 for all four tested endpoints. The observed status codes match those documented statuses.

The actual JSON body contains a `message` property. The current OpenAPI 401 response descriptions do not define this response body schema.

## Limitations

- Only four protected GET endpoints were tested.
- No authenticated success response was checked.
- The document download endpoint did not reach document lookup because authentication failed first.
- No upload, submission, validation-error, role-denial, or unavailable-storage response was tested.
- Complete API response-schema conformance remains unverified.

## Source evidence

- `openapi-live-response-check.txt`
- `openapi-live-response-check-json-request.txt`
- `../07-openapi-documentation/openapi.yaml`
- `../../../../backend/routes/api.php`
