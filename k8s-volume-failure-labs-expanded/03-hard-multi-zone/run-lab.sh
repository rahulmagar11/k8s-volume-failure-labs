#!/usr/bin/env bash
# Wrapper for multi-zone simulated lab
set -euo pipefail
LABDIR="$(cd "$(dirname "$0")" && pwd)"
function apply() {
  echo "Ensure nodes are labeled (run 00-setup/label-nodes.sh) and local paths created."
  kubectl apply -f $LABDIR/pv-zone-a.yaml
  kubectl apply -f $LABDIR/pv-zone-b.yaml
  kubectl apply -f $LABDIR/statefulset.yaml
  echo "Waiting for pods..."
  sleep 5
  kubectl get pods -l app=pg -o wide
}
function test() {
  echo "Write marker to first pg pod (if exists)"
  POD=$(kubectl get pod -l app=pg -o jsonpath='{.items[0].metadata.name}' || true)
  if [ -n "$POD" ]; then
    kubectl exec -it $POD -- sh -c "echo zone-marker-$(hostname)-$(date) > /var/lib/postgresql/data/marker.txt" || true
    kubectl exec -it $POD -- sh -c "cat /var/lib/postgresql/data/marker.txt" || true
  else
    echo "No pg pod found"
  fi
}
function break_lab() {
  if [ "$CONFIRM" != "YES" ]; then echo "Set CONFIRM=YES to perform destructive break"; exit 1; fi
  echo "Cordoning controlplane (zone-a) to simulate zone outage"
  kubectl cordon controlplane || true
  POD=$(kubectl get pod -l app=pg -o jsonpath='{.items[0].metadata.name}' || true)
  if [ -n "$POD" ]; then
    echo "Deleting pod $POD (it may be the primary on controlplane)"
    kubectl delete pod $POD || true
  fi
  kubectl get pods -o wide
}
function fix() {
  echo "Uncordoning controlplane and letting pods recover"
  kubectl uncordon controlplane || true
  echo "If needed, copy data between zones and recreate PV with claimRef (manual advanced step)"
}
case "${1:-apply}" in
  apply) apply ;;
  test) test ;;
  break) break_lab ;;
  fix) fix ;;
  all) apply; test; echo '---- now break (requires CONFIRM=YES)'; if [ "$CONFIRM" = "YES" ]; then break_lab; fix; else echo 'Skipping break'; fi ;;
  *) echo "Usage: $0 {apply|test|break|fix|all}" ; exit 2 ;;
esac
