<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class DocumentDownloadTest extends TestCase
{
    use RefreshDatabase;

    private User $student;
    private User $staff;
    private User $reviewer;
    private int $documentId;
    private int $applicationId;

    protected function setUp(): void
    {
        parent::setUp();

        Storage::fake('local');

        $studentRole = DB::table('roles')->insertGetId([
            'name' => 'student',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $staffRole = DB::table('roles')->insertGetId([
            'name' => 'staff',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $reviewerRole = DB::table('roles')->insertGetId([
            'name' => 'reviewer',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->student = User::create([
            'name' => 'Test Student',
            'email' => 'student@example.com',
            'password' => 'password123',
            'role_id' => $studentRole,
        ]);

        $this->staff = User::create([
            'name' => 'Test Staff',
            'email' => 'staff@example.com',
            'password' => 'password123',
            'role_id' => $staffRole,
        ]);

        $this->reviewer = User::create([
            'name' => 'Test Reviewer',
            'email' => 'reviewer@example.com',
            'password' => 'password123',
            'role_id' => $reviewerRole,
        ]);

        $programId = DB::table('scholarship_programs')->insertGetId([
            'name' => 'Test Scholarship',
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $requiredDocumentId = DB::table('required_documents')->insertGetId([
            'scholarship_program_id' => $programId,
            'document_name' => 'Test Requirement',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->applicationId = DB::table('applications')->insertGetId([
            'user_id' => $this->student->id,
            'scholarship_program_id' => $programId,
            'application_number' => 'TEST-APP-001',
            'status' => 'submitted',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $filePath = 'application-documents/test-document.pdf';

        Storage::disk('local')->put($filePath, 'Test PDF content');

        $this->documentId = DB::table('application_documents')->insertGetId([
            'application_id' => $this->applicationId,
            'required_document_id' => $requiredDocumentId,
            'file_path' => $filePath,
            'original_filename' => 'test-document.pdf',
            'mime_type' => 'application/pdf',
            'file_size' => 17,
            'status' => 'pending',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_unauthenticated_user_cannot_download_document(): void
    {
        $this->getJson("/api/documents/{$this->documentId}/download")
            ->assertUnauthorized();
    }

    public function test_student_cannot_download_document(): void
    {
        $this->actingAs($this->student, 'sanctum')
            ->getJson("/api/documents/{$this->documentId}/download")
            ->assertForbidden();
    }

    public function test_staff_can_download_document(): void
    {
        $this->actingAs($this->staff, 'sanctum')
            ->get("/api/documents/{$this->documentId}/download")
            ->assertDownload('test-document.pdf');
    }

    public function test_assigned_reviewer_can_download_document(): void
    {
        DB::table('review_assignments')->insert([
            'application_id' => $this->applicationId,
            'reviewer_id' => $this->reviewer->id,
            'assigned_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->actingAs($this->reviewer, 'sanctum')
            ->get("/api/documents/{$this->documentId}/download")
            ->assertDownload('test-document.pdf');
    }

    public function test_unassigned_reviewer_cannot_download_document(): void
    {
        $this->actingAs($this->reviewer, 'sanctum')
            ->getJson("/api/documents/{$this->documentId}/download")
            ->assertForbidden();
    }

    public function test_staff_receives_not_found_when_document_file_is_missing(): void
    {
        Storage::disk('local')->delete(
            'application-documents/test-document.pdf'
        );

        $this->actingAs($this->staff, 'sanctum')
            ->getJson("/api/documents/{$this->documentId}/download")
            ->assertNotFound();
    }

    public function test_staff_receives_not_found_when_document_path_is_empty(): void
    {
        DB::table('application_documents')
            ->where('id', $this->documentId)
            ->update(['file_path' => null]);

        $this->actingAs($this->staff, 'sanctum')
            ->getJson("/api/documents/{$this->documentId}/download")
            ->assertNotFound();
    }

    public function test_nonexistent_document_returns_not_found(): void
    {
        $this->actingAs($this->staff, 'sanctum')
            ->getJson('/api/documents/999999/download')
            ->assertNotFound();
    }
}
