# CSI failure simulation (lab)
This directory contains helper scripts to simulate CSI controller failure by scaling down any Deployment with 'csi' in the name.

**WARNING**: Do NOT run this in a production cluster with real workloads. Use test cluster only.

Files:
- sc2-pvc-pod.yaml      - PVC and Pod to test provisioning
- break-csi.sh          - scale down CSI-related deployments (detects names with 'csi')
- fix-csi.sh            - scale them back up to 1 replica

Usage:
1. kubectl apply -f sc2-pvc-pod.yaml
2. ./break-csi.sh      # simulate broken CSI control plane
3. Try creating another PVC to see failure
4. ./fix-csi.sh        # restore CSI controllers
