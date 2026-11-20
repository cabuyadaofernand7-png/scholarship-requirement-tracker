# Application Status API Test Results

## 1. Test Information

- **Project:** Scholarship Requirement Tracker
- **Week:** 15 - Testing and Hardening
- **Test File:** `tests/Feature/ApplicationStatusTest.php`
- **Testing Tool:** Laravel PHPUnit
- **Test Command:** `php artisan test --filter=ApplicationStatusTest`

## 2. Test Results

**Result: PASSED**

| Metric | Result |
|---|---:|
| Total tests | 9 |
| Passed | 9 |
| Failed | 0 |
| Assertions | 20 |
| Duration | 1.12 seconds |

## 3. Test Scenarios

| Test Scenario | Expected Result | Actual Result |
|---|---|---|
| Staff updates application status | 200 OK | Passed |
| Assigned reviewer moves submitted application to under_review | 200 OK | Passed |
| Reviewer cannot directly approve a submitted application | 409 Conflict | Passed |
| Reviewer approves an application under review | 200 OK | Passed |
| Student cannot update application status | 403 Forbidden | Passed |
| Invalid application status is rejected | 422 Validation Error | Passed |
| Repeated application status is rejected | 409 Conflict | Passed |
| Unauthenticated user cannot update status | 401 Unauthorized | Passed |
| Unassigned reviewer cannot update application status | 403 Forbidden | Passed |

## 4. Workflow Rules

The controller permits reviewers to use these transitions:

1. `submitted` -> `under_review`
2. `under_review` -> `incomplete`
3. `under_review` -> `for_correction`
4. `under_review` -> `approved`
5. `under_review` -> `rejected`

The current tests directly verify that a reviewer can move an application from `submitted` to `under_review`, cannot directly approve a `submitted` application, and can approve an application already under review.

The other permitted outcomes are implemented in the controller but have not yet been individually tested.

## 5. Security and Reliability Observations

- Only staff and reviewers can update application statuses.
- Reviewers must have an active assignment (`pending` or `in_progress`) for the application.
- Students and unassigned reviewers are denied access.
- Invalid status values are rejected through request validation.
- Repeated status updates are rejected.
- Successful updates create status history records and in-app notifications for the application owner.
- Status transition restrictions prevent reviewers from making final decisions before moving an application into review.

## 6. Conclusion

All 9 application status API tests passed, with 20 assertions and no failures. The tests verified role-based authorization, reviewer assignment checks, status validation, workflow transition rules, status history creation, and notification creation.

## 7. Evidence

- Test command: `php artisan test --filter=ApplicationStatusTest`
- Test result: 9 passed, 20 assertions
- Verified screenshot: `screenshots/W15-26-application-status-workflow-tests-passed.png`





