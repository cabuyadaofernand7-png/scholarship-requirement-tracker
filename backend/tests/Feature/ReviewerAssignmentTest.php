<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class ReviewerAssignmentTest extends TestCase
{
    use RefreshDatabase;

    private function createUserWithRole(string $role): User
    {
        DB::table('roles')->insertOrIgnore([
            'name' => $role,
            'description' => ucfirst($role) . ' account',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $roleId = DB::table('roles')
            ->where('name', $role)
            ->value('id');

        return User::create([
            'name' => ucfirst($role) . ' User',
            'email' => $role . '@example.com',
            'password' => Hash::make('Password123!'),
            'role_id' => $roleId,
        ]);
    }

    private function createTestApplication(
        User $student,
        string $status = 'submitted'
    ): int {
        $programId = DB::table('scholarship_programs')->insertGetId([
            'name' => 'Test Scholarship',
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return DB::table('applications')->insertGetId([
            'user_id' => $student->id,
            'scholarship_program_id' => $programId,
            'application_number' => 'APP-' . uniqid(),
            'status' => $status,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function createExistingAssignment(
        int $applicationId,
        User $reviewer,
        User $staff,
        string $status
    ): void {
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

    public function test_staff_can_assign_reviewer_to_submitted_application(): void
    {
        $staff = $this->createUserWithRole('staff');
        $reviewer = $this->createUserWithRole('reviewer');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student);

        $response = $this->actingAs($staff, 'sanctum')
            ->postJson("/api/applications/{$applicationId}/assign-reviewer", [
                'reviewer_id' => $reviewer->id,
            ]);

        $response->assertCreated();

        $this->assertDatabaseHas('review_assignments', [
            'application_id' => $applicationId,
            'reviewer_id' => $reviewer->id,
            'assigned_by' => $staff->id,
            'status' => 'pending',
        ]);

        $this->assertDatabaseHas('notifications', [
            'user_id' => $reviewer->id,
            'application_id' => $applicationId,
            'type' => 'review_assignment',
            'title' => 'New Application Assigned',
            'channel' => 'in_app',
            'status' => 'pending',
        ]);
    }

    public function test_student_cannot_assign_reviewer(): void
    {
        $student = $this->createUserWithRole('student');
        $reviewer = $this->createUserWithRole('reviewer');

        $applicationId = $this->createTestApplication($student);

        $response = $this->actingAs($student, 'sanctum')
            ->postJson("/api/applications/{$applicationId}/assign-reviewer", [
                'reviewer_id' => $reviewer->id,
            ]);

        $response->assertForbidden();
    }

    public function test_reviewer_cannot_assign_another_reviewer(): void
    {
        $reviewer = $this->createUserWithRole('reviewer');
        $anotherReviewer = User::create([
            'name' => 'Another Reviewer',
            'email' => 'another-reviewer@example.com',
            'password' => Hash::make('Password123!'),
            'role_id' => DB::table('roles')
                ->where('name', 'reviewer')
                ->value('id'),
        ]);

        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student);

        $response = $this->actingAs($reviewer, 'sanctum')
            ->postJson("/api/applications/{$applicationId}/assign-reviewer", [
                'reviewer_id' => $anotherReviewer->id,
            ]);

        $response->assertForbidden();
    }

    public function test_draft_application_cannot_be_assigned(): void
    {
        $staff = $this->createUserWithRole('staff');
        $reviewer = $this->createUserWithRole('reviewer');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student, 'draft');

        $response = $this->actingAs($staff, 'sanctum')
            ->postJson("/api/applications/{$applicationId}/assign-reviewer", [
                'reviewer_id' => $reviewer->id,
            ]);

        $response->assertStatus(409);
    }

    public function test_non_reviewer_user_cannot_be_assigned(): void
    {
        $staff = $this->createUserWithRole('staff');
        $student = $this->createUserWithRole('student');
        $anotherStudent = User::create([
            'name' => 'Another Student',
            'email' => 'another-student@example.com',
            'password' => Hash::make('Password123!'),
            'role_id' => DB::table('roles')
                ->where('name', 'student')
                ->value('id'),
        ]);

        $applicationId = $this->createTestApplication($student);

        $response = $this->actingAs($staff, 'sanctum')
            ->postJson("/api/applications/{$applicationId}/assign-reviewer", [
                'reviewer_id' => $anotherStudent->id,
            ]);

        $response->assertUnprocessable();
    }

    public function test_nonexistent_reviewer_is_rejected(): void
    {
        $staff = $this->createUserWithRole('staff');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student);

        $response = $this->actingAs($staff, 'sanctum')
            ->postJson("/api/applications/{$applicationId}/assign-reviewer", [
                'reviewer_id' => 99999,
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('reviewer_id');
    }

    public function test_pending_assignment_prevents_duplicate_assignment(): void
    {
        $staff = $this->createUserWithRole('staff');
        $reviewer = $this->createUserWithRole('reviewer');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student);

        $this->createExistingAssignment(
            $applicationId,
            $reviewer,
            $staff,
            'pending'
        );

        $response = $this->actingAs($staff, 'sanctum')
            ->postJson("/api/applications/{$applicationId}/assign-reviewer", [
                'reviewer_id' => $reviewer->id,
            ]);

        $response->assertStatus(409);
    }

    public function test_in_progress_assignment_prevents_duplicate_assignment(): void
    {
        $staff = $this->createUserWithRole('staff');
        $reviewer = $this->createUserWithRole('reviewer');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student);

        $this->createExistingAssignment(
            $applicationId,
            $reviewer,
            $staff,
            'in_progress'
        );

        $response = $this->actingAs($staff, 'sanctum')
            ->postJson("/api/applications/{$applicationId}/assign-reviewer", [
                'reviewer_id' => $reviewer->id,
            ]);

        $response->assertStatus(409);
    }
}
