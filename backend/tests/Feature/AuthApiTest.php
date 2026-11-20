<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;
use Illuminate\Support\Facades\Auth;

class AuthApiTest extends TestCase
{
    use RefreshDatabase;

    private int $studentRoleId;

    private User $student;

    protected function setUp(): void
    {
        parent::setUp();

        $this->studentRoleId = DB::table('roles')->insertGetId([
            'name' => 'student',
            'description' => 'Student account',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->student = User::create([
            'name' => 'Test Student',
            'email' => 'student@example.com',
            'password' => 'password123',
            'role_id' => $this->studentRoleId,
        ]);
    }

    public function test_student_can_register_successfully(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'New Student',
            'email' => 'newstudent@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertCreated()
            ->assertJsonPath('message', 'Registration successful.')
            ->assertJsonPath('user.name', 'New Student')
            ->assertJsonPath('user.role.name', 'student')
            ->assertJsonStructure([
                'message',
                'user',
                'token',
            ]);

        $this->assertDatabaseHas('users', [
            'email' => 'newstudent@example.com',
        ]);
    }

    public function test_registration_rejects_duplicate_email(): void
    {
        $this->postJson('/api/register', [
            'name' => 'Duplicate Student',
            'email' => 'student@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ])->assertUnprocessable()
          ->assertJsonValidationErrors(['email']);
    }

    public function test_registration_rejects_short_password(): void
    {
        $this->postJson('/api/register', [
            'name' => 'New Student',
            'email' => 'newstudent@example.com',
            'password' => '123',
            'password_confirmation' => '123',
        ])->assertUnprocessable()
          ->assertJsonValidationErrors(['password']);
    }

    public function test_registration_rejects_unconfirmed_password(): void
    {
        $this->postJson('/api/register', [
            'name' => 'New Student',
            'email' => 'newstudent@example.com',
            'password' => 'password123',
            'password_confirmation' => 'different123',
        ])->assertUnprocessable()
          ->assertJsonValidationErrors(['password']);
    }

    public function test_student_can_login_with_correct_credentials(): void
    {
        $this->postJson('/api/login', [
            'email' => 'student@example.com',
            'password' => 'password123',
        ])->assertOk()
          ->assertJsonPath('message', 'Login successful.')
          ->assertJsonPath('user.email', 'student@example.com')
          ->assertJsonStructure([
              'message',
              'user',
              'token',
          ]);
    }

    public function test_login_rejects_incorrect_password(): void
    {
        $this->postJson('/api/login', [
            'email' => 'student@example.com',
            'password' => 'wrongpassword',
        ])->assertUnauthorized()
          ->assertJsonPath('message', 'Invalid email or password.');
    }

    public function test_login_rejects_unknown_email(): void
    {
        $this->postJson('/api/login', [
            'email' => 'unknown@example.com',
            'password' => 'password123',
        ])->assertUnauthorized();
    }

    public function test_login_requires_email_and_password(): void
    {
        $this->postJson('/api/login', [])
            ->assertUnprocessable()
            ->assertJsonValidationErrors([
                'email',
                'password',
            ]);
    }

    public function test_student_can_logout_and_revoke_token(): void
    {
        $token = $this->student->createToken('test-token');

        $this->withToken($token->plainTextToken)
            ->postJson('/api/logout')
            ->assertOk()
            ->assertJsonPath('message', 'Logout successful.');

        $this->assertDatabaseMissing('personal_access_tokens', [
            'id' => $token->accessToken->id,
        ]);
    }


public function test_revoked_token_cannot_access_protected_endpoint(): void
{
    $token = $this->student->createToken('test-token');

    // Log out and revoke the token.
    $this->withToken($token->plainTextToken)
        ->postJson('/api/logout')
        ->assertOk();

    // Clear Laravel's cached authentication guards.
    Auth::forgetGuards();

    // Try to access a protected endpoint using the revoked token.
    $this->withToken($token->plainTextToken)
        ->getJson('/api/user')
        ->assertUnauthorized();
}
}
