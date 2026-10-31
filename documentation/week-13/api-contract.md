# Week 13 — Backend API Contract

## 1. Purpose

This document defines the API endpoints used by the Scholarship Requirement Tracker's automation workflows.

The API connects the Flutter Web frontend to the Laravel backend and provides operations for application submission, reminders, reviewer assignment, status updates, and notification retrieval.

## 2. API Base URL

Local development:

`http://127.0.0.1:8000/api`

## 3. API Endpoints

### 3.1 Submit Scholarship Application

**Method:** POST

**Endpoint:** `/applications/{application}/submit`

**Purpose:** Validates an application and submits it for review.

**Expected behavior:**
- Check whether the application exists.
- Check whether all required documents have been submitted.
- Reject incomplete applications.
- Change the status to `submitted` when validation succeeds.
- Record the submission time.

**Success response:** HTTP 200

**Possible errors:**
- HTTP 404 — Application not found.
- HTTP 422 — Required documents are incomplete.
- HTTP 409 — Application cannot be submitted in its current state.

### 3.2 Check Missing Documents

**Method:** POST

**Endpoint:** `/applications/{application}/check-missing-documents`

**Purpose:** Identifies missing required documents and generates a student reminder.

**Expected behavior:**
- Check the application's required documents.
- Identify missing submissions.
- Generate a notification when necessary.
- Avoid creating duplicate reminders unnecessarily.

**Success response:** HTTP 200

**Possible errors:**
- HTTP 404 — Application not found.
- HTTP 500 — Automation operation failed.

### 3.3 Check Scholarship Deadlines

**Method:** POST

**Endpoint:** `/automation/check-deadlines`

**Purpose:** Checks active scholarship programs for approaching deadlines.

**Expected behavior:**
- Retrieve active scholarship programs.
- Identify applicable applications.
- Determine which deadlines meet the configured reminder rules.
- Generate deadline notifications.
- Record the results of the automation run.

**Success response:** HTTP 200

**Possible errors:**
- HTTP 500 — Deadline-checking operation failed.

### 3.4 Assign Application Reviewer

**Method:** POST

**Endpoint:** `/applications/{application}/assign-reviewer`

**Purpose:** Assigns a reviewer to a submitted application.

**Sample request:**

```json
{
    "reviewer_id": 3
}
```

**Expected behavior:**
- Validate the application.
- Validate the selected reviewer.
- Record the assignment.
- Generate an assignment notification.

**Success response:** HTTP 201

**Possible errors:**
- HTTP 404 — Application or reviewer not found.
- HTTP 422 — Invalid assignment information.
- HTTP 409 — Application is not eligible for assignment.

### 3.5 Update Application Status

**Method:** PATCH

**Endpoint:** `/applications/{application}/status`

**Sample request:**

```json
{
    "status": "for_correction",
    "reason": "A required document needs resubmission."
}
```

**Expected behavior:**
- Validate the requested status.
- Record the previous and new status.
- Save the status history.
- Generate an appropriate student notification.
- Keep confidential reviewer comments private.

**Success response:** HTTP 200

**Possible errors:**
- HTTP 404 — Application not found.
- HTTP 422 — Invalid status information.
- HTTP 409 — Invalid status transition.

### 3.6 Retrieve Notifications

**Method:** GET

**Endpoint:** `/notifications`

**Purpose:** Retrieves notification records for display in the Flutter Web interface.

**Expected response fields:**
- Notification ID
- Title
- Message
- Notification type
- Status
- Scheduled time
- Sent time
- Read time

**Success response:** HTTP 200

**Possible errors:**
- HTTP 500 — Notification retrieval failed.

## 4. Standard Response Format

### Successful response

```json
{
    "message": "Operation completed successfully.",
    "data": {}
}
```

### Error response

```json
{
    "message": "The operation could not be completed.",
    "errors": {}
}
```

The `data` and `errors` fields contain operation-specific information.

## 5. Automation Trigger Mapping

| Trigger | API operation |
|---|---|
| Student submits application | Submit application |
| Requirements are incomplete | Check missing documents |
| Scheduled deadline check runs | Check scholarship deadlines |
| Staff assigns reviewer | Assign application reviewer |
| Application status changes | Update application status |
| User opens notification screen | Retrieve notifications |

## 6. HTTP Status Codes

| Status | Meaning |
|---|---|
| 200 | Successful operation |
| 201 | Resource successfully created |
| 404 | Resource not found |
| 409 | Operation conflicts with current state |
| 422 | Validation failed |
| 500 | Unexpected server error |

## 7. Integration Notes

- Laravel handles business rules and automation processing.
- Flutter Web sends requests and displays returned results.
- The backend is responsible for validating application requirements.
- Notification messages must not disclose confidential scholarship decisions or internal review information.
- Automated operations must record their outcomes and failures.
- Retry and recovery behavior will be documented separately.

## 8. Implementation Status

These endpoints define the planned Week 13 API contract. Their implementation and testing will be completed as part of the automation development process.