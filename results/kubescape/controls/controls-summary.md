# Kubescape Control Scan Summary

## Mục tiêu

Nhóm sử dụng Kubescape để scan các control bảo mật quan trọng trên RKE2 cluster sau khi cài Rancher. Kết quả này được dùng làm baseline trước khi deploy UIT-Go và trước khi áp dụng hardening.

## Danh sách control đã scan

| Control ID | Tên control | Nhóm rủi ro | File evidence |
|---|---|---|---|
| C-0260 | Missing Network Policy | Network Security | C-0260-missing-network-policy.txt |
| C-0013 | Non-root containers | Workload Security | C-0013-non-root-containers.txt |
| C-0057 | Privileged container | Workload Security | C-0057-privileged-container.txt |
| C-0041 | HostNetwork access | Workload Security | C-0041-hostnetwork-access.txt |
| C-0048 | HostPath mount | Workload Security | C-0048-hostpath-mount.txt |
| C-0015 | List Kubernetes secrets | Access Control / Secrets | C-0015-list-secrets.txt |
| C-0035 | Administrative Roles | RBAC / Access Control | C-0035-administrative-roles.txt |

## Ý nghĩa security

### C-0260 — Missing Network Policy

Control này kiểm tra workload/namespace có được bảo vệ bằng Kubernetes NetworkPolicy hay không. Nếu thiếu NetworkPolicy, pod có thể giao tiếp quá rộng, làm tăng rủi ro lateral movement.

### C-0013 — Non-root containers

Control này kiểm tra container có cấu hình chạy non-root hay không. Container chạy root làm tăng rủi ro privilege escalation nếu workload bị compromise.

### C-0057 — Privileged container

Control này kiểm tra container có chạy ở chế độ privileged hay không. Privileged container có quyền rất cao và có thể ảnh hưởng đến host.

### C-0041 — HostNetwork access

Control này kiểm tra pod có dùng network namespace của host hay không. hostNetwork làm tăng rủi ro truy cập trực tiếp network stack của node.

### C-0048 — HostPath mount

Control này kiểm tra pod có mount file system từ host vào container hay không. hostPath có thể làm container truy cập dữ liệu nhạy cảm trên node.

### C-0015 — List Kubernetes secrets

Control này kiểm tra quyền list secrets trong cluster. Quyền list secrets quá rộng có thể làm lộ token, credential, database password hoặc API key.

### C-0035 — Administrative Roles

Control này kiểm tra các role hoặc subject có quyền quản trị cao. Quyền admin quá rộng làm tăng rủi ro privilege escalation.

## Kết luận baseline

Kết quả scan cho thấy cluster sau khi cài RKE2/Rancher vẫn còn nhiều điểm cần hardening, đặc biệt ở các nhóm: NetworkPolicy, workload securityContext, RBAC và quyền truy cập secrets. Các kết quả này sẽ được dùng để so sánh với lần scan sau khi nhóm deploy UIT-Go và áp dụng các cấu hình bảo mật như NetworkPolicy, runAsNonRoot, resource limits, allowPrivilegeEscalation=false và drop capabilities.
