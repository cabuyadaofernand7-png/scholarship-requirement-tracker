<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Notification extends Model
{
    protected $fillable = [
        'user_id',
        'application_id',
        'type',
        'title',
        'message',
        'channel',
        'status',
        'scheduled_at',
        'sent_at',
        'read_at',
        'error_message',
        'attempts',
        'max_attempts',
        'last_attempt_at',
        'next_attempt_at',
    ];

    protected function casts(): array
    {
        return [
            'scheduled_at' => 'datetime',
            'sent_at' => 'datetime',
            'read_at' => 'datetime',
            'last_attempt_at' => 'datetime',
            'next_attempt_at' => 'datetime',
            'attempts' => 'integer',
            'max_attempts' => 'integer',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function application(): BelongsTo
    {
        return $this->belongsTo(Application::class);
    }
}
