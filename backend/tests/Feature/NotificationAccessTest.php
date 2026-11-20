<?php

namespace Tests\Feature;

use App\Models\Notification;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class NotificationAccessTest extends TestCase
{
    use RefreshDatabase;

    private User $student;

    protected function setUp(): void
    {
        parent::setUp();

        $studentRoleId = DB::table('roles')->insertGetId([
            'name' => 'student',
            'description' => 'Student account',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->student = User::create([
            'name' => 'Test Student',
            'email' => 'student@example.com',
            'password' => 'password123',
            'role_id' => $studentRoleId,
        ]);
    }

    private function createNotification(
        int $userId,
        string $title
    ): Notification {
        return Notification::create([
            'user_id' => $userId,
            'type' => 'application_status_update',
            'title' => $title,
            'message' => 'Your application status has been updated.',
            'channel' => 'in_app',
            'status' => 'pending',
            'scheduled_at' => now(),
        ]);
    }

    public function test_unauthenticated_user_cannot_access_notifications(): void
    {
        $this->getJson('/api/notifications')
            ->assertUnauthorized();
    }

    public function test_student_can_view_own_notifications(): void
    {
        $this->createNotification(
            $this->student->id,
            'Your Application Was Submitted'
        );

        $token = $this->student->createToken('test-token');

        $this->withToken($token->plainTextToken)
            ->getJson('/api/notifications')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath(
                'data.0.title',
                'Your Application Was Submitted'
            );
    }

    public function test_student_cannot_view_another_students_notifications(): void
    {
        $anotherStudent = User::create([
            'name' => 'Another Student',
            'email' => 'another@example.com',
            'password' => 'password123',
            'role_id' => $this->student->role_id,
        ]);

        $this->createNotification(
            $this->student->id,
            'My Private Notification'
        );

        $this->createNotification(
            $anotherStudent->id,
            'Another Students Private Notification'
        );

        $token = $this->student->createToken('test-token');

        $this->withToken($token->plainTextToken)
            ->getJson('/api/notifications')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath(
                'data.0.title',
                'My Private Notification'
            )
            ->assertJsonMissing([
                'title' => 'Another Students Private Notification',
            ]);
    }
        public function test_invalid_token_cannot_access_notifications(): void
        {
            $this->withToken('invalid-token-12345')
                ->getJson('/api/notifications')
                ->assertUnauthorized();
        }
}
