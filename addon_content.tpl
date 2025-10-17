%{ for name, tags in secrets ~}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: ${name}
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: cluster
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: external-secrets
    kind: ClusterSecretStore
  target:
    creationPolicy: Owner
    template:
      metadata:
        labels:
          argocd.argoproj.io/secret-type: cluster
%{ for key, value in tags ~}
          ${ key }: ${ value }
%{ endfor }
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
        key: argocd/clusters/${name}
---
%{ endfor }
