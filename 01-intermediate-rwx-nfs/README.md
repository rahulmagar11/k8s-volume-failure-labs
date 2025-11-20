# Intermediate: RWX using in-cluster NFS server (lab)
This scenario runs a simple NFS server inside the cluster and two pods that share the same RWX PersistentVolumeClaim.

## How to run
1. kubectl apply -f nfs-server.yaml
2. kubectl apply -f nfs-pvc.yaml
3. kubectl apply -f writer-reader.yaml
4. kubectl logs -f writer
5. kubectl logs -f reader

## Break
Delete the nfs-server pod:
  kubectl delete pod nfs-server

## Fix
Recreate the NFS server and restart pods:
  kubectl apply -f nfs-server.yaml
  kubectl delete pod writer reader
  kubectl apply -f writer-reader.yaml
