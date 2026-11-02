<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Application;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class ApplicationSubmissionController extends Controller
{
    public function submit(Request $request, Application $application): JsonResponse
    {// Only students can submit their own applications.
     $user = $request->user();

     if (
         !$user->role ||
         $user->role->name !== 'student' ||
         (int) $application->user_id !== (int) $user->id
     ) {
         return response()->json([
             'success' => false,
             'message' => 'You are not authorized to submit this application.',
         ], 403);
     }
        if ($application->status !== 'draft') {
            return response()->json([
                'success' => false,
                'message' => 'Only draft applications can be submitted.',
            ], 409);
        }

        $requiredDocuments = $application->scholarshipProgram
            ->requiredDocuments()
            ->where('is_required', true)
            ->get();

        $submittedDocuments = $application->documents()
            ->whereNotNull('submitted_at')
            ->whereIn('status', ['pending', 'accepted'])
            ->pluck('required_document_id')
            ->all();

        $missingDocuments = $requiredDocuments
            ->reject(fn ($document) => in_array(
                $document->id,
                $submittedDocuments
            ))
            ->pluck('document_name')
            ->values();

        if ($missingDocuments->isNotEmpty()) {
            return response()->json([
                'success' => false,
                'message' => 'The application cannot be submitted because required documents are missing.',
                'missing_documents' => $missingDocuments,
            ], 422);
        }

        DB::transaction(function () use ($application) {
            $application->update([
                'status' => 'submitted',
                'submitted_at' => now(),
            ]);

            $application->statusHistories()->create([
                'old_status' => 'draft',
                'new_status' => 'submitted',
                'reason' => 'Application submitted.',
            ]);
        });

        return response()->json([
            'success' => true,
            'message' => 'Application submitted successfully.',
            'application' => [
                'id' => $application->id,
                'application_number' => $application->application_number,
                'status' => 'submitted',
                'submitted_at' => $application->submitted_at,
            ],
        ], 200);
    }
}
