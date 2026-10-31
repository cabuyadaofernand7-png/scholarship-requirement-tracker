<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class RoleSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('roles')->insertOrIgnore([
            [
                'name' => 'student',
                'description' => 'Submits scholarship applications and required documents.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'staff',
                'description' => 'Manages scholarship programs and application records.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'reviewer',
                'description' => 'Reviews submitted applications and documents.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
