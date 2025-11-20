# Advanced: StatefulSet with Retain PV (lab) — Expanded

This demonstrates a StatefulSet writing to a PVC/PV. The PV uses reclaimPolicy=Retain so that when the StatefulSet is deleted, data remains on disk.

Diagram:
```
 StatefulSet app-0  ---> PVC data-app-0  ---> PV ss-pv (hostPath: /mnt/data/stateful-demo)
```
Files:
- pv.yaml
- statefulset.yaml
- run-lab.sh

## Wrapper usage
- Apply: ./run-lab.sh apply
- Test:  ./run-lab.sh test
- Break: CONFIRM=YES ./run-lab.sh break
- Fix:  CONFIRM=YES ./run-lab.sh fix

## Notes on recovery
- Because reclaimPolicy=Retain, PV data remains when PVC is deleted. To reuse the PV, either recreate a PV with claimRef matching PVC or set reclaimPolicy to Delete in real dynamic volumes (with backups).

