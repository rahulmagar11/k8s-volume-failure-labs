# Hard: Multi-zone (simulated) StatefulSet
This scenario simulates a multi-zone cluster by labeling two nodes and creating local PersistentVolumes on each node:
- controlplane (zone-a) -> /mnt/pg-zone-a
- node01       (zone-b) -> /mnt/pg-zone-b

**Before you start:**
1. Run the label script to mark nodes with zones:
   ./00-setup/label-nodes.sh

2. Create the directories on each node (run helper pods):
   ./00-setup/create-local-paths.sh
   Then remove helper pods when done:
   kubectl delete pod helper-create-controlplane helper-create-node01

## Apply
kubectl apply -f pv-zone-a.yaml
kubectl apply -f pv-zone-b.yaml
kubectl apply -f statefulset.yaml

## Test
kubectl get pods -l app=pg -o wide
kubectl exec -it <pod> -- sh -c "echo test-$(date) > /var/lib/postgresql/data/marker.txt"

## Break (simulate zone outage)
kubectl cordon controlplane
kubectl delete pod <pod-running-on-controlplane>

## Fix (options)
- If zone recovers: kubectl uncordon controlplane
- Manual recovery: copy data from /mnt/pg-zone-a backup to /mnt/pg-zone-b and recreate PV with claimRef bound to PVC (advanced)
