# Week 13 – API Integration Evidence

## 1. Project Environment

| Component | Technology |
|---|---|
| Frontend | Flutter Web |
| Backend | Laravel |
| Database | MySQL |
| API Format | REST API with JSON responses |
| Local Frontend | Flutter Web running in Microsoft Edge |
| Local Backend | http://127.0.0.1:8000 |

## 2. API Integration Overview

The Flutter frontend communicates with the Laravel backend through HTTP requests. Laravel handles application data, document processing, validation, and database operations.

## 3. API Endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| GET | /api/notifications | Retrieve notifications |
| POST | /api/applications/{application}/documents | Upload an application document |
| POST | /api/applications/{application}/submit | Submit an application after checking requirements |

## 4. Document Upload Process

1. The user selects a document in the Flutter application.
2. Flutter reads the selected file.
3. Flutter sends the file and required document ID to Laravel.
4. Laravel validates the request.
5. Laravel stores the file and its metadata.
6. Laravel returns a success response or an appropriate error.

## 5. Validation and Error Handling

The backend must validate uploaded files, required document IDs, and application relationships. Failed requests should return appropriate HTTP status codes and understandable error messages.

## 6. Evidence Status

The endpoint list describes the intended integration. Record actual request results, response status codes, and screenshots in the relevant evidence section after testing. Do not treat planned or untested endpoints as successfully integrated.

## 7. Limitations

This evidence covers the Week 13 API integration scope. Authentication and authorization enhancements are outside this document's implementation scope.