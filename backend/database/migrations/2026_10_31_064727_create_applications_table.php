
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('applications', function (Blueprint $table) {
            $table->id();

            $table->foreignId('user_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->foreignId('scholarship_program_id')
                ->constrained('scholarship_programs')
                ->cascadeOnDelete();

            $table->string('application_number')->unique();

            $table->text('remarks')->nullable();

            $table->enum('status', [
                'draft',
                'submitted',
                'under_review',
                'incomplete',
                'for_correction',
                'approved',
                'rejected'
            ])->default('draft');

            $table->timestamp('submitted_at')->nullable();

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('applications');
    }
};
