# Volume corruption & recovery (lab) — Expanded

This scenario shows safe logical backup, safer corruption (move), and restore with logical backup for Postgres.

Files:
- backup-pg.sh    - perform pg_dumpall from running Postgres pod (adjust pod selector)
- corrupt-pv.sh   - move PostgreSQL data directory (safer than deleting) using a helper pod
- restore-pg.sh   - restore from backup.sql into a fresh Postgres pod
- run-lab.sh      - wrapper

## Wrapper usage
- Test/backup: ./run-lab.sh test   (this prints how to run backup script)
- Break (destructive move): CONFIRM=YES ./run-lab.sh break
- Fix/restore: ./run-lab.sh fix

## Safety
- Always copy backup.sql off-cluster before corrupting data.
