#!/usr/bin/env bash
# Wrapper for corruption/recovery lab
set -euo pipefail
LABDIR="$(cd "$(dirname "$0")" && pwd)"
case "${1:-apply}" in
  apply)
    echo "This lab assumes you already have a Postgres StatefulSet or pod with label app=postgres running." ;;
  test)
    echo "Run backup: $LABDIR/backup-pg.sh" ;;
  break)
    if [ "$CONFIRM" != "YES" ]; then echo "Set CONFIRM=YES to perform destructive break"; exit 1; fi
    echo "Running safer corrupt (move data)"
    $LABDIR/corrupt-pv.sh
    ;;
  fix)
    echo "Restore from backup.sql using restore-pg.sh"
    $LABDIR/restore-pg.sh
    ;;
  *)
    echo "Usage: $0 {apply|test|break|fix}"; exit 2;;
esac
