# DataShield Helm Chart Security Guide

This guide covers the comprehensive security features implemented in the DataShield Helm chart, including secure secret management, security contexts, and production hardening.

## Overview

The DataShield Helm chart implements enterprise-grade security features:

1. **Secure Secret Management**: Automatic random secret generation with external secret support
2. **Security Contexts**: All containers run as non-root users with security constraints
3. **Network Security**: Ready for network policies and service mesh integration
4. **Resource Security**: Defined limits to prevent resource exhaustion attacks
5. **Access Control**: Service account management with least-privilege principles

## Secret Management

The chart supports multiple secure approaches to secret management, eliminating the need for plaintext passwords in configuration files.

### Automatic Secret Generation (Default)

By default, the chart generates secure 16-character alphanumeric passwords for all enabled components:

```yaml
# No secret configuration needed - secure defaults are used
opal:
  enabled: true
  # existingSecret: ""  # Leave empty for auto-generation
```

### External Secret Integration

For production environments, reference existing Kubernetes secrets:

```yaml
# Production values.yaml using external secrets
externalDatabases:
  mongodb:
    host: "mongodb.database.svc.cluster.local"
    port: 27017
    existingSecret: "mongodb-credentials"
    existingSecretKeys:
      user: "username"
      password: "password"
  
  mysql:
    host: "mysql.database.svc.cluster.local"
    port: 3306
    database: "datashield"
    existingSecret: "mysql-credentials"
    existingSecretKeys:
      user: "username"
      password: "password"

opal:
  config:
    existingSecret: "opal-credentials"

agate:
  enabled: true
  config:
    existingSecret: "agate-credentials"

mica:
  enabled: true
  config:
    existingSecret: "mica-credentials"
```

### Integration with External Secret Management

The chart works seamlessly with external secret management systems:

#### External Secrets Operator
```yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "https://vault.company.com"
      path: "secret"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "datashield"
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: datashield-secrets
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: vault-backend
    kind: SecretStore
  target:
    name: datashield-opal-secret
  data:
  - secretKey: opal-administrator-password
    remoteRef:
      key: datashield/opal
      property: admin-password
```

#### Sealed Secrets
```bash
# Create sealed secret for Opal
kubectl create secret generic opal-credentials \
  --from-literal=opal-administrator-password=my-secure-password \
  --dry-run=client -o yaml | \
  kubeseal -o yaml > opal-sealed-secret.yaml
```

## Required Secret Keys

When creating external secrets, ensure they contain the following keys:

### Component Secrets

| Component | Secret Keys | Description |
|-----------|-------------|-------------|
| **Opal** | `opal-administrator-password` | Administrator password for Opal web interface |
| **Opal Demo** | `opal-demo-user-password` | Demo user password (when demo mode enabled) |
| **Agate** | `agate-administrator-password` | Administrator password for Agate auth server |
| **Mica** | `mica-administrator-password` | Administrator password for Mica catalog |

### External Database Secrets

For external databases, the following keys are supported:

| Database | Secret Keys | Description |
|----------|-------------|-------------|
| **MongoDB** | `host`, `port`, `user`, `password` | MongoDB connection credentials |
| **MySQL** | `host`, `port`, `database`, `user`, `password` | MySQL connection credentials |
| **MariaDB** | `host`, `port`, `database`, `user`, `password` | MariaDB connection credentials |
| **PostgreSQL** | `host`, `port`, `database`, `user`, `password` | PostgreSQL connection credentials |
## Creating External Secrets

### Component Secrets

#### Opal Secret
```bash
kubectl create secret generic opal-credentials \
  --from-literal=opal-administrator-password=my-secure-admin-password
```

#### Agate Secret
```bash
kubectl create secret generic agate-credentials \
  --from-literal=agate-administrator-password=my-secure-admin-password
```

#### Mica Secret
```bash
kubectl create secret generic mica-credentials \
  --from-literal=mica-administrator-password=my-secure-admin-password
```

### External Database Secrets

#### MongoDB Secret
```bash
kubectl create secret generic mongodb-credentials \
  --from-literal=host=mongodb.database.svc.cluster.local \
  --from-literal=port=27017 \
  --from-literal=user=datashield_user \
  --from-literal=password=my-secure-password
```

#### MySQL Secret
```bash
kubectl create secret generic mysql-credentials \
  --from-literal=host=mysql.database.svc.cluster.local \
  --from-literal=port=3306 \
  --from-literal=database=datashield \
  --from-literal=user=datashield_user \
  --from-literal=password=my-secure-password
```

## Security Contexts & Container Hardening

The chart implements comprehensive security contexts for all containers:

### Pod Security Context
```yaml
podSecurityContext:
  runAsNonRoot: true
  runAsUser: 10041      # Non-privileged user
  runAsGroup: 10041     # Non-privileged group
  fsGroup: 10041        # File system group for volume permissions
```

### Container Security Context
```yaml
securityContext:
  capabilities:
    drop: ["ALL"]                    # Drop all capabilities
  readOnlyRootFilesystem: false      # Application needs write access
  runAsNonRoot: true
  runAsUser: 10041
  runAsGroup: 10041
  allowPrivilegeEscalation: false    # Prevent privilege escalation
```

### Security Benefits
- **Non-root execution**: All containers run as UID 10041 (non-privileged)
- **Capability dropping**: All Linux capabilities are dropped
- **No privilege escalation**: Prevents container breakout attempts
- **Proper file permissions**: fsGroup ensures volume access without root

## Network Security

### Service Configuration
- All services use ClusterIP by default (no external exposure)
- Ingress controller required for external access
- Support for network policies (when enabled)

### Network Policy Example
```yaml
# Enable in values.yaml
networkPolicy:
  enabled: true
  ingress:
    - from:
      - namespaceSelector:
          matchLabels:
            name: ingress-nginx
      ports:
      - protocol: TCP
        port: 8080
  egress:
    - to:
      - namespaceSelector:
          matchLabels:
            name: database
      ports:
      - protocol: TCP
        port: 27017
      - protocol: TCP
        port: 3306
```

## Resource Security

### Resource Limits
All components have defined resource limits to prevent resource exhaustion:

```yaml
# Example resource configuration
opal:
  resources:
    limits:
      cpu: 2000m
      memory: 4Gi
    requests:
      cpu: 1000m
      memory: 2Gi
```

### Benefits
- **DoS Prevention**: Resource limits prevent single pods from consuming all cluster resources
- **Quality of Service**: Requests ensure predictable performance
- **Cluster Stability**: Prevents cascading failures due to resource starvation

## Migration from Previous Versions

### Upgrading from Legacy Versions

If upgrading from versions that used plaintext passwords in `values.yaml`:

1. **Backup existing data**: Ensure all persistent data is backed up
2. **Remove plaintext passwords**: Remove password fields from your `values.yaml`
3. **Choose migration strategy**:

#### Option A: Auto-Generated Secrets (Recommended for New Deployments)
```yaml
# New values.yaml - no passwords needed
opal:
  enabled: true
  # existingSecret: ""  # Auto-generation enabled
```

#### Option B: Migrate to External Secrets (Recommended for Production)
```bash
# Create secrets with your existing passwords
kubectl create secret generic opal-credentials \
  --from-literal=opal-administrator-password=your-existing-password

# Update values.yaml to reference the secret
opal:
  config:
    existingSecret: "opal-credentials"
```

### Post-Migration Verification
```bash
# Verify secret creation
kubectl get secrets | grep datashield

# Test application access with new credentials
kubectl get secret RELEASE-NAME-datashield-secrets -o jsonpath='{.data.opal-administrator-password}' | base64 --decode
```

## Production Security Checklist

### Deployment Security
- [ ] Use external secrets for all credentials
- [ ] Enable network policies
- [ ] Configure proper ingress with TLS
- [ ] Set resource limits for all containers
- [ ] Use dedicated service accounts
- [ ] Enable pod security policies/standards

### Operational Security
- [ ] Regularly rotate secrets
- [ ] Monitor access logs
- [ ] Implement backup and disaster recovery
- [ ] Keep container images updated
- [ ] Monitor security vulnerabilities
- [ ] Implement proper RBAC

### Database Security
- [ ] Use external database with encryption at rest
- [ ] Enable database authentication
- [ ] Configure database network isolation
- [ ] Regular database security updates
- [ ] Database access monitoring

### Monitoring & Alerting
- [ ] Security event monitoring
- [ ] Failed authentication alerts
- [ ] Resource usage monitoring  
- [ ] Certificate expiration alerts
- [ ] Vulnerability scanning alerts

## Best Practices

### Secret Management
1. **Use external secret management**: For production, integrate with HashiCorp Vault, AWS Secrets Manager, or similar
2. **Regular rotation**: Implement automated secret rotation policies
3. **Least privilege**: Use dedicated service accounts with minimal required permissions
4. **Audit access**: Monitor and log all secret access
5. **Backup considerations**: Include secrets in disaster recovery planning

### Container Security
1. **Image scanning**: Regularly scan container images for vulnerabilities
2. **Minimal base images**: Use distroless or minimal base images when possible
3. **Update frequency**: Keep container images updated with latest security patches
4. **Runtime security**: Consider runtime security tools like Falco
5. **Image signing**: Use signed container images in production

### Network Security
1. **Network segmentation**: Use network policies to limit inter-pod communication
2. **Service mesh**: Consider implementing Istio or Linkerd for enhanced security
3. **TLS everywhere**: Enable TLS for all internal and external communications
4. **Ingress security**: Use WAF and rate limiting on ingress controllers
5. **DNS security**: Implement DNS-based security controls

### Operational Security
1. **RBAC**: Implement proper role-based access control
2. **Monitoring**: Deploy comprehensive monitoring and alerting
3. **Incident response**: Have documented incident response procedures
4. **Compliance**: Ensure compliance with relevant security standards
5. **Security testing**: Regular penetration testing and security assessments

## Accessing Generated Secrets

To retrieve automatically generated secrets:

```bash
# List all secrets
kubectl get secrets | grep datashield

# Get the main secret name (usually <release-name>-datashield-secrets)
kubectl get secrets

# Decode specific secret values
kubectl get secret RELEASE-NAME-datashield-secrets -o jsonpath='{.data.opal-administrator-password}' | base64 --decode

# View all secret keys (without values)
kubectl describe secret RELEASE-NAME-datashield-secrets
```

## Troubleshooting Security Issues

### Common Security Issues

#### 1. Permission Denied Errors
```bash
# Check pod security context
kubectl describe pod POD-NAME | grep -A 10 "Security Context"

# Verify volume permissions
kubectl exec POD-NAME -- ls -la /srv/
```

#### 2. Secret Not Found Errors
```bash
# Verify secret exists
kubectl get secret SECRET-NAME

# Check secret keys
kubectl describe secret SECRET-NAME

# Verify secret is in correct namespace
kubectl get secrets -n NAMESPACE
```

#### 3. Authentication Failures
```bash
# Retrieve generated password
kubectl get secret RELEASE-NAME-datashield-secrets -o jsonpath='{.data.opal-administrator-password}' | base64 --decode

# Check if external secret is properly referenced
kubectl describe deployment DEPLOYMENT-NAME | grep -A 5 "Environment"
```

#### 4. Network Connectivity Issues
```bash
# Test internal connectivity
kubectl run test-pod --rm -i --tty --image=busybox -- /bin/sh
# Inside pod: wget -qO- http://opal-service:8080/health

# Check network policies
kubectl get networkpolicy
kubectl describe networkpolicy POLICY-NAME
```

### Security Validation Commands

```bash
# Validate security contexts
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.securityContext.runAsUser}{"\n"}{end}'

# Check for running containers as root
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[*].securityContext.runAsUser}{"\n"}{end}' | grep -v 10041

# Verify resource limits are set
kubectl describe pods | grep -A 5 "Limits:"

# Check service account configuration
kubectl get serviceaccounts
kubectl describe serviceaccount datashield

# Audit secret usage
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.volumes[?(@.secret)]}{"\n"}{end}'
```

### Security Monitoring

#### Log Analysis
```bash
# Check authentication logs
kubectl logs deployment/RELEASE-NAME-datashield-opal | grep -i auth

# Monitor failed login attempts
kubectl logs deployment/RELEASE-NAME-datashield-opal | grep -i "failed\|error\|denied"

# Check security context violations
kubectl get events | grep -i security
```

#### Health Checks
```bash
# Verify all components are healthy
kubectl get pods -l app.kubernetes.io/instance=RELEASE-NAME

# Check readiness probes
kubectl describe pods | grep -A 3 "Readiness:"

# Test external connectivity (if ingress enabled)
curl -k https://datashield.local/
```

For additional security hardening and compliance requirements, consult your organization's security team and consider implementing additional security tools such as Pod Security Standards (PSS), Falco for runtime security monitoring, and regular security assessments.
