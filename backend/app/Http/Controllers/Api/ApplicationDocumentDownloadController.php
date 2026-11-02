<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ApplicationDocument;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ApplicationDocumentDownloadController extends Controller
{
    public function download(Request $request, ApplicationDocument $document)
    {
        $user = $request->user();
        $user->load('role');

        // Only staff and reviewers can download documents.
        if (
            !$user->role ||
            !in_array($user->role->name, ['staff', 'reviewer'], true)
        ) {
            return response()->json([
                'success' => false,
                'message' => 'You are not authorized to download this document.',
            ], 403);
        }

        // Reviewers can access only applications assigned to them.
        if ($user->role->name === 'reviewer') {
            $application = $document->application;

            $isAssigned = $application &&
                $application->reviewAssignments()
                    ->where('reviewer_id', $user->id)
                    ->exists();

            if (!$isAssigned) {
                return response()->json([
                    'success' => false,
                    'message' => 'This application is not assigned to you.',
                ], 403);
            }
        }

        // Confirm that the file exists in private storage.
        if (
            !$document->file_path ||
            !Storage::disk('local')->exists($document->file_path)
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Document file not found.',
            ], 404);
        }

        return Storage::disk('local')->download(
            $document->file_path,
            $document->original_filename
        );
    }
}
