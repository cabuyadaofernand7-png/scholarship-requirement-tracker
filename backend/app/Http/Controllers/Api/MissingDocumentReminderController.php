<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Application;
use App\Models\Notification;
use Illuminate\Http\JsonResponse;

class MissingDocumentReminderController extends Controller
{
    public function check(Application $application): JsonResponse
    {
        $requiredDocuments = $application->scholarshipProgram
            ->requiredDocuments()
            ->where('is_required', true)
            ->get();

        $submittedDocumentIds = $application->documents()
            ->whereNotNull('submitted_at')
            ->whereIn('status', ['pending', 'accepted'])
            ->pluck('required_document_id')
            ->all();

        $missingDocuments = $requiredDocuments
            ->reject(fn ($document) => in_array(
                $document->id,
                $submittedDocumentIds
            ))
            ->pluck('document_name')
            ->values();

        if ($missingDocuments->isEmpty()) {
            return response()->json([
                'success' => true,
                'message' => 'No required documents are missing.',
                'missing_documents' => [],
            ]);
        }

        $reminderExists = Notification::where(
            'user_id',
            $application->user_id
        )
            ->where('application_id', $application->id)
            ->where('type', 'missing_document_reminder')
            ->whereIn('status', ['pending', 'sent'])
            ->exists();

        if (!$reminderExists) {
            Notification::create([
                'user_id' => $application->user_id,
                'application_id' => $application->id,
                'type' => 'missing_document_reminder',
                'title' => 'Missing Documents Reminder',
                'message' => 'Please review your application and submit the remaining required documents.',
                'channel' => 'in_app',
                'status' => 'pending',
                'scheduled_at' => now(),
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Missing required documents were found.',
            'missing_documents' => $missingDocuments,
            'reminder_created' => !$reminderExists,
        ]);
    }
}
