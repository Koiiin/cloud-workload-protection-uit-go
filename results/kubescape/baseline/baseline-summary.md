# Kubescape Baseline Scan Summary

## Cluster

- Cluster name: default
- Kubernetes distribution: RKE2
- Rancher UI: installed
- Scan type: Kubescape cluster scan

## Compliance Score

- MITRE: 62.89%
- NSA: 65.79%

## Key Findings

### Control Plane

- Anonymous access enabled
- Audit logs not enabled
- Secret/etcd encryption not enabled
- RBAC enabled
- API server insecure port is not enabled

### Access Control

- Administrative roles: 16 resources
- List Kubernetes secrets: 43 resources
- Create pods privileges: 17 resources
- Wildcard roles: 16 resources
- Port-forwarding privileges: 16 resources
- Delete capabilities: 37 resources

### Secrets

- Applications credentials in configuration files: 10 resources

### Network

- Missing NetworkPolicy: 28 resources

### Workload

- HostNetwork access: 4 resources
- HostPath mount: 3 resources
- Non-root containers: 19 resources
- Privileged container: 1 resource

## Highest-stake Workloads

1. Deployment/rancher in namespace cattle-system
2. Pod/cloud-controller-manager-rke2-cwp in namespace kube-system
3. DaemonSet/rke2-canal in namespace kube-system

## Interpretation

This baseline represents the initial security posture of the RKE2 cluster after Rancher installation and before deploying the UIT-Go application. The result will be used as a reference point to compare with later scans after applying security hardening such as NetworkPolicy, securityContext, non-root containers, resource limits, and restricted workload permissions.
