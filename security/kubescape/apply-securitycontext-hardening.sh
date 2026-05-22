#!/bin/bash

set -e

NS="uit-go-app"

patch_workload() {
  DEPLOYMENT_NAME="$1"
  CONTAINER_NAME="$2"
  RUN_AS_USER="$3"
  RUN_AS_GROUP="$4"
  FS_GROUP="$5"

  echo "[+] Hardening ${DEPLOYMENT_NAME}"

  kubectl -n "$NS" patch deployment "$DEPLOYMENT_NAME" --type='strategic' -p "{
    \"spec\": {
      \"template\": {
        \"spec\": {
          \"securityContext\": {
            \"runAsNonRoot\": true,
            \"runAsUser\": ${RUN_AS_USER},
            \"runAsGroup\": ${RUN_AS_GROUP},
            \"fsGroup\": ${FS_GROUP},
            \"seccompProfile\": {
              \"type\": \"RuntimeDefault\"
            }
          },
          \"containers\": [
            {
              \"name\": \"${CONTAINER_NAME}\",
              \"securityContext\": {
                \"allowPrivilegeEscalation\": false,
                \"privileged\": false,
                \"capabilities\": {
                  \"drop\": [\"ALL\"]
                }
              }
            }
          ]
        }
      }
    }
  }"
}

echo "[+] Applying securityContext hardening for application workloads"

patch_workload "api-gateway" "api-gateway" 1000 1000 1000
patch_workload "user-service" "user-service" 1000 1000 1000
patch_workload "driver-service" "driver-service" 1000 1000 1000
patch_workload "trip-service" "trip-service" 1000 1000 1000
patch_workload "mongodb" "mongodb" 999 999 999

echo "[+] Applying secure PostgreSQL manifest"
kubectl apply -f k8s/secure-app/postgres-secure.yaml

echo "[+] Waiting for rollouts"

kubectl -n "$NS" rollout status deployment/api-gateway --timeout=180s
kubectl -n "$NS" rollout status deployment/user-service --timeout=180s
kubectl -n "$NS" rollout status deployment/driver-service --timeout=180s
kubectl -n "$NS" rollout status deployment/trip-service --timeout=180s
kubectl -n "$NS" rollout status deployment/mongodb --timeout=180s
kubectl -n "$NS" rollout status deployment/postgresql --timeout=180s

echo "[+] SecurityContext hardening completed"
kubectl get pods -n "$NS"
