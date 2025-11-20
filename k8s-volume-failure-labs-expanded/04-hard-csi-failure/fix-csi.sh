#!/usr/bin/env bash
# Scale back up any csi deployments that are currently scaled to 0 -> 1
set -euo pipefail
kubectl get deploy -A | awk 'tolower($2) ~ /csi/ {print $1":"$2":"$3}' | while IFS=":" read ns name ready; do
  if echo "$ready" | grep -q '^0/'; then
    echo "Scaling $ns/$name to 1"
    kubectl -n $ns scale deployment $name --replicas=1 || true
  fi
done
echo "Done."
