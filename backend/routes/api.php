<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ApplicationSubmissionController;
use App\Http\Controllers\Api\MissingDocumentReminderController;
use App\Http\Controllers\Api\ReviewerAssignmentController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::post(
    '/applications/{application}/submit',
    [ApplicationSubmissionController::class, 'submit']
);
Route::post(
    '/applications/{application}/check-missing-documents',
    [MissingDocumentReminderController::class, 'check']
);
Route::post(
    '/applications/{application}/assign-reviewer',
    [ReviewerAssignmentController::class, 'assign']
);

// Existing authentication routes — leave these untouched for now.
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::get('/user', function (Request $request) {
        return response()->json([
            'user' => $request->user()->load('role'),
        ]);
    });
});
