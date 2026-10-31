
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('required_documents', function (Blueprint $table) {
            $table->id();

            $table->foreignId('scholarship_program_id')
                ->constrained('scholarship_programs')
                ->cascadeOnDelete();

            $table->string('document_name');
            $table->text('description')->nullable();
            $table->boolean('is_required')->default(true);
            $table->string('allowed_file_types')->default('pdf,jpg,jpeg,png');
            $table->unsignedInteger('max_file_size_kb')->default(5120);

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('required_documents');
    }
};
