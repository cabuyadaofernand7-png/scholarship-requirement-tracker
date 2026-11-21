<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Application;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class StaffApplicationController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        if (! $request->user()->role || $request->user()->role->name !== 'staff') {
            return response()->json([
                'success' => false,
                'message' => 'Only staff members can view all applications.',
            ], 403);
        }

        $applications = Application::with([
            'student:id,name,email',
            'scholarshipProgram:id,name,academic_year,application_deadline',
            'documents:id,application_id,required_document_id,original_filename,mime_type,file_size,status,feedback,submitted_at',
            'documents.requiredDocument:id,document_name',
            'reviewAssignments.reviewer:id,name',
        ])->latest()->get();

        return response()->json([
            'success' => true,
            'applications' => $applications,
        ]);
    }

    public function reviewers(Request $request): JsonResponse
    {
        if (! $request->user()->role || $request->user()->role->name !== 'staff') {
            return response()->json([
                'success' => false,
                'message' => 'Only staff members can view the reviewer list.',
            ], 403);
        }

        $reviewers = User::query()
            ->whereHas('role', fn ($query) => $query->where('name', 'reviewer'))
            ->orderBy('name')
            ->get(['id', 'name']);

        return response()->json([
            'success' => true,
            'reviewers' => $reviewers,
        ]);
    }
}
