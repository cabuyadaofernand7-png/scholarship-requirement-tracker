<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Application;
use App\Models\ApplicationDocument;
use App\Models\RequiredDocument;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ApplicationDocumentController extends Controller
{
    public function upload(Request $request, Application $application)
    {
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
                'mimes:' . implode(',', $allowedExtensions),
                'max:' . $requiredDocument->max_file_size_kb,
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
        $filePath = $file->store(
            'application-documents',
            'public'
        );

        // Remove the previous file when replacing an upload.
        if (
            $existingDocument &&
            $existingDocument->file_path
        ) {
            Storage::disk('public')->delete(
                $existingDocument->file_path
            );
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
