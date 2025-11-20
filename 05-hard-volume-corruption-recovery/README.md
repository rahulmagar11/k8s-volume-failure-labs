# Volume corruption & recovery (lab)
This scenario shows how to perform a safe logical backup, simulate corruption (safer: move files), and restore a Postgres database from a logical backup (pg_dump).

Files:
- backup-pg.sh    - perform pg_dumpall from running Postgres pod (adjust pod selector)
- corrupt-pv.sh   - move PostgreSQL data directory (safer than deleting) using a helper pod
- restore-pg.sh   - restore from backup.sql into a fresh Postgres pod

**Always take and copy backups off-cluster before corrupting data.**
