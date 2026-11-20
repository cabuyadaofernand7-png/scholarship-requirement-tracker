# Week 13 – Automation Workflow Boundary and Trigger Decision

## 1. Purpose

This document defines the boundaries, triggers, and safety conditions of the Scholarship Requirement Tracker automation workflows.

## 2. Automation Workflows

| Workflow | Trigger | Expected Action |
|---|---|---|
| Missing-Document Reminder | Student submits documents or staff checks an application | Identify missing required documents and generate a reminder. |
| Scholarship Deadline Alert | Scheduled deadline check | Identify active scholarship programs with approaching deadlines and generate alerts. |
| Reviewer Assignment | Staff assigns a reviewer | Record the assignment and generate a reviewer notification. |
| Application Status Notification | Authorized application status change | Record the status history and notify the student. |
| Application Submission Check | Student attempts to submit an application | Check required documents and prevent submission if requirements are incomplete. |

## 3. Automation Boundaries

The automation must:

- Process only records belonging to the Scholarship Requirement Tracker.
- Use existing application and scholarship requirement records.
- Validate required information before performing an action.
- Avoid generating duplicate reminders for the same event.
- Record the outcome of each automation attempt.
- Avoid including confidential review comments in notifications.
- Stop and report errors that cannot be safely recovered.

## 4. Retry and Recovery Decisions

| Situation | System Decision |
|---|---|
| Temporary service or connection failure | Retry within a limited number of attempts. |
| Retry succeeds | Record the recovered success. |
| Required record does not exist | Stop processing and record the failure. |
| Invalid application or document data | Reject the request and report the validation error. |
| All retry attempts fail | Mark the operation as failed and require human intervention. |

## 5. Trigger Decisions

- Document reminders use application and document events.
- Deadline alerts use a scheduled check.
- Reviewer notifications are triggered by reviewer assignment.
- Student status notifications are triggered by an application status change.
- Submission validation runs when a student attempts to submit an application.

## 6. Safety and Observability

Each automation operation should have a recorded outcome: successful, recovered after retry, or failed.

Logs should include relevant identifiers, event type, attempt number, and outcome. Passwords, access tokens, private information, and confidential review comments must not be included.

## 7. Scope Limitations
   Scope of the Project
   The Scholarship Requirement Tracker is a web-based application designed to help students monitor their scholarship applications, track required documents, and receive notifications about missing requirements and approaching deadlines.

The system includes the following functions:
1. User Account Management – Allows students and authorized staff to access the system according to their assigned roles.
2. Scholarship Management – Allows authorized staff to manage scholarship programs, requirements, and application deadlines.
3. Document Submission – Allows students to upload and manage the documents required for their scholarship applications.
4. Requirement Tracking – Displays submitted, missing, and incomplete documents.
5. Application Monitoring – Allows students to monitor their application status.
6. Automated Notifications – Generates reminders for missing documents, approaching deadlines, reviewer assignments, and application status changes.
7. Application Validation – Checks whether all required documents are complete before allowing an application to be submitted.
8. Application Review – Supports reviewer assignment and application status updates by authorized staff.

Out of Scope of the Project
   The following functions are excluded from the current development of the Scholarship Requirement Tracker:
1. Scholarship Payment Processing – The system will not process scholarship allowances, tuition payments, or financial transactions.
2. Automatic Scholarship Approval – The system will not automatically approve or reject scholarship applications. Final decisions remain with authorized personnel.
3. External Institution Integration – The system will not automatically retrieve student records from university databases or external institutions.
4. Third-Party Scholarship Applications – The system will not submit applications to external scholarship organizations or government portals.
5. Physical Document Processing – The system will not handle the physical printing, notarization, or delivery of original documents.
6. SMS Notifications – The system will not send reminders through SMS. Notifications will use the supported in-app and email channels.
7. Native Mobile Application – The project focuses on a web-based application rather than separate Android or iOS applications.

## 8. Expected Outcome

The automation workflows should be bounded, observable, and safe. Temporary failures should have a controlled recovery path, while permanent failures should be recorded and routed for human action.