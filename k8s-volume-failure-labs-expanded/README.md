# Kubernetes Volume Failure Labs (GitHub-ready)

This repository contains a set of progressive labs (Intermediate → Hard) to practice Kubernetes volume behaviors, failures, and recovery techniques.
Node names used in YAML/scripts: **controlplane**, **node01**

**IMPORTANT**: Run these labs in a test cluster only. Many steps are destructive by design and are only safe in non-production environments.

## Directory overview
- 00-setup: helper scripts to label nodes and create local directories used by local PVs.
- 01-intermediate-rwx-nfs: in-cluster NFS server + RWX PVC with writer/reader pods.
- 02-advanced-stateful-retain: StatefulSet with PV that uses `Retain` reclaim policy.
- 03-hard-multi-zone: Simulated multi-zone StatefulSet + local PVs on two nodes.
- 04-hard-csi-failure: Scripts to simulate CSI controller failure (detects deployments with 'csi' in name).
- 05-hard-volume-corruption-recovery: Backup, safe-corrupt (move), and restore helpers for Postgres.

## Quick start
1. Clone this repo (or unzip the provided archive).
2. Inspect YAML and README in each folder.
3. Start with 00-setup steps to label nodes and create host-path backing directories.

## Safety
- BACKUP DATA before running destructive actions.
- Do not run CSI-simulating scripts in clusters with critical workloads.
- Use non-production clusters such as kind/minikube for these labs.

