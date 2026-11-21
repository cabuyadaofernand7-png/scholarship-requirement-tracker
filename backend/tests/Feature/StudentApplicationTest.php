<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class StudentApplicationTest extends TestCase
{
    use RefreshDatabase;

    private User $student;

    private int $studentRoleId;

    private int $programId;

    private int $applicationId;

    protected function setUp(): void
    {
        parent::setUp();

        $this->studentRoleId = DB::table('roles')->insertGetId([
            'name' => 'student',
            'description' => 'Student role',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->student = User::create([
            'name' => 'Test Student',
            'email' => 'student@example.com',
            'password' => Hash::make('password123'),
            'role_id' => $this->studentRoleId,
        ]);

        $this->programId = DB::table('scholarship_programs')->insertGetId([
            'name' => 'Test Scholarship',
            'description' => 'Scholarship for testing',
            'academic_year' => '2026-2027',
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->applicationId = DB::table('applications')->insertGetId([
            'user_id' => $this->student->id,
            'scholarship_program_id' => $this->programId,
            'application_number' => 'APP-TEST-001',
            'status' => 'draft',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_student_can_view_their_applications(): void
    {
        DB::table('required_documents')->insert([
            'scholarship_program_id' => $this->programId,
            'document_name' => 'Certificate of Enrollment',
            'description' => 'Proof of enrollment',
            'is_required' => true,
            'allowed_file_types' => 'pdf,jpg,jpeg,png',
            'max_file_size_kb' => 5120,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $response = $this->actingAs($this->student, 'sanctum')
            ->getJson('/api/applications');

        $response->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonPath('applications.0.id', $this->applicationId)
            ->assertJsonPath('applications.0.application_number', 'APP-TEST-001')
            ->assertJsonPath('applications.0.status', 'draft')
            ->assertJsonPath(
                'applications.0.scholarship_program.name',
                'Test Scholarship'
            )
            ->assertJsonPath(
                'applications.0.required_documents.0.document_name',
                'Certificate of Enrollment'
            )
            ->assertJsonPath(
                'applications.0.required_documents.0.uploaded',
                false
            );
    }

    public function test_student_cannot_view_another_students_applications(): void
    {
        $anotherStudent = User::create([
            'name' => 'Another Student',
            'email' => 'another@example.com',
            'password' => Hash::make('password123'),
            'role_id' => $this->studentRoleId,
        ]);

        DB::table('applications')->insert([
            'user_id' => $anotherStudent->id,
            'scholarship_program_id' => $this->programId,
            'application_number' => 'APP-OTHER-001',
            'status' => 'draft',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $response = $this->actingAs($this->student, 'sanctum')
            ->getJson('/api/applications');

        $response->assertOk()
            ->assertJsonCount(1, 'applications')
            ->assertJsonMissing([
                'application_number' => 'APP-OTHER-001',
            ]);
    }

    public function test_staff_cannot_view_the_student_application_list(): void
    {
        $staffRoleId = DB::table('roles')->insertGetId([
            'name' => 'staff',
            'description' => 'Staff role',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $staff = User::create([
            'name' => 'Test Staff',
            'email' => 'staff@example.com',
            'password' => Hash::make('password123'),
            'role_id' => $staffRoleId,
        ]);

        $response = $this->actingAs($staff, 'sanctum')
            ->getJson('/api/applications');

        $response->assertForbidden()
            ->assertJsonPath('success', false);
    }

    public function test_unauthenticated_user_cannot_view_applications(): void
    {
        $response = $this->getJson('/api/applications');

        $response->assertUnauthorized();
    }

    public function test_student_can_browse_only_programs_currently_accepting_applications(): void
    {
        DB::table('required_documents')->insert([
            'scholarship_program_id' => $this->programId,
            'document_name' => 'Transcript',
            'description' => 'Latest transcript',
            'is_required' => true,
            'allowed_file_types' => 'pdf',
            'max_file_size_kb' => 2048,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        DB::table('scholarship_programs')->insert([
            'name' => 'Closed Program',
            'description' => null,
            'academic_year' => null,
            'application_start_date' => null,
            'application_deadline' => now()->subDay()->toDateString(),
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        DB::table('scholarship_programs')->insert([
            'name' => 'Inactive Program',
            'description' => null,
            'academic_year' => null,
            'application_start_date' => null,
            'application_deadline' => null,
            'is_active' => false,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->actingAs($this->student, 'sanctum')
            ->getJson('/api/scholarship-programs')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonCount(1, 'programs')
            ->assertJsonPath('programs.0.id', $this->programId)
            ->assertJsonPath('programs.0.has_applied', true)
            ->assertJsonPath('programs.0.required_documents.0.document_name', 'Transcript');
    }

    public function test_student_can_create_a_draft_application_for_an_open_program(): void
    {
        DB::table('applications')->where('id', $this->applicationId)->delete();

        $this->actingAs($this->student, 'sanctum')
            ->postJson('/api/applications', ['scholarship_program_id' => $this->programId])
            ->assertCreated()
            ->assertJsonPath('success', true)
            ->assertJsonPath('application.status', 'draft')
            ->assertJsonPath('application.scholarship_program.id', $this->programId);

        $this->assertDatabaseHas('applications', [
            'user_id' => $this->student->id,
            'scholarship_program_id' => $this->programId,
            'status' => 'draft',
        ]);
    }

    public function test_student_cannot_create_a_second_application_for_same_program(): void
    {
        $this->actingAs($this->student, 'sanctum')
            ->postJson('/api/applications', ['scholarship_program_id' => $this->programId])
            ->assertStatus(409)
            ->assertJsonPath('success', false);

        $this->assertDatabaseCount('applications', 1);
    }

    public function test_non_student_cannot_browse_programs_or_create_applications(): void
    {
        $staffRoleId = DB::table('roles')->insertGetId([
            'name' => 'staff',
            'description' => 'Staff role',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $staff = User::create([
            'name' => 'Test Staff',
            'email' => 'batch-one-staff@example.com',
            'password' => Hash::make('password123'),
            'role_id' => $staffRoleId,
        ]);

        $this->actingAs($staff, 'sanctum')
            ->getJson('/api/scholarship-programs')
            ->assertForbidden();

        $this->actingAs($staff, 'sanctum')
            ->postJson('/api/applications', ['scholarship_program_id' => $this->programId])
            ->assertForbidden();
    }
}
