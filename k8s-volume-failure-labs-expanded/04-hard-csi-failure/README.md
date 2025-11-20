# CSI failure simulation (lab) — Expanded

This directory contains helper scripts to simulate CSI controller failure by scaling down any Deployment with 'csi' in the name.

Files:
- sc2-pvc-pod.yaml      - PVC and Pod to test provisioning
- break-csi.sh          - scale down CSI-related deployments (detects names with 'csi')
- fix-csi.sh            - scale them back up to 1 replica
- run-lab.sh            - simple wrapper to apply/test/break/fix

## Wrapper usage
- Apply: ./run-lab.sh apply
- Test:  ./run-lab.sh test
- Break: ./run-lab.sh break   (this will attempt to scale down csi deployments; do NOT run in production)
- Fix:  ./run-lab.sh fix

