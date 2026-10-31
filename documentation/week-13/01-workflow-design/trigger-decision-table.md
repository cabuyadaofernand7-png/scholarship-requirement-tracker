# Week 13 – Automation Trigger Decision Table

## Purpose

This table identifies when each automation workflow should run, what conditions must be checked, and what action the system should perform.

| Automation Workflow | Trigger | Condition to Check | System Action |
|---|---|---|---|
| Missing-Document Reminder | Student submits documents or staff checks an application | One or more required documents are missing | Generate a reminder identifying the missing requirements. |
| Scholarship Deadline Alert | Scheduled deadline check | Scholarship program is active and its deadline is approaching | Generate a deadline notification. |
| Reviewer Assignment | Staff assigns a reviewer | Application is eligible for assignment and reviewer exists | Save the assignment and notify the reviewer. |
| Application Status Notification | Application status changes | Status change is valid | Record status history and notify the student. |
| Application Submission Check | Student attempts to submit | All required documents have been submitted | Allow submission and update application status. If requirements are incomplete, reject submission and show missing documents. |

## Failure Decisions

| Condition | Decision |
|---|---|
| Temporary connection or service failure | Retry within a configured limit. |
| Retry succeeds | Record the recovered success. |
| Invalid or missing record | Stop processing and record the failure. |
| Invalid submitted data | Return a validation error. |
| Retry limit reached | Record the failure and require human intervention. |

## Notes

- Actual retry limits and deadline reminder intervals must be configured and documented during implementation.
- The system must avoid duplicate notifications.
- Every automation outcome must be observable through structured logs.
- These decisions describe the planned Week 13 behavior; actual implementation results must be verified separately.