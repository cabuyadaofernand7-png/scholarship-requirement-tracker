<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class RequiredDocument extends Model
{
    protected $fillable = [
        'scholarship_program_id',
        'document_name',
        'description',
        'is_required',
        'allowed_file_types',
        'max_file_size_kb',
    ];

    protected function casts(): array
    {
        return [
            'is_required' => 'boolean',
            'max_file_size_kb' => 'integer',
        ];
    }

    public function scholarshipProgram(): BelongsTo
    {
        return $this->belongsTo(ScholarshipProgram::class);
    }

    public function applicationDocuments(): HasMany
    {
        return $this->hasMany(ApplicationDocument::class);
    }
}
