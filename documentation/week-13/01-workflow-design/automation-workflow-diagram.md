      # Week 13 – Automation Workflow Diagram

This diagram shows the bounded scholarship application workflow, including document checking, submission, reminder generation, and notification delivery.

```mermaid
flowchart TD
    A[Student opens application] --> B[View required documents]
    B --> C[Upload required documents]
    C --> D[Backend validates uploaded file]
    D --> E{Upload valid?}
    E -- No --> F[Return validation error]
    F --> C
    E -- Yes --> G[Store file and document record]
    G --> H[Check required documents]
    H --> I{Any documents missing?}
    I -- Yes --> J[Create missing-document reminder]
    J --> K[Check for duplicate reminder]
    K --> L[Record notification]
    L --> M[Show reminder result]
    I -- No --> N[Student submits application]
    M --> B
    N --> O[Backend validates requirements]
    O --> P{All required documents present?}
    P -- No --> Q[Reject submission and show missing documents]
    Q --> B
    P -- Yes --> R[Update application status]
    R --> S[Record status history]
    S --> T[Generate notification]
    T --> U[Attempt notification delivery]
    U --> V{Delivery successful?}
    V -- Yes --> W[Record successful delivery]
    V -- No --> X{Temporary or permanent failure?}
    X -- Temporary --> Y[Schedule bounded retry]
    Y --> U
    X -- Permanent --> Z[Record failure for human review]
```