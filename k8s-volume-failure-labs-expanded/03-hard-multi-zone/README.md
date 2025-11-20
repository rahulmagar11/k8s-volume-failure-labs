# Hard: Multi-zone (simulated) StatefulSet — Expanded

This scenario simulates two zones using node labels. Nodes used:
- controlplane (zone-a)
- node01 (zone-b)

ASCII Diagram:
```
 zone-a (controlplane)             zone-b (node01)
+----------------------+         +----------------------+
|  PV: /mnt/pg-zone-a  |         |  PV: /mnt/pg-zone-b  |
|  Pod: pg-0 (app=pg)  |         |  Pod: pg-1 (app=pg)  |
+----------------------+         +----------------------+
          \                           //
           \____ StatefulSet: pg ____//
                 (volumeClaimTemplates)
```
Files:
- pv-zone-a.yaml
- pv-zone-b.yaml
- statefulset.yaml
- run-lab.sh (wrapper)

## Wrapper usage
- Apply: ./run-lab.sh apply
- Test:  ./run-lab.sh test
- Break: CONFIRM=YES ./run-lab.sh break
- Fix:  CONFIRM=YES ./run-lab.sh fix

## Important notes
- Local PV + nodeAffinity prevents pods from moving to other nodes automatically.
- To recover when a zone is permanently down, you must move data (backup/rsync) to another node and recreate a PV bound to the PVC (advanced).
