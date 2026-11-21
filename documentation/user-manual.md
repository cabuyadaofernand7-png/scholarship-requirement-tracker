# Scholarship Requirement Tracker — User Manual

This manual explains how to use the Flutter Web application as a student, staff member, or reviewer. The screens and controls described here reflect the current project build.

## 1. Before you begin

- Open the web app using the URL provided by the person running the local project.
- Ask the project administrator for an account with the correct role. The app does not currently provide a sign-up or password-reset screen, and the database seeder creates role records only.
- For local development, start the Laravel API at `http://127.0.0.1:8000` and launch the Flutter Web client. Setup instructions are in the repository [README](../README.md).
- Use a supported desktop browser such as Microsoft Edge or Chrome. The app adapts to narrower windows, but the recorded checks do not cover every browser or physical mobile device.
- Prepare clear, readable files that meet each program's displayed document type and file-size requirements.

## 2. Sign in and sign out

1. Open the app's sign-in page.
2. Enter your account email and password. Use the eye icon to show or hide the password while entering it.
3. Select **Login**. The app opens the dashboard for your account role:
   - **Student** — Student Dashboard
   - **Staff** — Staff Dashboard
   - **Reviewer** — Reviewer Dashboard
4. To leave your session, select the logout icon in the dashboard app bar. Return to the sign-in page before another user signs in.

An invalid login displays an error on the sign-in page. An account with an unsupported role cannot continue to a dashboard; contact the project administrator if the role is incorrect.

## 3. Student guide

### View applications and notifications

The Student Dashboard shows your applications and summary counts for applications, uploaded required documents, and missing required documents. Select an application to open its details and document checklist. Use the refresh control or pull down on the page to reload the list. If the list cannot load, check the connection and select **Retry**.

Select the notifications bell to open the notification panel. It may show a loading indicator, a list of messages, **No notifications yet**, or an error if the API is unavailable.

### Create a scholarship application

1. From the Student Dashboard, select **New Application**.
2. Review each available program's academic year, description, application deadline, and document checklist. Required documents are labeled **(required)**; others are labeled **(optional)**. The program may also show allowed file types and a maximum file size.
3. Select **Create draft application** for the program you want. The app creates a draft and returns you to the dashboard. A program already applied to is marked **Already applied** and cannot be selected again for another application.
4. Open the new application from the dashboard to see its application number, status, and document checklist.

If no programs appear, no program is currently accepting applications. Use the refresh icon to reload the list or contact the program administrator about availability.

### Upload or replace documents and submit

1. Open an application with status **DRAFT**.
2. In **Document Checklist**, select **Upload** beside a requirement and choose a file in the file picker. Wait for the success message before leaving the page. The selected filename appears in the checklist.
3. Repeat for each required document. Optional items can be uploaded when relevant; the **Submit Application** button becomes available once all required items are uploaded.
4. Review the checklist and select **Submit Application**. Wait for the confirmation message. The application returns to the dashboard with its updated status.

An upload error or failed submission appears as a message. Confirm that the file meets the requirement's displayed type and size limits, that the API is reachable, and retry. Do not assume an upload completed unless the success message and filename are shown.

### Respond to a correction request

When an application is **FOR CORRECTION**, open it and read the document status and any reviewer feedback shown in the checklist. Select **Change** beside the relevant uploaded document, choose the corrected file, and wait for the upload confirmation. After all required documents are ready, select **Submit Application** again. The app does not allow document uploads while an application is in other non-editable statuses.

## 4. Staff guide

The Staff Dashboard lists applications with their application number, status, student, program, and any active reviewer assignment.

### Assign a reviewer

1. Find an application in **SUBMITTED** status without an active reviewer assignment.
2. Select a reviewer from **Select reviewer**.
3. Select **Assign reviewer** and wait for **Reviewer assigned successfully**.
4. Use **Refresh applications** to reload the queue and verify the assignment appears.

Reviewer assignment is available only for submitted applications that do not already have an active assignment. If the reviewer list is unavailable or empty, refresh and contact the project administrator if it remains unavailable. The staff screen supports queue review and assignment; it does not provide the reviewer status-update controls.

## 5. Reviewer guide

The Reviewer Dashboard shows only applications currently assigned to your account. Each application card displays the student, program, current status, and uploaded documents.

### Review documents

1. Open an assigned application on the Reviewer Dashboard.
2. Review the document names, requirement names, document statuses, and any feedback shown.
3. Select the download icon beside a document to save a copy. Handle downloaded files as private student information and store them only in an approved location.

If a download fails, check the displayed error and connection, then retry. Access is limited to assigned work; ask staff to check the assignment if the application is missing.

### Update the application status

1. Review the application and its documents.
2. In **Next review status**, choose an available status.
3. Select **Update status** and wait for the confirmation. The assigned queue reloads after a successful update.

The current screen offers these transitions:

| Current status | Available next status options |
|---|---|
| SUBMITTED | UNDER REVIEW |
| UNDER REVIEW | INCOMPLETE, FOR CORRECTION, APPROVED, REJECTED |

If no status choices appear, the application is not in a state with a next action in this screen. Follow the institution's review process before changing status. The reviewer screen does not currently provide a separate free-text decision form; document feedback is displayed when present.

## 6. Common problems

| Problem | What to do |
|---|---|
| Login fails | Re-enter the email and password. Contact the administrator for account or role help; the app has no password-reset page. |
| Dashboard or list does not load | Check that the API is running and reachable, then use **Retry** or refresh. |
| No programs are listed | Refresh. The program list includes only programs currently accepting applications. |
| File picker closes or file is rejected | Select a supported file and confirm its size and type meet the program's displayed limits. Verify success before continuing. |
| Submit is unavailable | Upload every required document first. Optional documents do not satisfy missing required items. |
| An application or reviewer assignment is missing | Refresh. Confirm the signed-in role and, for reviewers, ask staff to verify an active assignment. |
| Download or status update fails | Read the error, check the API connection, and retry. Ask staff to verify authorization if the problem persists. |

## 7. Privacy and safe use

- Use controlled or approved accounts and data for demonstrations.
- Do not share passwords, access tokens, or student documents through public messages or unapproved storage.
- Sign out when finished on a shared computer.
- This application is an academic prototype. Its local file storage, local API configuration, and operational controls are not a production service. Do not use it for real scholarship decisions or sensitive live records without institutional approval and a separate security and operational review.

## 8. Related references

- [Project setup and technical README](../README.md)
- [Week 17 UAT scenarios and evidence](week-17/README.md)
- [Week 18 final examination portfolio](week-18/README.md)
