#!/usr/bin/env bash
set -euo pipefail
if [ ! -f ./backup.sql ]; then
  echo "Local ./backup.sql not found. Place backup.sql in this folder (copied earlier)."
  exit 1
fi
echo "Create a temporary pod to restore backup into the PVC..."
PVC=$(kubectl get pvc -o jsonpath='{.items[0].metadata.name}')
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: restorer
spec:
  containers:
  - name: r
    image: postgres:14-alpine
    env:
    - name: POSTGRES_PASSWORD
      value: demo123
    command: ["sh","-c","sleep 3600"]
    volumeMounts:
    - mountPath: /var/lib/postgresql/data
      name: pgdata
  volumes:
  - name: pgdata
    persistentVolumeClaim:
      claimName: ${PVC}
  restartPolicy: Never
EOF
echo "Wait a bit for restorer to start..."
sleep 5
kubectl cp ./backup.sql restorer:/tmp/backup.sql
kubectl exec -it restorer -- sh -c "psql -U postgres -f /tmp/backup.sql" || true
echo "Cleanup restorer pod (you may need to recreate your StatefulSet after restore)"
kubectl delete pod restorer || true
