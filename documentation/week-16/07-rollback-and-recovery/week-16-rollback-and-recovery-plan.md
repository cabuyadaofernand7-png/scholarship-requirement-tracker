# Week 16 Rollback and Recovery Plan

**Status:** PARTIALLY COMPLETED — prior isolated database recovery evidence exists; a complete application deployment rollback rehearsal has not been performed.

## 1. Purpose

This plan describes how to respond to an unsuccessful application update or database recovery problem while protecting the existing project data.

## 2. Known recovery references

| Item | Reference |
|---|---|
| Known application build tag | `week-15-hardened-build` |
| Tag target commit | `534efa4` |
| Later documented working-tree commit | `945e04c` |
| Application repository branch | `main` |
| Recovered SQL dump | `C:\MariaDB_Recovery\Recovered_SQL\scholarship_requirement_tracker_full_recovered.sql` |
| Original MariaDB data directory | `C:\xampp\mysql\data` |
| Pristine recovery snapshot | `C:\MariaDB_Recovery\Original_Copy` |
| Isolated recovery test directory | `C:\MariaDB_Recovery\Restore_Test_Data` |
| Isolated recovery database port | `3308` |

The original data directory and pristine snapshot must remain untouched during recovery exercises.

## 3. Application rollback procedure

If a future application update causes a serious regression:

1. Stop further deployment or release activity.
2. Record the affected commit, observed problem, time, and available logs.
3. Identify the last verified application build.
4. Confirm that the selected build and its dependencies are available.
5. Restore the previous application version in a controlled deployment environment.
6. Clear or rebuild generated caches only when appropriate for that environment.
7. Start the application and verify the health endpoint.
8. Test login and the affected application workflow.
9. Record the result and obtain approval before resuming deployment.

The `week-15-hardened-build` tag identifies the previous reference build. It is not proof that an application rollback was rehearsed during Week 16.

Do not use `git reset --hard` as a routine rollback method. Preserve newer commits and evidence.

## 4. Database recovery procedure

1. Stop database writes to the affected test environment.
2. Identify the correct backup or recovered SQL dump.
3. Verify the backup file exists and is the intended recovery source.
4. Restore only into a separately prepared, disposable database environment.
5. Keep the isolated recovery service on port `3308`.
6. Run database integrity checks.
7. Verify expected tables, row counts, and foreign-key relationships.
8. Run application tests against the isolated recovery database.
9. Record any missing, inconsistent, or unrecoverable data.
10. Obtain approval before any separately authorized production recovery.

**Critical safety restrictions:**
- Do not modify `C:\xampp\mysql\data`.
- Do not modify `C:\MariaDB_Recovery\Original_Copy`.
- Do not run recovery imports against ports `3306` or `3307`.
- Do not run destructive Laravel migrations such as `migrate:fresh`, `migrate:refresh`, or `migrate:reset`.
- Do not treat a local recovery test as proof of production disaster recovery.

## 5. Previously recorded recovery evidence

Earlier isolated recovery work recorded:
- 19 recovered database tables.
- 58 recovered rows.
- All 19 tables passed `mysqlcheck`.
- 17 foreign-key orphan checks returned zero orphan records.
- Unique-value checks passed.

These results support the earlier isolated database recovery exercise. They do not establish a completed Week 16 application deployment rollback rehearsal.

## 6. Recovery verification checklist

| Verification item | Evidence/status |
|---|---|
| Known application reference tag | Available |
| Recovered SQL dump reference | Available |
| Original database protected | Required safety restriction |
| Isolated recovery environment | Previously prepared |
| Database integrity checks | Previously passed |
| Application rollback rehearsal | Not performed |
| Full deployment rollback | Not performed |
| Production disaster recovery | Not tested |

## 7. Recovery communication

For a failed recovery:
- Stop and preserve the current state.
- Record the error and affected environment.
- Avoid repeated destructive attempts.
- Escalate unresolved data-integrity issues for human review.
- Resume only after the recovery source and target have been verified.

## 8. Limitations

This is a controlled local recovery plan. The prior database checks do not demonstrate production backup scheduling, off-site backup availability, recovery time objectives, recovery point objectives, or a complete production rollback.

A full deployment rollback rehearsal remains pending.

No production disaster-recovery or production-readiness claim is made.
