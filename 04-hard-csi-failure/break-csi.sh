#!/usr/bin/env bash
# Find deployments with 'csi' in their name and scale them to 0 replicas (simulate controller down).
set -euo pipefail
echo "Looking for deployments containing 'csi' (case-insensitive)..."
kubectl get deploy -A | awk 'tolower($2) ~ /csi/ {print $1":"$2}' | while IFS=":" read ns name; do
  echo "Scaling $ns/$name -> 0"
  kubectl -n "$ns" scale deployment "$name" --replicas=0 || true
done
echo "Done."
