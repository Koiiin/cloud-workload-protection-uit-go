# Kubescape Manifest Remediation Demo

## Mục tiêu

Demo này dùng Kubescape để phát hiện lỗi bảo mật trong Kubernetes manifest trước khi deploy workload lên cluster.

Nhóm tạo một manifest cấu hình sai cho `driver-service`, sau đó tạo một manifest đã được hardening và scan lại để so sánh kết quả before/after.

## Bad Manifest

File:

`k8s/bad-manifests/driver-service-bad.yaml`

Các lỗi cố tình cấu hình:

| Lỗi | Cấu hình gây lỗi |
|---|---|
| HostNetwork access | `hostNetwork: true` |
| HostPath mount | mount `/var/run/docker.sock` bằng `hostPath` |
| Container chạy root | `runAsUser: 0` |
| Privileged container | `privileged: true` |
| Cho phép privilege escalation | `allowPrivilegeEscalation: true` |
| ServiceAccount token tự động mount | `automountServiceAccountToken: true` |
| Thiếu resource limits | Không có `resources.requests/limits` |

Kubescape phát hiện các lỗi chính:

| Control | Ý nghĩa |
|---|---|
| C-0041 | HostNetwork access |
| C-0048 | HostPath mount |
| C-0013 | Non-root containers |
| C-0057 | Privileged container |

## Secure Manifest

File:

`k8s/secure-manifests/driver-service-secure.yaml`

Các cấu hình đã hardening:

| Biện pháp | Cấu hình |
|---|---|
| Không dùng host network | `hostNetwork: false` |
| Chạy non-root | `runAsNonRoot: true`, `runAsUser: 10001` |
| Tắt privileged | `privileged: false` |
| Chặn privilege escalation | `allowPrivilegeEscalation: false` |
| Drop Linux capabilities | `capabilities.drop: ["ALL"]` |
| Read-only filesystem | `readOnlyRootFilesystem: true` |
| Thêm resource limit | `resources.requests/limits` |
| Thêm health check | `readinessProbe`, `livenessProbe` |
| Tắt automount token | `automountServiceAccountToken: false` |
| Thêm NetworkPolicy | Chỉ cho phép traffic cần thiết |

## Kết quả so sánh

| Giai đoạn | Kết quả |
|---|---|
| Before | Kubescape phát hiện nhiều lỗi workload security |
| After | `All controls passed. No issues found` |
| Secure manifest compliance score | 96 |

## Kết luận

Kết quả demo cho thấy Kubescape có thể phát hiện sớm misconfiguration trong Kubernetes manifest trước khi workload được deploy.

Sau khi áp dụng các cấu hình hardening như non-root container, tắt privileged, chặn privilege escalation, drop capabilities, resource limits, health probes và NetworkPolicy, kết quả scan được cải thiện rõ ràng.
