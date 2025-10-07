%{ for secret in secrets ~}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: ${secret.name}
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: cluster
spec:
  refreshInterval: 30s
  secretStoreRef:
    name: external-secrets
    kind: ClusterSecretStore
  target:
    creationPolicy: Owner
    template:
      metadata:
        labels:
          argocd.argoproj.io/secret-type: cluster
      data:
        name: "{{ .name }}"
        server: "{{ .host }}"
        config: |
          {
            "tlsClientConfig": {
              "insecure": false,
              "caData": "{{ .cluster_ca_certificate }}"
            },
            "awsAuthConfig": {
              "clusterName": "{{ .name }}",
              "roleARN": "{{ .role_arn }}"
            }
          }
  dataFrom:
    - extract:
        key: argocd/clusters/${secret.name}
---
%{ endfor }
