# Pipeline Architecture

```mermaid
flowchart LR
    A[CRM / POS Source 1] --> C[Raw Data Layer]
    B[CRM / POS Source 2] --> C[Raw Data Layer]

    C --> D[Data Profiling]
    D --> E[Transformation Layer]
    E --> F[Validation & Reconciliation]
    F --> G[Unified Sales Dataset]
    G --> H[Analytics-Ready Outputs]