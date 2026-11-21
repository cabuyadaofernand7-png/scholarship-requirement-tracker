<?php

use App\Http\Controllers\Api\ApplicationDocumentController;
use App\Http\Controllers\Api\ApplicationDocumentDownloadController;
use App\Http\Controllers\Api\ApplicationStatusController;
use App\Http\Controllers\Api\ApplicationSubmissionController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\MissingDocumentReminderController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\ReviewerApplicationController;
use App\Http\Controllers\Api\ReviewerAssignmentController;
use App\Http\Controllers\Api\ScholarshipDeadlineController;
use App\Http\Controllers\Api\ScholarshipProgramController;
use App\Http\Controllers\Api\StaffApplicationController;
use App\Http\Controllers\Api\StudentApplicationController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Public authentication routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {

    // Student application browsing and creation.
    Route::get('/scholarship-programs', [ScholarshipProgramController::class, 'index']);
    Route::get('/applications', [StudentApplicationController::class, 'index']);
    Route::post('/applications', [StudentApplicationController::class, 'store']);

    // Staff and reviewer work queues.
    Route::get('/staff/applications', [StaffApplicationController::class, 'index']);
    Route::get('/staff/reviewers', [StaffApplicationController::class, 'reviewers']);
    Route::get('/reviewer/applications', [ReviewerApplicationController::class, 'index']);
    // Staff and assigned reviewers can download documents.
    Route::get(
        '/documents/{document}/download',
        [ApplicationDocumentDownloadController::class, 'download']
    );

    // Student application operations
    Route::post(
        '/applications/{application}/submit',
        [ApplicationSubmissionController::class, 'submit']
    );

    Route::post(
        '/applications/{application}/check-missing-documents',
        [MissingDocumentReminderController::class, 'check']
    );

    Route::post(
        '/applications/{application}/documents',
        [ApplicationDocumentController::class, 'upload']
    );

    // Staff and reviewer operations
    Route::post(
        '/applications/{application}/assign-reviewer',
        [ReviewerAssignmentController::class, 'assign']
    );

    Route::patch(
        '/applications/{application}/status',
        [ApplicationStatusController::class, 'update']
    );

    // Notifications
    Route::get('/notifications', [NotificationController::class, 'index']);

    // Staff automation
    Route::post(
        '/automation/check-deadlines',
        [ScholarshipDeadlineController::class, 'check']
    );

    // User authentication
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::get('/user', function (Request $request) {
        return response()->json([
            'user' => $request->user()->load('role'),
        ]);
    });
});
