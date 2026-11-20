<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Application;
use App\Models\Notification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class ApplicationStatusController extends Controller
{
    public function update(Request $request, Application $application): JsonResponse
    {
        // Only staff and reviewers can update application statuses.
        $user = $request->user();

        if (
            !$user->role ||
            !in_array($user->role->name, ['staff', 'reviewer'], true)
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Only staff and reviewers can update application statuses.',
            ], 403);
        }

        // Reviewers must be assigned to the specific application.
        if ($user->role->name === 'reviewer') {
            $isAssigned = DB::table('review_assignments')
                ->where('application_id', $application->id)
                ->where('reviewer_id', $user->id)
                ->whereIn('status', ['pending', 'in_progress'])
                ->exists();

            if (!$isAssigned) {
                return response()->json([
                    'success' => false,
                    'message' => 'You are not assigned to review this application.',
                ], 403);
            }
        }

        $validated = $request->validate([
            'status' => [
                'required',
                Rule::in([
                    'under_review',
                    'incomplete',
                    'for_correction',
                    'approved',
                    'rejected',
                ]),
            ],
            'reason' => ['nullable', 'string', 'max:1000'],
        ]);

        $oldStatus = $application->status;
        $newStatus = $validated['status'];

        if ($oldStatus === $newStatus) {
            return response()->json([
                'success' => false,
                'message' => 'The application already has this status.',
            ], 409);
        }
        // Enforce the review workflow for reviewers.
        if ($user->role->name === 'reviewer') {
            $allowedTransitions = [
                'submitted' => ['under_review'],
                'under_review' => [
                    'incomplete',
                    'for_correction',
                    'approved',
                    'rejected',
                ],
            ];

            $allowedNextStatuses = $allowedTransitions[$oldStatus] ?? [];

            if (!in_array($newStatus, $allowedNextStatuses, true)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid status transition. Reviewers must move submitted applications to under_review before making a review decision.',
                ], 409);
            }
        }

        DB::transaction(function () use (
            $application,
            $oldStatus,
            $newStatus,
            $validated
        ) {
            $application->update([
                'status' => $newStatus,
            ]);

            $application->statusHistories()->create([
                'old_status' => $oldStatus,
                'new_status' => $newStatus,
                'reason' => $validated['reason'] ?? null,
            ]);

            Notification::create([
                'user_id' => $application->user_id,
                'application_id' => $application->id,
                'type' => 'application_status_update',
                'title' => 'Application Status Updated',
                'message' => 'Your application status has been updated. Please sign in to view your application.',
                'channel' => 'in_app',
                'status' => 'pending',
                'scheduled_at' => now(),
            ]);
        });

        return response()->json([
            'success' => true,
            'message' => 'Application status updated successfully.',
            'application' => [
                'id' => $application->id,
                'status' => $newStatus,
            ],
        ]);
    }
}
