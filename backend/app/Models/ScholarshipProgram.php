<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ScholarshipProgram extends Model
{
    protected $fillable = [
        'name',
        'description',
        'academic_year',
        'application_start_date',
        'application_deadline',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'application_start_date' => 'date',
            'application_deadline' => 'date',
            'is_active' => 'boolean',
        ];
    }

    public function applications(): HasMany
    {
        return $this->hasMany(Application::class);
    }

    public function requiredDocuments(): HasMany
    {
        return $this->hasMany(RequiredDocument::class);
    }
}
