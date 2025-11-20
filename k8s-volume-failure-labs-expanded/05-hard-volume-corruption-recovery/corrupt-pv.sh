#!/usr/bin/env bash
# SAFER: Move data directory to .bak rather than deleting.
set -euo pipefail
POD=$(kubectl get pod -l app=postgres -o jsonpath='{.items[0].metadata.name}')
if [ -z "$POD" ]; then
  echo "No postgres pod found. Ensure a pod has label app=postgres"
  exit 1
fi
echo "Creating helper pod that mounts the same PVC to move data..."
PVC=$(kubectl get pod -l app=postgres -o jsonpath='{.items[0].spec.volumes[0].persistentVolumeClaim.claimName}')
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: corruptor
spec:
  containers:
  - name: c
    image: busybox
    command: ["sh","-c","sleep 3600"]
    volumeMounts:
    - name: pgdata
      mountPath: /data
  volumes:
  - name: pgdata
    persistentVolumeClaim:
      claimName: ${PVC}
  restartPolicy: Never
EOF
echo "Waiting 5s for corruptor to start..."
sleep 5
echo "Moving data to /data.bak inside helper pod (safer than delete)"
kubectl exec -it corruptor -- sh -c "mv /data /data.bak || true; mkdir -p /data; chmod 777 /data"
echo "Cleanup corruptor pod"
kubectl delete pod corruptor || true
echo "Data has been moved; the DB will likely crash. Restore from backup.sql using restore-pg.sh"
