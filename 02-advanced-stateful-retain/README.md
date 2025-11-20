# Advanced: StatefulSet with Retain PV (lab)
This demonstrates a StatefulSet that writes to a PVC/PV. The PV uses reclaimPolicy=Retain so that when the StatefulSet is deleted, the data remains on disk.

## How to run
1. kubectl apply -f pv.yaml
2. kubectl apply -f statefulset.yaml
3. Wait for pod: kubectl get pods -l app=stateapp -o wide
4. Test: kubectl exec -it <pod> -- cat /data/msg

## Break (safe):
Delete the StatefulSet:
  kubectl delete statefulset app
  kubectl delete pod app-0

Check that PVC still exists: kubectl get pvc
Data remains on the host path: /mnt/data/stateful-demo

## Fix:
Reapply the StatefulSet and pods will reattach the PVC (if PV bind satisfied):
  kubectl apply -f statefulset.yaml
