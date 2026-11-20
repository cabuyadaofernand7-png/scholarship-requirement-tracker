<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class ApplicationStatusTest extends TestCase
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

    private function createTestApplication(User $student, string $status = 'submitted'): int
    {
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

    public function test_staff_can_update_application_status(): void
    {
        $staff = $this->createUserWithRole('staff');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student);

        $response = $this->actingAs($staff, 'sanctum')
            ->patchJson("/api/applications/{$applicationId}/status", [
                'status' => 'under_review',
                'reason' => 'Application is ready for review.',
            ]);

        $response->assertOk()
            ->assertJsonPath('application.status', 'under_review');

        $this->assertDatabaseHas('applications', [
            'id' => $applicationId,
            'status' => 'under_review',
        ]);

        $this->assertDatabaseHas('application_status_histories', [
            'application_id' => $applicationId,
            'old_status' => 'submitted',
            'new_status' => 'under_review',
            'reason' => 'Application is ready for review.',
        ]);

        $this->assertDatabaseHas('notifications', [
            'user_id' => $student->id,
            'application_id' => $applicationId,
            'type' => 'application_status_update',
            'channel' => 'in_app',
            'status' => 'pending',
        ]);
    }

    public function test_reviewer_can_move_submitted_application_to_under_review(): void
    {
        $reviewer = $this->createUserWithRole('reviewer');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student);

        DB::table('review_assignments')->insert([
            'application_id' => $applicationId,
            'reviewer_id' => $reviewer->id,
            'assigned_by' => null,
            'status' => 'pending',
            'assigned_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $response = $this->actingAs($reviewer, 'sanctum')
            ->patchJson("/api/applications/{$applicationId}/status", [
                'status' => 'under_review',
            ]);

        $response->assertOk()
            ->assertJsonPath('application.status', 'under_review');

        $this->assertDatabaseHas('applications', [
            'id' => $applicationId,
            'status' => 'under_review',
        ]);
    }

    public function test_reviewer_cannot_approve_submitted_application_directly(): void
    {
        $reviewer = $this->createUserWithRole('reviewer');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student);

        DB::table('review_assignments')->insert([
            'application_id' => $applicationId,
            'reviewer_id' => $reviewer->id,
            'assigned_by' => null,
            'status' => 'pending',
            'assigned_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $response = $this->actingAs($reviewer, 'sanctum')
            ->patchJson("/api/applications/{$applicationId}/status", [
                'status' => 'approved',
            ]);

        $response->assertStatus(409);

        $this->assertDatabaseHas('applications', [
            'id' => $applicationId,
            'status' => 'submitted',
        ]);
    }

    public function test_reviewer_can_approve_application_under_review(): void
    {
        $reviewer = $this->createUserWithRole('reviewer');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student, 'under_review');

        DB::table('review_assignments')->insert([
            'application_id' => $applicationId,
            'reviewer_id' => $reviewer->id,
            'assigned_by' => null,
            'status' => 'in_progress',
            'assigned_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $response = $this->actingAs($reviewer, 'sanctum')
            ->patchJson("/api/applications/{$applicationId}/status", [
                'status' => 'approved',
            ]);

        $response->assertOk()
            ->assertJsonPath('application.status', 'approved');

        $this->assertDatabaseHas('applications', [
            'id' => $applicationId,
            'status' => 'approved',
        ]);
    }

    public function test_student_cannot_update_application_status(): void
    {
        $student = $this->createUserWithRole('student');
        $applicationId = $this->createTestApplication($student);

        $response = $this->actingAs($student, 'sanctum')
            ->patchJson("/api/applications/{$applicationId}/status", [
                'status' => 'approved',
            ]);

        $response->assertForbidden();
    }

    public function test_invalid_application_status_is_rejected(): void
    {
        $staff = $this->createUserWithRole('staff');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student);

        $response = $this->actingAs($staff, 'sanctum')
            ->patchJson("/api/applications/{$applicationId}/status", [
                'status' => 'waiting',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('status');
    }

    public function test_same_application_status_cannot_be_repeated(): void
    {
        $staff = $this->createUserWithRole('staff');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student, 'under_review');

        $response = $this->actingAs($staff, 'sanctum')
            ->patchJson("/api/applications/{$applicationId}/status", [
                'status' => 'under_review',
            ]);

        $response->assertStatus(409);
    }

    public function test_unauthenticated_user_cannot_update_application_status(): void
    {
        $student = $this->createUserWithRole('student');
        $applicationId = $this->createTestApplication($student);

        $response = $this->patchJson(
            "/api/applications/{$applicationId}/status",
            ['status' => 'approved']
        );

        $response->assertUnauthorized();
    }

    public function test_unassigned_reviewer_cannot_update_application_status(): void
    {
        $reviewer = $this->createUserWithRole('reviewer');
        $student = $this->createUserWithRole('student');

        $applicationId = $this->createTestApplication($student);

        $response = $this->actingAs($reviewer, 'sanctum')
            ->patchJson("/api/applications/{$applicationId}/status", [
                'status' => 'approved',
            ]);

        $response->assertForbidden();
    }
}
