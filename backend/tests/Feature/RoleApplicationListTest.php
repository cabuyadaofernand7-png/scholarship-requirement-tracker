<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class RoleApplicationListTest extends TestCase
{
    use RefreshDatabase;

    private function userFor(string $role, string $suffix): User
    {
        DB::table('roles')->insertOrIgnore([
            'name' => $role,
            'description' => ucfirst($role),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $roleId = DB::table('roles')->where('name', $role)->value('id');

        return User::create([
            'name' => ucfirst($role).' '.$suffix,
            'email' => $role.'-'.$suffix.'@example.com',
            'password' => Hash::make('Password123!'),
            'role_id' => $roleId,
        ]);
    }

    private function applicationFor(User $student, string $suffix): int
    {
        $programId = DB::table('scholarship_programs')->insertGetId([
            'name' => 'Scholarship '.$suffix,
            'academic_year' => '2026-2027',
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return DB::table('applications')->insertGetId([
            'user_id' => $student->id,
            'scholarship_program_id' => $programId,
            'application_number' => 'APP-'.$suffix,
            'status' => 'submitted',
            'submitted_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function assign(int $applicationId, User $reviewer, User $staff, string $status = 'pending'): void
    {
        DB::table('review_assignments')->insert([
            'application_id' => $applicationId,
            'reviewer_id' => $reviewer->id,
            'assigned_by' => $staff->id,
            'status' => $status,
            'assigned_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_staff_can_view_all_applications_and_eligible_reviewers(): void
    {
        $staff = $this->userFor('staff', 'one');
        $student = $this->userFor('student', 'one');
        $reviewer = $this->userFor('reviewer', 'one');
        $this->applicationFor($student, 'STAFF-001');

        $this->actingAs($staff, 'sanctum')
            ->getJson('/api/staff/applications')
            ->assertOk()
            ->assertJsonCount(1, 'applications')
            ->assertJsonPath('applications.0.student.name', 'Student one')
            ->assertJsonPath('applications.0.scholarship_program.name', 'Scholarship STAFF-001');

        $this->actingAs($staff, 'sanctum')
            ->getJson('/api/staff/reviewers')
            ->assertOk()
            ->assertJsonCount(1, 'reviewers')
            ->assertJsonPath('reviewers.0.id', $reviewer->id);
    }

    public function test_reviewer_sees_only_applications_with_their_active_assignments(): void
    {
        $staff = $this->userFor('staff', 'one');
        $studentA = $this->userFor('student', 'one');
        $studentB = $this->userFor('student', 'two');
        $reviewerA = $this->userFor('reviewer', 'one');
        $reviewerB = $this->userFor('reviewer', 'two');
        $applicationA = $this->applicationFor($studentA, 'REVIEW-001');
        $applicationB = $this->applicationFor($studentB, 'REVIEW-002');
        $this->assign($applicationA, $reviewerA, $staff);
        $this->assign($applicationB, $reviewerB, $staff);

        $this->actingAs($reviewerA, 'sanctum')
            ->getJson('/api/reviewer/applications')
            ->assertOk()
            ->assertJsonCount(1, 'applications')
            ->assertJsonPath('applications.0.id', $applicationA)
            ->assertJsonMissing(['application_number' => 'APP-REVIEW-002']);
    }

    public function test_students_cannot_access_staff_or_reviewer_application_lists(): void
    {
        $student = $this->userFor('student', 'one');

        $this->actingAs($student, 'sanctum')
            ->getJson('/api/staff/applications')
            ->assertForbidden();

        $this->actingAs($student, 'sanctum')
            ->getJson('/api/staff/reviewers')
            ->assertForbidden();

        $this->actingAs($student, 'sanctum')
            ->getJson('/api/reviewer/applications')
            ->assertForbidden();
    }
}
