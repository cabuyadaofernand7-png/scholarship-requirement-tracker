<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Application;
use App\Models\ApplicationDocument;
use App\Models\RequiredDocument;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use League\Flysystem\FilesystemException;

class ApplicationDocumentController extends Controller
{
    public function upload(Request $request, Application $application)
    {
        // Only students can upload their own application documents.
        $user = $request->user();

        if (
            ! $user->role ||
            $user->role->name !== 'student' ||
            (int) $application->user_id !== (int) $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'You are not authorized to upload documents for this application.',
            ], 403);
        }

        // Students may upload documents only while preparing or correcting an application.
        if (! in_array($application->status, ['draft', 'for_correction'], true)) {
            return response()->json([
                'success' => false,
                'message' => 'Documents can only be uploaded for draft applications or applications requiring correction.',
            ], 409);
        }

        // Validate the required document ID and uploaded file.
        $validated = $request->validate([
            'required_document_id' => [
                'required',
                'exists:required_documents,id',
            ],
            'file' => [
                'required',
                'file',
            ],
        ]);

        // Find the required document.
        $requiredDocument = RequiredDocument::findOrFail(
            $validated['required_document_id']
        );

        // Make sure the document belongs to this scholarship program.
        if (
            (int) $requiredDocument->scholarship_program_id !==
            (int) $application->scholarship_program_id
        ) {
            return response()->json([
                'message' => 'This document is not required for this scholarship application.',
            ], 422);
        }

        // Get allowed file extensions from the database.
        $allowedExtensions = array_filter(
            array_map(
                'trim',
                explode(',', $requiredDocument->allowed_file_types)
            )
        );

        // Validate file type and maximum file size.
        $request->validate([
            'file' => [
                'required',
                'file',
                'mimes:'.implode(',', $allowedExtensions),
                'max:'.$requiredDocument->max_file_size_kb,
            ],
        ]);

        $file = $request->file('file');

        // Check whether this document was previously uploaded.
        $existingDocument = ApplicationDocument::where(
            'application_id',
            $application->id
        )->where(
            'required_document_id',
            $requiredDocument->id
        )->first();

        // Store the new file.
        try {
            $filePath = $file->store(
                'application-documents',
                'local'
            );
        } catch (FilesystemException $exception) {
            report($exception);

            return response()->json([
                'success' => false,
                'message' => 'Document storage is temporarily unavailable. Please try again later.',
            ], 503);
        }

        // Stop if the file could not be stored.
        if (! $filePath) {
            return response()->json([
                'success' => false,
                'message' => 'Document storage is temporarily unavailable. Please try again later.',
            ], 503);
        }

        // Save the document information.
        $document = ApplicationDocument::updateOrCreate(
            [
                'application_id' => $application->id,
                'required_document_id' => $requiredDocument->id,
            ],
            [
                'file_path' => $filePath,
                'original_filename' => $file->getClientOriginalName(),
                'mime_type' => $file->getMimeType(),
                'file_size' => $file->getSize(),
                'status' => 'pending',
                'feedback' => null,
                'submitted_at' => now(),
                'reviewed_at' => null,
                'reviewed_by' => null,
            ]
        );
        // Remove the previous file only after the replacement is saved.
        if (
            $existingDocument &&
            $existingDocument->file_path &&
            $existingDocument->file_path !== $filePath
        ) {
            Storage::disk('local')->delete(
                $existingDocument->file_path
            );
        }

        return response()->json([
            'message' => 'Document uploaded successfully.',
            'document' => [
                'id' => $document->id,
                'application_id' => $document->application_id,
                'required_document_id' => $document->required_document_id,
                'original_filename' => $document->original_filename,
                'mime_type' => $document->mime_type,
                'file_size' => $document->file_size,
                'status' => $document->status,
                'submitted_at' => $document->submitted_at,
            ],
        ], 201);
    }
}
