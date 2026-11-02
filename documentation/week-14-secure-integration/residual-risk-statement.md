# Week 14 – Residual-Risk Statement

## 1. Introduction

The Scholarship Requirement Tracker implements authentication, role-based access restrictions, protected API routes, private document storage, and token revocation through Laravel Sanctum.

Although the completed tests provide evidence that these controls work in the local development environment, some risks remain.

## 2. Identified Residual Risks

| Risk | Description | Recommended action |
|---|---|---|
| Unencrypted local API connection | The current development API uses HTTP instead of HTTPS. | Configure HTTPS before deployment. |
| Localhost API address | The Flutter application currently connects to `127.0.0.1`, which is unsuitable for other users accessing a deployed application. | Configure the correct deployed backend URL. |
| In-memory token storage | The authentication token is cleared when the application is refreshed or logged out, but additional session-security review is needed for deployment. | Review the authentication and session-management approach before production use. |
| File upload security | File extension and size validation are implemented, but additional file-content and malware checks may be needed. | Consider stronger file validation and malware scanning. |
| Reviewer permissions | Staff and reviewers currently share some application status-update permissions. | Define and implement more specific reviewer permissions. |
| Deadline automation | The deadline reminder endpoint is protected, but scheduled automatic execution has not been established. | Configure and test a scheduler before deployment. |
| Testing limitations | Automated download tests use SQLite and fake storage. | Perform additional testing with the intended deployment database and storage environment. |

## 3. Overall Risk Assessment

The project has implemented important initial security controls. However, the remaining risks show that additional configuration, testing, and access-control improvements are necessary before deployment.

The current implementation is intended for academic demonstration and local development. It should not be considered production-ready.

## 4. Conclusion

The Week 14 security work improved the protection of authentication tokens, API endpoints, and uploaded documents. Nevertheless, security must continue to be reviewed and tested as the system develops.

**Status:** Residual risks identified; recommended improvements documented.