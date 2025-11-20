#!/usr/bin/env bash
# Wrapper for StatefulSet Retain lab: apply -> test -> break -> fix
set -euo pipefail
LABDIR="$(cd "$(dirname "$0")" && pwd)"
function apply() {
  echo "Applying PV and StatefulSet..."
  kubectl apply -f $LABDIR/pv.yaml
  kubectl apply -f $LABDIR/statefulset.yaml
  echo "Waiting for pod..."
  sleep 5
  kubectl get pods -l app=stateapp -o wide || true
}
function test() {
  POD=$(kubectl get pod -l app=stateapp -o jsonpath='{.items[0].metadata.name}' || true)
  if [ -n "$POD" ]; then
    kubectl exec -it $POD -- cat /data/msg || true
  else
    echo "Pod not found"
  fi
}
function break_lab() {
  if [ "$CONFIRM" != "YES" ]; then echo "Set CONFIRM=YES to perform destructive break"; exit 1; fi
  echo "Deleting statefulset and pod..."
  kubectl delete statefulset app || true
  kubectl delete pod app-0 || true
  echo "Check PVCs: kubectl get pvc"
}
function fix() {
  echo "Re-applying StatefulSet..."
  kubectl apply -f $LABDIR/statefulset.yaml
  echo "Pods will be recreated and PVC should reattach if PV available"
}
case "${1:-apply}" in
  apply) apply ;;
  test) test ;;
  break) break_lab ;;
  fix) fix ;;
  all) apply; test; echo '---- now break (requires CONFIRM=YES)'; if [ "$CONFIRM" = "YES" ]; then break_lab; fix; else echo 'Skipping break'; fi ;;
  *) echo "Usage: $0 {apply|test|break|fix|all}" ; exit 2 ;;
esac
