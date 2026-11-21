<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Filesystem\FilesystemAdapter;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use League\Flysystem\UnableToCreateDirectory;
use Tests\TestCase;

class ApplicationDocumentUploadTest extends TestCase
{
    use RefreshDatabase;

    private User $student;

    private int $programId;

    private int $applicationId;

    private int $requiredDocumentId;

    protected function setUp(): void
    {
        parent::setUp();

        Storage::fake('local');

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
            'application_number' => 'APP-UPLOAD-001',
            'status' => 'draft',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->requiredDocumentId = $this->createRequiredDocument(
            $this->programId,
            'Certificate of Enrollment'
        );
    }

    private function createRequiredDocument(
        int $programId,
        string $name,
        string $allowedTypes = 'pdf',
        int $maxSize = 5120
    ): int {
        return DB::table('required_documents')->insertGetId([
            'scholarship_program_id' => $programId,
            'document_name' => $name,
            'description' => 'Document for testing',
            'is_required' => true,
            'allowed_file_types' => $allowedTypes,
            'max_file_size_kb' => $maxSize,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function uploadDocument(
        int $requiredDocumentId,
        UploadedFile $file,
        ?User $user = null
    ) {
        return $this->actingAs($user ?? $this->student, 'sanctum')
            ->postJson("/api/applications/{$this->applicationId}/documents", [
                'required_document_id' => $requiredDocumentId,
                'file' => $file,
            ]);
    }

    public function test_student_can_upload_a_valid_document(): void
    {
        $file = UploadedFile::fake()->create(
            'certificate.pdf',
            100,
            'application/pdf'
        );

        $response = $this->uploadDocument(
            $this->requiredDocumentId,
            $file
        );

        $response->assertCreated();

        $this->assertDatabaseHas('application_documents', [
            'application_id' => $this->applicationId,
            'required_document_id' => $this->requiredDocumentId,
            'original_filename' => 'certificate.pdf',
            'status' => 'pending',
        ]);

        $storedPath = DB::table('application_documents')
            ->where('application_id', $this->applicationId)
            ->where('required_document_id', $this->requiredDocumentId)
            ->value('file_path');

        $this->assertNotEmpty($storedPath);
        Storage::disk('local')->assertExists($storedPath);
    }

    public function test_invalid_file_type_is_rejected(): void
    {
        $file = UploadedFile::fake()->create(
            'certificate.txt',
            100,
            'text/plain'
        );

        $response = $this->uploadDocument(
            $this->requiredDocumentId,
            $file
        );

        $response->assertUnprocessable();

        $this->assertDatabaseMissing('application_documents', [
            'application_id' => $this->applicationId,
            'required_document_id' => $this->requiredDocumentId,
        ]);
    }

    public function test_file_exceeding_allowed_size_is_rejected(): void
    {
        $smallLimitDocumentId = $this->createRequiredDocument(
            $this->programId,
            'Small Limit Document',
            'pdf',
            10
        );

        $file = UploadedFile::fake()->create(
            'large-certificate.pdf',
            11,
            'application/pdf'
        );

        $response = $this->uploadDocument(
            $smallLimitDocumentId,
            $file
        );

        $response->assertUnprocessable();

        $this->assertDatabaseMissing('application_documents', [
            'application_id' => $this->applicationId,
            'required_document_id' => $smallLimitDocumentId,
        ]);
    }

    public function test_document_from_another_scholarship_program_is_rejected(): void
    {
        $anotherProgramId = DB::table('scholarship_programs')->insertGetId([
            'name' => 'Another Scholarship',
            'description' => 'Different scholarship',
            'academic_year' => '2026-2027',
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $foreignDocumentId = $this->createRequiredDocument(
            $anotherProgramId,
            'Foreign Certificate'
        );

        $file = UploadedFile::fake()->create(
            'certificate.pdf',
            100,
            'application/pdf'
        );

        $response = $this->uploadDocument(
            $foreignDocumentId,
            $file
        );

        $response->assertUnprocessable();

        $this->assertDatabaseMissing('application_documents', [
            'application_id' => $this->applicationId,
            'required_document_id' => $foreignDocumentId,
        ]);
    }

    public function test_another_student_cannot_upload_to_someone_elses_application(): void
    {
        $anotherStudent = User::create([
            'name' => 'Another Student',
            'email' => 'another@example.com',
            'password' => Hash::make('password123'),
            'role_id' => $this->student->role_id,
        ]);

        $file = UploadedFile::fake()->create(
            'certificate.pdf',
            100,
            'application/pdf'
        );

        $response = $this->uploadDocument(
            $this->requiredDocumentId,
            $file,
            $anotherStudent
        );

        $response->assertForbidden();

        $this->assertDatabaseMissing('application_documents', [
            'application_id' => $this->applicationId,
            'required_document_id' => $this->requiredDocumentId,
        ]);
    }

    public function test_upload_returns_service_unavailable_when_storage_fails(): void
    {
        $disk = \Mockery::mock(FilesystemAdapter::class);

        // Simulate a failed file-storage operation.
        $disk->shouldReceive('putFileAs')
            ->once()
            ->andReturn(false);

        Storage::shouldReceive('disk')
            ->with('local')
            ->andReturn($disk);

        $file = UploadedFile::fake()->create(
            'certificate.pdf',
            100,
            'application/pdf'
        );

        $response = $this->uploadDocument(
            $this->requiredDocumentId,
            $file
        );

        $response->assertStatus(503);

        $this->assertDatabaseMissing('application_documents', [
            'application_id' => $this->applicationId,
            'required_document_id' => $this->requiredDocumentId,
        ]);
    }

    public function test_upload_returns_generic_service_unavailable_when_storage_throws(): void
    {
        $disk = \Mockery::mock(FilesystemAdapter::class);

        $disk->shouldReceive('putFileAs')
            ->once()
            ->andThrow(UnableToCreateDirectory::atLocation('private'));

        Storage::shouldReceive('disk')
            ->with('local')
            ->andReturn($disk);

        $file = UploadedFile::fake()->create(
            'certificate.pdf',
            100,
            'application/pdf'
        );

        $response = $this->uploadDocument(
            $this->requiredDocumentId,
            $file
        );

        $response->assertServiceUnavailable()->assertExactJson([
            'success' => false,
            'message' => 'Document storage is temporarily unavailable. Please try again later.',
        ]);

        $this->assertDatabaseMissing('application_documents', [
            'application_id' => $this->applicationId,
            'required_document_id' => $this->requiredDocumentId,
        ]);
    }

    public function test_student_can_upload_a_document_for_correction(): void
    {
        DB::table('applications')
            ->where('id', $this->applicationId)
            ->update(['status' => 'for_correction']);

        $file = UploadedFile::fake()->create(
            'corrected-certificate.pdf',
            100,
            'application/pdf'
        );

        $response = $this->uploadDocument(
            $this->requiredDocumentId,
            $file
        );

        $response->assertCreated();

        $this->assertDatabaseHas('application_documents', [
            'application_id' => $this->applicationId,
            'required_document_id' => $this->requiredDocumentId,
            'original_filename' => 'corrected-certificate.pdf',
            'status' => 'pending',
        ]);
    }

    public function test_student_cannot_upload_documents_after_submission_or_review(): void
    {
        $blockedStatuses = [
            'submitted',
            'under_review',
            'incomplete',
            'approved',
            'rejected',
        ];

        foreach ($blockedStatuses as $status) {
            DB::table('applications')
                ->where('id', $this->applicationId)
                ->update(['status' => $status]);

            $file = UploadedFile::fake()->create(
                'certificate-'.$status.'.pdf',
                100,
                'application/pdf'
            );

            $response = $this->uploadDocument(
                $this->requiredDocumentId,
                $file
            );

            $response->assertStatus(409);
        }

        $this->assertDatabaseMissing('application_documents', [
            'application_id' => $this->applicationId,
            'required_document_id' => $this->requiredDocumentId,
        ]);
    }
}
