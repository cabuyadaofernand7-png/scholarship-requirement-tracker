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
