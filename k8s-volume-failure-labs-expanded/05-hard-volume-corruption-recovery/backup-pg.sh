#!/usr/bin/env bash
set -euo pipefail
POD=$(kubectl get pod -l app=postgres -o jsonpath='{.items[0].metadata.name}')
if [ -z "$POD" ]; then
  echo "No postgres pod found. Ensure a pod has label app=postgres"
  exit 1
fi
echo "Backing up from pod $POD..."
kubectl exec -it $POD -- sh -c "pg_dumpall -U postgres > /var/lib/postgresql/data/backup.sql"
kubectl cp $POD:/var/lib/postgresql/data/backup.sql ./backup.sql
echo "Backup saved to ./backup.sql"
