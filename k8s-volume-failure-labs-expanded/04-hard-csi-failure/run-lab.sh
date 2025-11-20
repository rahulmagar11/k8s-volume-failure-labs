#!/usr/bin/env bash
# Wrapper for CSI failure simulation directory
set -euo pipefail
LABDIR="$(cd "$(dirname "$0")" && pwd)"
case "${1:-apply}" in
  apply)
    kubectl apply -f $LABDIR/sc2-pvc-pod.yaml
    ;;
  test)
    kubectl get pvc,csi-test-pvc -o wide || true
    kubectl get pod csi-test-app -o wide || true
    ;;
  break)
    echo "Simulating CSI controller failure (scale down deployments with 'csi' in their names). Be careful!"
    $LABDIR/break-csi.sh
    ;;
  fix)
    echo "Restoring CSI controllers"
    $LABDIR/fix-csi.sh
    ;;
  *)
    echo "Usage: $0 {apply|test|break|fix}"; exit 2;;
esac
