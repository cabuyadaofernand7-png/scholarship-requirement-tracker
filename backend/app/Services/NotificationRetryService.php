<?php

namespace App\Services;

use App\Models\Notification;
use Illuminate\Support\Facades\Log;
use Throwable;

class NotificationRetryService
{
    public function process(
        Notification $notification,
        bool $simulateTransientFailure = false,
        bool $simulatePermanentFailure = false
    ): array {
        if ($notification->status === 'sent' ||
            $notification->status === 'failed') {
            return [
                'success' => false,
                'message' => 'Notification is not eligible for processing.',
            ];
        }

        if ($notification->attempts >= $notification->max_attempts) {
            $notification->update([
                'status' => 'failed',
                'error_message' => 'Maximum delivery attempts reached.',
                'next_attempt_at' => null,
            ]);

            return [
                'success' => false,
                'message' => 'Maximum attempts reached.',
            ];
        }

        $notification->increment('attempts');
        $notification->refresh();

        $notification->update([
            'last_attempt_at' => now(),
            'next_attempt_at' => null,
        ]);

        Log::info('Notification delivery attempt started', [
            'notification_id' => $notification->id,
            'attempt' => $notification->attempts,
        ]);

        try {
            if ($simulatePermanentFailure) {
                throw new \RuntimeException(
                    'Simulated permanent delivery failure.'
                );
            }

            if ($simulateTransientFailure &&
                $notification->attempts === 1) {
                throw new \RuntimeException(
                    'Simulated temporary delivery failure.'
                );
            }

            // Week 13 controlled simulation:
            // Successful delivery is recorded without contacting
            // a real email provider.

            $notification->update([
                'status' => 'sent',
                'sent_at' => now(),
                'error_message' => null,
            ]);

            Log::info('Notification delivery succeeded', [
                'notification_id' => $notification->id,
                'attempt' => $notification->attempts,
            ]);

            return [
                'success' => true,
                'message' => 'Notification delivery succeeded.',
                'attempts' => $notification->attempts,
            ];
        } catch (Throwable $exception) {
            $permanent = $simulatePermanentFailure;
            $exhausted = $notification->attempts >=
                $notification->max_attempts;

            if ($permanent || $exhausted) {
                $notification->update([
                    'status' => 'failed',
                    'error_message' => $exception->getMessage(),
                    'next_attempt_at' => null,
                ]);

                Log::error('Notification delivery permanently failed', [
                    'notification_id' => $notification->id,
                    'attempt' => $notification->attempts,
                ]);

                return [
                    'success' => false,
                    'message' => 'Delivery failed and requires human review.',
                    'attempts' => $notification->attempts,
                ];
            }

            $delayMinutes = 1;

            $notification->update([
                'status' => 'pending',
                'error_message' => $exception->getMessage(),
                'next_attempt_at' => now()->addMinutes($delayMinutes),
            ]);

            Log::warning('Notification delivery will be retried', [
                'notification_id' => $notification->id,
                'attempt' => $notification->attempts,
            ]);

            return [
                'success' => false,
                'message' => 'Temporary failure. Retry scheduled.',
                'attempts' => $notification->attempts,
            ];
        }
    }
}
