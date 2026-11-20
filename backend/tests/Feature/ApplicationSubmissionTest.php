<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class ApplicationSubmissionTest extends TestCase
{
    use RefreshDatabase;

    private User $student;
    private int $programId;
    private int $applicationId;

    protected function setUp(): void
    {
        parent::setUp();

        $studentRoleId = DB::table('roles')->insertGetId([
            'name' => 'student',
            'description' => 'Student role',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->student = User::create([
            'name' => 'Test Student',
            'email' => 'student@example.com',
            'password' => Hash::make('password123'),
            'role_id' => $studentRoleId,
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

    private function createRequiredDocument(
        string $name,
        bool $isRequired = true
    ): int {
        return DB::table('required_documents')->insertGetId([
            'scholarship_program_id' => $this->programId,
            'document_name' => $name,
            'description' => 'Document for testing',
            'is_required' => $isRequired,
            'allowed_file_types' => 'pdf,jpg,jpeg,png',
            'max_file_size_kb' => 5120,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function createSubmittedDocument(int $requiredDocumentId): void
    {
        DB::table('application_documents')->insert([
            'application_id' => $this->applicationId,
            'required_document_id' => $requiredDocumentId,
            'file_path' => 'application-documents/test-document.pdf',
            'original_filename' => 'test-document.pdf',
            'mime_type' => 'application/pdf',
            'file_size' => 1024,
            'status' => 'pending',
            'submitted_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_student_can_submit_application_with_all_required_documents(): void
    {
        $documentOne = $this->createRequiredDocument('Certificate of Enrollment');
        $documentTwo = $this->createRequiredDocument('Grades');

        $this->createSubmittedDocument($documentOne);
        $this->createSubmittedDocument($documentTwo);

        $response = $this->actingAs($this->student, 'sanctum')
            ->postJson("/api/applications/{$this->applicationId}/submit");

        $response->assertOk();

        $this->assertDatabaseHas('applications', [
            'id' => $this->applicationId,
            'status' => 'submitted',
        ]);

        $this->assertDatabaseHas('application_status_histories', [
            'application_id' => $this->applicationId,
            'old_status' => 'draft',
            'new_status' => 'submitted',
        ]);
    }

    public function test_application_submission_is_rejected_when_required_documents_are_missing(): void
    {
        $this->createRequiredDocument('Certificate of Enrollment');
        $this->createRequiredDocument('Grades');

        $response = $this->actingAs($this->student, 'sanctum')
            ->postJson("/api/applications/{$this->applicationId}/submit");

        $response->assertUnprocessable()
            ->assertJsonStructure([
                'missing_documents',
            ]);

        $this->assertDatabaseHas('applications', [
            'id' => $this->applicationId,
            'status' => 'draft',
        ]);
    }

    public function test_optional_documents_do_not_prevent_application_submission(): void
    {
        $this->createRequiredDocument('Optional Supporting Document', false);

        $response = $this->actingAs($this->student, 'sanctum')
            ->postJson("/api/applications/{$this->applicationId}/submit");

        $response->assertOk();

        $this->assertDatabaseHas('applications', [
            'id' => $this->applicationId,
            'status' => 'submitted',
        ]);
    }

    public function test_non_draft_application_cannot_be_submitted_again(): void
    {
        DB::table('applications')
            ->where('id', $this->applicationId)
            ->update(['status' => 'submitted']);

        $response = $this->actingAs($this->student, 'sanctum')
            ->postJson("/api/applications/{$this->applicationId}/submit");

        $response->assertStatus(409);
    }

    public function test_another_student_cannot_submit_someone_elses_application(): void
    {
        $otherStudent = User::create([
            'name' => 'Another Student',
            'email' => 'another@example.com',
            'password' => Hash::make('password123'),
            'role_id' => $this->student->role_id,
        ]);

        $response = $this->actingAs($otherStudent, 'sanctum')
            ->postJson("/api/applications/{$this->applicationId}/submit");

        $response->assertForbidden();

        $this->assertDatabaseHas('applications', [
            'id' => $this->applicationId,
            'status' => 'draft',
        ]);
    }

    public function test_staff_cannot_submit_a_student_application(): void
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
            ->postJson("/api/applications/{$this->applicationId}/submit");

        $response->assertForbidden();
    }
}
