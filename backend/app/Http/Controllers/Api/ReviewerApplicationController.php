<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Application;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ReviewerApplicationController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        if (! $user->role || $user->role->name !== 'reviewer') {
            return response()->json([
                'success' => false,
                'message' => 'Only reviewers can view the reviewer application list.',
            ], 403);
        }

        $applications = Application::query()
            ->whereHas('reviewAssignments', function ($query) use ($user) {
                $query->where('reviewer_id', $user->id)
                    ->whereIn('status', ['pending', 'in_progress']);
            })
            ->with([
                'student:id,name,email',
                'scholarshipProgram:id,name,academic_year,application_deadline',
                'documents:id,application_id,required_document_id,original_filename,mime_type,file_size,status,feedback,submitted_at',
                'documents.requiredDocument:id,document_name',
                'reviewAssignments' => fn ($query) => $query
                    ->where('reviewer_id', $user->id)
                    ->whereIn('status', ['pending', 'in_progress']),
            ])
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'applications' => $applications,
        ]);
    }
}
