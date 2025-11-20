#!/usr/bin/env bash
# Wrapper: apply -> test -> break -> fix for RWX NFS lab
# Safety: destructive break steps require CONFIRM=YES environment variable.
set -euo pipefail
LABDIR="$(cd "$(dirname "$0")" && pwd)"
function apply() {
  echo "Applying NFS server and PVC + pods..."
  kubectl apply -f $LABDIR/nfs-server.yaml
  kubectl apply -f $LABDIR/nfs-pvc.yaml
  kubectl apply -f $LABDIR/writer-reader.yaml
  echo "Waiting 5s for pods..."
  sleep 5
  kubectl get pods -o wide
}
function test() {
  echo "Tailing writer logs (5 lines)"
  kubectl logs writer --tail=5 || true
  echo "Tailing reader logs (5 lines)"
  kubectl logs reader --tail=5 || true
}
function break_lab() {
  if [ "$CONFIRM" != "YES" ]; then
    echo "To perform destructive break set CONFIRM=YES in env. Aborting."
    exit 1
  fi
  echo "Deleting nfs-server (simulated failure)..."
  kubectl delete pod nfs-server || true
  echo "Writer/reader will show I/O errors. Inspect with kubectl describe pod <name>"
}
function fix() {
  echo "Recreating nfs-server and restarting pods..."
  kubectl apply -f $LABDIR/nfs-server.yaml
  kubectl delete pod writer reader || true
  kubectl apply -f $LABDIR/writer-reader.yaml || true
  echo "Done. Check logs:"
  kubectl logs writer --tail=5 || true
  kubectl logs reader --tail=5 || true
}
case "${1:-apply}" in
  apply) apply ;;
  test) test ;;
  break) break_lab ;;
  fix) fix ;;
  all) apply; test; echo '---- now safe break requires CONFIRM=YES'; if [ "$CONFIRM" = "YES" ]; then break_lab; fix; else echo 'Skipping break'; fi ;;
  *) echo "Usage: $0 {apply|test|break|fix|all}" ; exit 2 ;;
esac
