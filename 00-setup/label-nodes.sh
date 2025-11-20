#!/usr/bin/env bash
# Label nodes for multi-zone simulation
# Usage: kubectl apply -f ... then run this script locally where kubectl is configured.
set -euo pipefail

echo "Labeling nodes..."
kubectl label node controlplane topology.kubernetes.io/zone=zone-a --overwrite
kubectl label node node01 topology.kubernetes.io/zone=zone-b --overwrite

echo "Done. Current node labels:"
kubectl get nodes -o wide
