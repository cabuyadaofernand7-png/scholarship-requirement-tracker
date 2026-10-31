
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('application_documents', function (Blueprint $table) {
            $table->id();

            $table->foreignId('application_id')
                ->constrained('applications')
                ->cascadeOnDelete();

            $table->foreignId('required_document_id')
                ->constrained('required_documents')
                ->cascadeOnDelete();

            $table->string('file_path')->nullable();
            $table->string('original_filename')->nullable();
            $table->string('mime_type')->nullable();
            $table->unsignedBigInteger('file_size')->nullable();

            $table->enum('status', [
                'pending',
                'accepted',
                'rejected',
                'resubmission_required'
            ])->default('pending');

            $table->text('feedback')->nullable();

            $table->timestamp('submitted_at')->nullable();
            $table->timestamp('reviewed_at')->nullable();

            $table->foreignId('reviewed_by')
                ->nullable()
                ->constrained('users')
                ->nullOnDelete();

            $table->timestamps();

            $table->unique(
                ['application_id', 'required_document_id'],
                'application_required_document_unique'
            );
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('application_documents');
    }
};
