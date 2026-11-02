<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Application;
use App\Models\Notification;
use App\Models\ScholarshipProgram;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;

class ScholarshipDeadlineController extends Controller
{
    public function check(Request $request): JsonResponse
    {
    // Only staff members can run deadline automation.
    $user = $request->user();

    if (!$user->role || $user->role->name !== 'staff') {
        return response()->json([
            'success' => false,
            'message' => 'Only staff members can run deadline automation.',
        ], 403);
    }
        $today = now()->startOfDay();
        $reminderDate = now()->addDays(7)->endOfDay();

        $programs = ScholarshipProgram::where('is_active', true)
            ->whereNotNull('application_deadline')
            ->whereDate('application_deadline', '>=', $today)
            ->whereDate('application_deadline', '<=', $reminderDate)
            ->get();

        $remindersCreated = 0;

        foreach ($programs as $program) {
            $applications = Application::where(
                'scholarship_program_id',
                $program->id
            )
                ->whereIn('status', ['draft', 'incomplete', 'for_correction'])
                ->get();

            foreach ($applications as $application) {
                $reminderExists = Notification::where(
                    'user_id',
                    $application->user_id
                )
                    ->where('application_id', $application->id)
                    ->where('type', 'scholarship_deadline_reminder')
                    ->whereDate('scheduled_at', $today)
                    ->exists();

                if ($reminderExists) {
                    continue;
                }

                Notification::create([
                    'user_id' => $application->user_id,
                    'application_id' => $application->id,
                    'type' => 'scholarship_deadline_reminder',
                    'title' => 'Scholarship Application Deadline',
                    'message' => 'The application deadline for '
                        . $program->name
                        . ' is approaching. Please review your application.',
                    'channel' => 'in_app',
                    'status' => 'pending',
                    'scheduled_at' => now(),
                ]);

                $remindersCreated++;
            }
        }

        Log::info('Scholarship deadline check completed.', [
            'programs_checked' => $programs->count(),
            'reminders_created' => $remindersCreated,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Scholarship deadline check completed.',
            'programs_checked' => $programs->count(),
            'reminders_created' => $remindersCreated,
        ]);
    }
}
