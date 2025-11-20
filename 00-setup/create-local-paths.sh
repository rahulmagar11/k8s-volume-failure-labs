#!/usr/bin/env bash
# Create local directories on specific nodes using helper pods.
# This creates folders used by local PersistentVolumes:
#  - /mnt/pg-zone-a         (controlplane)
#  - /mnt/pg-zone-b         (node01)
#  - /mnt/data/stateful-demo
#  - /mnt/data/pg-pv-demo
#  - /mnt/local-pv
set -euo pipefail

echo "Creating helper pod on node controlplane to make directories..."
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: helper-create-controlplane
spec:
  nodeSelector:
    kubernetes.io/hostname: controlplane
  containers:
  - name: helper
    image: busybox
    command: ["sh","-c","mkdir -p /mnt/pg-zone-a /mnt/data/stateful-demo /mnt/data/pg-pv-demo /mnt/local-pv && sleep 3600"]
    volumeMounts:
    - mountPath: /mnt
      name: hostmnt
  volumes:
  - name: hostmnt
    hostPath:
      path: /
  restartPolicy: Never
EOF

echo "Creating helper pod on node node01 to make directories..."
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: helper-create-node01
spec:
  nodeSelector:
    kubernetes.io/hostname: node01
  containers:
  - name: helper
    image: busybox
    command: ["sh","-c","mkdir -p /mnt/pg-zone-b && sleep 3600"]
    volumeMounts:
    - mountPath: /mnt
      name: hostmnt
  volumes:
  - name: hostmnt
    hostPath:
      path: /
  restartPolicy: Never
EOF

echo "Waiting 10s for helper pods to start..."
sleep 10
kubectl get pods -o wide | grep helper-create || true
echo "When finished, you can delete helpers:"
echo "kubectl delete pod helper-create-controlplane helper-create-node01"
