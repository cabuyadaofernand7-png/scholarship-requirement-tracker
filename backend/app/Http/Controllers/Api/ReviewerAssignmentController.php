<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Application;
use App\Models\Notification;
use App\Models\ReviewAssignment;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReviewerAssignmentController extends Controller
{
    public function assign(Request $request, Application $application): JsonResponse
    {
        $validated = $request->validate([
            'reviewer_id' => ['required', 'integer', 'exists:users,id'],
        ]);

        if ($application->status !== 'submitted') {
            return response()->json([
                'success' => false,
                'message' => 'Only submitted applications can be assigned.',
            ], 409);
        }

        $reviewer = User::with('role')->findOrFail($validated['reviewer_id']);

        if (!$reviewer->role || $reviewer->role->name !== 'reviewer') {
            return response()->json([
                'success' => false,
                'message' => 'The selected user is not a reviewer.',
            ], 422);
        }

        $existingAssignment = ReviewAssignment::where(
            'application_id',
            $application->id
        )
            ->whereIn('status', ['pending', 'in_progress'])
            ->exists();

        if ($existingAssignment) {
            return response()->json([
                'success' => false,
                'message' => 'This application already has an active reviewer assignment.',
            ], 409);
        }

        $assignment = DB::transaction(function () use ($application, $reviewer) {
            $assignment = ReviewAssignment::create([
                'application_id' => $application->id,
                'reviewer_id' => $reviewer->id,
                'assigned_by' => null,
                'status' => 'pending',
                'assigned_at' => now(),
            ]);

            Notification::create([
                'user_id' => $reviewer->id,
                'application_id' => $application->id,
                'type' => 'review_assignment',
                'title' => 'New Application Assigned',
                'message' => 'A scholarship application has been assigned to you for review.',
                'channel' => 'in_app',
                'status' => 'pending',
                'scheduled_at' => now(),
            ]);

            return $assignment;
        });

        return response()->json([
            'success' => true,
            'message' => 'Application assigned successfully.',
            'assignment' => $assignment,
        ], 201);
    }
}
