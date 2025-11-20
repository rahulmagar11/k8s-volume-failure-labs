# Intermediate: RWX using in-cluster NFS server (lab) — Expanded

This scenario runs a simple NFS server inside the cluster and two pods that share the same RWX PersistentVolumeClaim.

ASCII Diagram:
```
 writer pod           NFS Server (in-cluster)         reader pod
+-----------+         +-----------------+         +--------------+
| /data/log  | <----> | / (exported)    | <---->  | /data/log    |
| writes time|         | (nfs-server)    |         | reads time   |
+-----------+         +-----------------+         +--------------+
```
Files:
- nfs-server.yaml
- nfs-pvc.yaml
- writer-reader.yaml
- run-lab.sh   ← wrapper (apply/test/break/fix)

## Quick run (non-destructive)
1. kubectl apply -f nfs-server.yaml
2. kubectl apply -f nfs-pvc.yaml
3. kubectl apply -f writer-reader.yaml
4. kubectl logs -f writer
5. kubectl logs -f reader

## Use wrapper script
- Apply: ./run-lab.sh apply
- Test:  ./run-lab.sh test
- Break (destructive): CONFIRM=YES ./run-lab.sh break
- Fix: CONFIRM=YES ./run-lab.sh fix
- All (apply->test->break->fix): CONFIRM=YES ./run-lab.sh all

### Safety notes
- The wrapper uses CONFIRM=YES guard to avoid accidental destructive actions.
- The in-cluster NFS is for lab only — not production.

