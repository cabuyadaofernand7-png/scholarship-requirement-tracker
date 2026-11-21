<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Application;
use App\Models\ScholarshipProgram;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class StudentApplicationController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $user = $request->user();

        if (! $user->role || $user->role->name !== 'student') {
            return response()->json([
                'success' => false,
                'message' => 'Only students can create applications.',
            ], 403);
        }

        $validated = $request->validate([
            'scholarship_program_id' => ['required', 'integer', 'exists:scholarship_programs,id'],
        ]);

        $today = Carbon::today();

        // Locking the program row serializes concurrent creation attempts for
        // that program on databases that support row-level locks.
        $result = DB::transaction(function () use ($validated, $user, $today) {
            $program = ScholarshipProgram::query()
                ->whereKey($validated['scholarship_program_id'])
                ->lockForUpdate()
                ->first();

            if (! $program || ! $program->is_active ||
                ($program->application_start_date && $program->application_start_date->gt($today)) ||
                ($program->application_deadline && $program->application_deadline->lt($today))) {
                return ['error' => 'This scholarship program is not currently accepting applications.', 'status' => 422];
            }

            $alreadyApplied = Application::where('user_id', $user->id)
                ->where('scholarship_program_id', $program->id)
                ->exists();

            if ($alreadyApplied) {
                return ['error' => 'You already have an application for this scholarship program.', 'status' => 409];
            }

            $application = Application::create([
                'user_id' => $user->id,
                'scholarship_program_id' => $program->id,
                'application_number' => 'APP-'.now()->format('Ymd').'-'.Str::upper((string) Str::uuid()),
                'status' => 'draft',
            ]);

            return ['application' => $application->load('scholarshipProgram')];
        });

        if (isset($result['error'])) {
            return response()->json([
                'success' => false,
                'message' => $result['error'],
            ], $result['status']);
        }

        $application = $result['application'];

        return response()->json([
            'success' => true,
            'message' => 'Application created as a draft.',
            'application' => [
                'id' => $application->id,
                'application_number' => $application->application_number,
                'status' => $application->status,
                'scholarship_program' => [
                    'id' => $application->scholarshipProgram->id,
                    'name' => $application->scholarshipProgram->name,
                    'academic_year' => $application->scholarshipProgram->academic_year,
                    'application_deadline' => $application->scholarshipProgram->application_deadline,
                ],
            ],
        ], 201);
    }

    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        // Only students can access their application list.
        if (! $user->role || $user->role->name !== 'student') {
            return response()->json([
                'success' => false,
                'message' => 'Only students can view this application list.',
            ], 403);
        }

        // Retrieve only the authenticated student's applications.
        $applications = Application::with([
            'scholarshipProgram.requiredDocuments',
            'documents.requiredDocument',
        ])
            ->where('user_id', $user->id)
            ->latest()
            ->get();

        $result = $applications->map(function ($application) {
            $program = $application->scholarshipProgram;

            $requiredDocuments = $program
                ? $program->requiredDocuments->map(
                    function ($requiredDocument) use ($application) {
                        $uploadedDocument = $application->documents
                            ->firstWhere(
                                'required_document_id',
                                $requiredDocument->id
                            );

                        return [
                            'id' => $requiredDocument->id,
                            'document_name' => $requiredDocument->document_name,
                            'description' => $requiredDocument->description,
                            'is_required' => $requiredDocument->is_required,
                            'allowed_file_types' => $requiredDocument->allowed_file_types,
                            'max_file_size_kb' => $requiredDocument->max_file_size_kb,
                            'uploaded' => $uploadedDocument !== null,
                            'document' => $uploadedDocument ? [
                                'id' => $uploadedDocument->id,
                                'original_filename' => $uploadedDocument->original_filename,
                                'status' => $uploadedDocument->status,
                                'feedback' => $uploadedDocument->feedback,
                                'submitted_at' => $uploadedDocument->submitted_at,
                            ] : null,
                        ];
                    }
                )->values()
                : collect();

            return [
                'id' => $application->id,
                'application_number' => $application->application_number,
                'status' => $application->status,
                'remarks' => $application->remarks,
                'submitted_at' => $application->submitted_at,
                'scholarship_program' => $program ? [
                    'id' => $program->id,
                    'name' => $program->name,
                    'academic_year' => $program->academic_year,
                    'application_deadline' => $program->application_deadline,
                ] : null,
                'required_documents' => $requiredDocuments,
            ];
        });

        return response()->json([
            'success' => true,
            'applications' => $result,
        ]);
    }
}
