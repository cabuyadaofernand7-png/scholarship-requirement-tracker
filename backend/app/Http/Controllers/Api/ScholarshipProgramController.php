<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ScholarshipProgram;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

class ScholarshipProgramController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        if (! $user->role || $user->role->name !== 'student') {
            return response()->json([
                'success' => false,
                'message' => 'Only students can browse scholarship programs.',
            ], 403);
        }

        $today = Carbon::today();
        $programs = ScholarshipProgram::query()
            ->with('requiredDocuments')
            ->where('is_active', true)
            ->where(function ($query) use ($today) {
                $query->whereNull('application_start_date')
                    ->orWhereDate('application_start_date', '<=', $today);
            })
            ->where(function ($query) use ($today) {
                $query->whereNull('application_deadline')
                    ->orWhereDate('application_deadline', '>=', $today);
            })
            ->orderBy('application_deadline')
            ->get()
            ->map(function (ScholarshipProgram $program) use ($user) {
                $existingApplication = $program->applications()
                    ->where('user_id', $user->id)
                    ->first(['id', 'application_number', 'status']);

                return [
                    'id' => $program->id,
                    'name' => $program->name,
                    'description' => $program->description,
                    'academic_year' => $program->academic_year,
                    'application_start_date' => $program->application_start_date,
                    'application_deadline' => $program->application_deadline,
                    'has_applied' => $existingApplication !== null,
                    'application' => $existingApplication ? [
                        'id' => $existingApplication->id,
                        'application_number' => $existingApplication->application_number,
                        'status' => $existingApplication->status,
                    ] : null,
                    'required_documents' => $program->requiredDocuments->map(
                        fn ($document) => [
                            'id' => $document->id,
                            'document_name' => $document->document_name,
                            'description' => $document->description,
                            'is_required' => $document->is_required,
                            'allowed_file_types' => $document->allowed_file_types,
                            'max_file_size_kb' => $document->max_file_size_kb,
                        ]
                    )->values(),
                ];
            });

        return response()->json([
            'success' => true,
            'programs' => $programs,
        ]);
    }
}
