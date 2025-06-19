# DataShield Helm Chart

A comprehensive, production-ready Helm chart for deploying DataShield, a platform for privacy-preserving federated data analysis.

## Overview

DataShield is a suite of software packages that enable privacy-preserving federated data analysis. This Helm chart deploys the complete DataShield infrastructure with enterprise-grade features:

### Core Components
- **Opal** (5.1.4): Data repository and analysis server with OrientDB backend
- **Rock** (2.1.4): R server for DataShield statistical analysis
- **Agate** (2.8): Optional authentication and authorization server
- **Mica** (5.3): Optional metadata catalog and data discovery portal

### Enterprise Features
- **Secure Secret Management**: Automatic random secret generation or external secret integration
- **Production Hardening**: Security contexts, resource management, health checks
- **High Availability**: Pod disruption budgets, affinity/anti-affinity support
- **GitOps Ready**: Full ArgoCD/Flux compatibility with proper Kubernetes API usage
- **Operational Excellence**: Comprehensive monitoring, testing framework, and documentation

**Database Requirements**: This chart requires external databases to be deployed separately using well-maintained Helm charts (e.g., Bitnami). The chart provides secure configuration options to connect to your existing MongoDB, MySQL, MariaDB, and PostgreSQL instances.

## Security

🔒 **Enterprise Security Features**: This chart implements comprehensive security best practices:

- **Secure Secret Management**: No plaintext passwords in configuration files
- **Automatic Secret Generation**: 16-character random alphanumeric secrets by default
- **External Secret Integration**: Support for existing Kubernetes secrets and external secret management
- **Security Contexts**: All containers run as non-root users with security constraints
- **Network Security**: Ready for network policies and service mesh integration

See [SECURITY.md](SECURITY.md) for detailed security configuration, including:
- Secret management strategies
- Migration from previous versions
- Best practices for production deployments

## Prerequisites

- Kubernetes 1.19+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- External databases (MongoDB, MySQL/MariaDB, or PostgreSQL) deployed separately

## Chart Features

### Deployment Modes
- **Development**: Minimal resources with demo data for testing
- **Production**: High resources with security hardening
- **Hybrid**: Selective component enablement for custom deployments
- **ArgoCD/GitOps**: Full compatibility with declarative deployment workflows

### Security & Compliance
- All containers run as non-root users (UID 10041)
- Automatic secret generation with 16-character random passwords
- Support for external secret management systems
- Security contexts and pod security policies
- Ready for network policy enforcement

### High Availability & Operations
- StatefulSet deployment for Opal (OrientDB doesn't support concurrent access)
- Comprehensive health checks (liveness/readiness probes)
- Pod disruption budgets for controlled rolling updates
- Resource requests/limits for predictable performance
- Node affinity and tolerance support

## Installing the Chart

### Prerequisites

1. **Deploy External Databases**: Before installing DataShield, deploy your required databases using well-maintained Helm charts:

```bash
# Example: Deploy MongoDB using Bitnami chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mongodb bitnami/mongodb \
  --set auth.rootUser=root \
  --set auth.rootPassword=example

# Example: Deploy MySQL using Bitnami chart  
helm install mysql bitnami/mysql \
  --set auth.rootPassword=password \
  --set auth.database=opal \
  --set auth.username=opal \
  --set auth.password=password
```

2. **Install DataShield**: Once your databases are running, install the DataShield chart:

```bash
helm install datashield ./datashield
```

To install with custom database connection values:

```bash
helm install datashield ./datashield -f my-values.yaml
```

Example `my-values.yaml`:
```yaml
externalDatabases:
  mongodb:
    host: "mongodb"
    port: 27017
    user: "root" 
    password: "example"
  mysql:
    host: "mysql"
    port: 3306
    database: "opal"
    user: "opal"
    password: "password"
```

## Uninstalling the Chart

To uninstall/delete the `datashield` deployment:

```bash
helm delete datashield
```

## Configuration

The following table lists the configurable parameters and their default values.

### Global Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.imageRegistry` | Global Docker image registry | `""` |
| `global.imagePullSecrets` | Global Docker registry secret names | `[]` |
| `global.storageClass` | Global storage class for persistent volumes | `""` |

### Service Account

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.annotations` | Service account annotations | `{}` |
| `serviceAccount.name` | Service account name | `""` |

### Security Context

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podSecurityContext.runAsNonRoot` | Pod runs as non-root user | `true` |
| `podSecurityContext.runAsUser` | Pod user ID | `1000` |
| `podSecurityContext.runAsGroup` | Pod group ID | `1000` |
| `podSecurityContext.fsGroup` | Pod filesystem group ID | `1000` |
| `securityContext.capabilities.drop` | Container security context capabilities to drop | `["ALL"]` |
| `securityContext.readOnlyRootFilesystem` | Container read-only root filesystem | `false` |
| `securityContext.runAsNonRoot` | Container runs as non-root | `true` |
| `securityContext.runAsUser` | Container user ID | `1000` |
| `securityContext.runAsGroup` | Container group ID | `1000` |
| `securityContext.allowPrivilegeEscalation` | Allow privilege escalation | `false` |

### External Database Configuration

DataShield requires external databases to be deployed separately. Configure the connection details below.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `externalDatabases.mongodb.host` | MongoDB hostname | `mongo` |
| `externalDatabases.mongodb.port` | MongoDB port | `27017` |
| `externalDatabases.mongodb.user` | MongoDB username | `root` |
| `externalDatabases.mongodb.password` | MongoDB password | `example` |
| `externalDatabases.mongodb.existingSecret` | Use existing secret for MongoDB | `""` |
| `externalDatabases.mysql.host` | MySQL hostname | `mysqldata` |
| `externalDatabases.mysql.port` | MySQL port | `3306` |
| `externalDatabases.mysql.database` | MySQL database name | `opal` |
| `externalDatabases.mysql.user` | MySQL username | `opal` |
| `externalDatabases.mysql.password` | MySQL password | `password` |
| `externalDatabases.mysql.existingSecret` | Use existing secret for MySQL | `""` |
| `externalDatabases.mariadb.host` | MariaDB hostname | `mariadbdata` |
| `externalDatabases.mariadb.port` | MariaDB port | `3306` |
| `externalDatabases.mariadb.database` | MariaDB database name | `opal` |
| `externalDatabases.mariadb.user` | MariaDB username | `opal` |
| `externalDatabases.mariadb.password` | MariaDB password | `password` |
| `externalDatabases.mariadb.existingSecret` | Use existing secret for MariaDB | `""` |
| `externalDatabases.postgresql.host` | PostgreSQL hostname | `postgresdata` |
| `externalDatabases.postgresql.port` | PostgreSQL port | `5432` |
| `externalDatabases.postgresql.database` | PostgreSQL database name | `opal` |
| `externalDatabases.postgresql.user` | PostgreSQL username | `opal` |
| `externalDatabases.postgresql.password` | PostgreSQL password | `password` |
| `externalDatabases.postgresql.existingSecret` | Use existing secret for PostgreSQL | `""` |

### Opal Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `opal.enabled` | Enable Opal deployment | `true` |
| `opal.image.repository` | Opal image repository | `obiba/opal` |
| `opal.image.tag` | Opal image tag | `5.1.4` |
| `opal.image.pullPolicy` | Opal image pull policy | `IfNotPresent` |
| `opal.service.type` | Opal service type | `ClusterIP` |
| `opal.service.port` | Opal service port | `8080` |
| `opal.persistence.enabled` | Enable Opal persistence | `true` |
| `opal.persistence.size` | Opal persistent volume size | `2Gi` |
| `opal.persistence.accessMode` | Opal PVC access mode (ReadWriteOnce for OrientDB) | `ReadWriteOnce` |
| `opal.config.existingSecret` | Use existing secret for Opal config | `""` |
| `opal.config.csrfAllowed` | CSRF allowed hosts | `datashield.local` |
| `opal.config.customPropertiesFile` | Custom opal-config.properties content | `""` |
| `opal.demo.enabled` | Enable demo data loading | `true` |
| `opal.demo.userName` | Demo user name | `dsuser` |
| `opal.resources.limits.cpu` | CPU limit | `2000m` |
| `opal.resources.limits.memory` | Memory limit | `4Gi` |
| `opal.resources.requests.cpu` | CPU request | `1000m` |
| `opal.resources.requests.memory` | Memory request | `2Gi` |

#### Custom Opal Configuration Properties

You can provide your own `opal-config.properties` file in several ways:

1. **Using `--set-file` during Helm install:**
   ```bash
   helm install datashield ./charts/datashield \
     --set-file opal.config.customPropertiesFile=./my-opal-config.properties
   ```

2. **Using Kustomize overlays** (ideal for different environments):
   
   **Option A: Target by label selector (recommended):**
   ```yaml
   # kustomization.yaml
   resources:
     - ../../base
   
   patches:
     - path: opal-config-patch.yaml
       target:
         kind: ConfigMap
         labelSelector: "app.kubernetes.io/component=opal"
   
   # opal-config-patch.yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: any-name  # Name is ignored when using labelSelector
   data:
     org.obiba.opal.http.port: "9090"
     csrf.allowed: "production.datashield.local"
   ```
   
   **Option B: Target by exact name:**
   ```yaml
   # kustomization.yaml
   resources:
     - ../../base
   
   patches:
     - path: opal-config-patch.yaml
       target:
         kind: ConfigMap
         name: datashield-opal-config  # Must match the generated name
   
   # opal-config-patch.yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: datashield-opal-config
   data:
     org.obiba.opal.http.port: "9090"
     csrf.allowed: "production.datashield.local"
   ```
3. **In values.yaml using a multiline string:**
   ```yaml
   opal:
     config:
       customPropertiesFile: |
         # Custom Opal Configuration
         org.obiba.opal.http.port=8080
         org.obiba.opal.https.port=-1
         # ... other properties
   ```

**How it works:**
- The properties file (default or custom) is parsed into individual key-value pairs in a ConfigMap
- Each property becomes a separate key in the ConfigMap (perfect for Kustomize patching)
- The ConfigMap is mounted as individual files in `/etc/opal-config/`
- The startup script reconstructs `/srv/conf/opal-config.properties` from these individual files
- Opal's own `/opt/opal/bin/start.sh` script then processes this file and merges it with environment variables
- This approach allows Kustomize users to patch individual properties without replacing the entire configuration

If no custom properties file is provided, the chart will use the default `config/opal-config.properties` included with the chart.

### Rock Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `rock.enabled` | Enable Rock deployment | `true` |
| `rock.replicaCount` | Number of Rock replicas | `1` |
| `rock.image.repository` | Rock image repository | `obiba/rock` |
| `rock.image.tag` | Rock image tag | `2.1.4` |
| `rock.image.pullPolicy` | Rock image pull policy | `IfNotPresent` |
| `rock.service.type` | Rock service type | `ClusterIP` |
| `rock.service.port` | Rock service port | `8085` |
| `rock.config.existingSecret` | Use existing secret for Rock config | `""` |
| `rock.config.administratorName` | Rock administrator name | `administrator` |
| `rock.config.managerName` | Rock manager name | `manager` |
| `rock.config.userName` | Rock user name | `user` |
| `rock.resources.limits.cpu` | CPU limit | `2000m` |
| `rock.resources.limits.memory` | Memory limit | `4Gi` |
| `rock.resources.requests.cpu` | CPU request | `1000m` |
| `rock.resources.requests.memory` | Memory request | `2Gi` |

### Agate Configuration (Optional)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `agate.enabled` | Enable Agate deployment | `false` |
| `agate.image.repository` | Agate image repository | `obiba/agate` |
| `agate.image.tag` | Agate image tag | `2.8` |
| `agate.service.port` | Agate service port | `8081` |
| `agate.config.existingSecret` | Use existing secret for Agate config | `""` |

### Mica Configuration (Optional)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mica.enabled` | Enable Mica deployment | `false` |
| `mica.image.repository` | Mica image repository | `obiba/mica` |
| `mica.image.tag` | Mica image tag | `5.3` |
| `mica.service.port` | Mica service port | `8082` |
| `mica.config.existingSecret` | Use existing secret for Mica config | `""` |
| `mica.config.javaOpts` | JVM options for Mica | `"-Xmx2G"` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `true` |
| `ingress.className` | Ingress class name | `nginx` |
| `ingress.host` | Ingress hostname | `datashield.local` |
| `ingress.annotations` | Ingress annotations | See values.yaml |
| `ingress.tls` | Ingress TLS configuration | See values.yaml |

### Advanced Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podDisruptionBudget.enabled` | Enable pod disruption budget | `false` |
| `podDisruptionBudget.minAvailable` | Minimum available pods | `1` |
| `autoscaling.enabled` | Enable horizontal pod autoscaling | `false` |
| `networkPolicy.enabled` | Enable network policies | `false` |
| `monitoring.enabled` | Enable monitoring | `false` |
| `tests.enabled` | Enable test pods | `true` |

## Examples

### Basic Installation

```bash
helm install datashield ./datashield
```

### Installation Examples

#### Basic Installation with External Databases

1. Deploy MongoDB using Bitnami chart:
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mongodb bitnami/mongodb \
  --set auth.rootUser=root \
  --set auth.rootPassword=example
```

2. Deploy DataShield:
```bash
helm install datashield ./datashield
```

#### Installation with Custom Database Connection

```yaml
# custom-db-values.yaml
externalDatabases:
  mongodb:
    host: "my-mongodb.example.com"
    port: 27017
    user: "datashield_user"
    password: "secure-password"
  mysql:
    host: "my-mysql.example.com"
    port: 3306
    database: "datashield_db"
    user: "datashield_user"
    password: "secure-password"

opal:
  config:
    administratorPassword: "my-secure-opal-password"
```

```bash
helm install datashield ./datashield -f custom-db-values.yaml
```

#### Installation with External Secrets

```yaml
# external-secrets-values.yaml
externalDatabases:
  mongodb:
    existingSecret: "mongodb-credentials"
    existingSecretKeys:
      host: "hostname"
      port: "port"
      user: "username"
      password: "password"
  mysql:
    existingSecret: "mysql-credentials"
    existingSecretKeys:
      host: "hostname"
      port: "port"
      database: "database"
      user: "username"
      password: "password"

opal:
  config:
    existingSecret: "opal-credentials"
```

```bash
helm install datashield ./datashield -f external-secrets-values.yaml
```

#### Production Installation with High Availability

```yaml
# production-values.yaml
# External database configuration
externalDatabases:
  mongodb:
    host: "prod-mongodb.example.com"
    port: 27017
    user: "datashield"
    existingSecret: "mongodb-credentials"  # Use external secrets for production
  mysql:
    host: "prod-mysql.example.com"
    port: 3306
    database: "datashield"
    user: "datashield"
    existingSecret: "mysql-credentials"    # Use external secrets for production

# Production resource limits
opal:
  resources:
    limits:
      cpu: 4000m
      memory: 8Gi
    requests:
      cpu: 2000m
      memory: 4Gi
  persistence:
    size: 100Gi

rock:
  resources:
    limits:
      cpu: 4000m
      memory: 8Gi
    requests:
      cpu: 2000m
      memory: 4Gi

# Enable high availability features
podDisruptionBudget:
  enabled: true
  minAvailable: 1

# Enable all components
agate:
  enabled: true
  
mica:
  enabled: true

# Configure ingress for your domain
ingress:
  host: datashield.example.com
  tls:
    - secretName: datashield-tls

# Use high-performance storage
global:
  storageClass: fast-ssd
```

```bash
helm install datashield ./datashield -f production-values.yaml
```

#### ArgoCD Application Example

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: datashield
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-org/datashield-helm
    targetRevision: HEAD
    path: charts/datashield
    helm:
      valueFiles:
      - values.yaml
      values: |
        externalDatabases:
          mongodb:
            existingSecret: "mongodb-credentials"
          mysql:
            existingSecret: "mysql-credentials"
        ingress:
          host: datashield.company.com
  destination:
    server: https://kubernetes.default.svc
    namespace: datashield
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```

## Accessing the Application

After installation, follow the instructions in the NOTES to get the application URL.

For the default installation:

1. Get the application URL:
   ```bash
   kubectl port-forward service/RELEASE-NAME-datashield-opal 8080:8080
   ```

2. Open your browser to `http://localhost:8080`

3. Login with:
   - Username: `administrator`
   - Password: Use the command below to retrieve the auto-generated password:
   ```bash
   kubectl get secret RELEASE-NAME-datashield-secrets -o jsonpath='{.data.opal-administrator-password}' | base64 --decode
   ```

## Persistence

The chart mounts persistent volumes for:

- Opal data at `/srv`

**Note**: Database persistence is handled by your external database deployments (MongoDB, MySQL, etc.) deployed separately.

## Security Considerations

- **Use External Secrets**: Use Kubernetes secrets or external secret management for production
- **Enable Network Policies**: Implement network policies to restrict communication
- **Configure TLS**: Enable TLS for all external communications
- **Regular Updates**: Keep container images and dependencies updated
- **Resource Limits**: Set appropriate resource limits to prevent resource exhaustion
- **Monitoring**: Implement monitoring and alerting for security events

## High Availability & Production Readiness

### StatefulSet Deployment
- Opal uses StatefulSet deployment due to OrientDB's single-writer limitation
- Ensures data consistency and prevents database corruption
- Supports rolling updates with proper readiness checks

### Resource Management
- All components have defined resource requests and limits
- Memory and CPU limits prevent resource contention
- Configurable resource specifications for different environments

### Health Monitoring
- Comprehensive liveness and readiness probes
- Graceful shutdown handling
- Application-specific health endpoints

### Data Persistence
- Persistent volumes for stateful components
- Configurable storage classes and sizes
- Backup-friendly volume configurations

## Troubleshooting

### Common Issues

1. **Pod stuck in Pending state**
   - Check if PVC can be provisioned
   - Verify resource limits and cluster capacity

2. **Database connection issues**
   - Verify service names and ports
   - Check if database pods are running and ready

3. **Demo data not loading**
   - Check Opal pod logs for demo script execution
   - Verify network access to external data sources

4. **Permission errors with persistent volumes**
   - All containers run as non-root user (1000) for security
   - Persistent volumes are configured with matching fsGroup (1000) for proper permissions
   - If you encounter permission issues, verify your storage class supports fsGroup
   - For additional security, consider using a storage class that supports SecurityContext constraints

### Useful Commands

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/instance=RELEASE-NAME

# Check StatefulSet status for Opal
kubectl get statefulset RELEASE-NAME-datashield-opal

# Check logs
kubectl logs deployment/RELEASE-NAME-datashield-rock
kubectl logs statefulset/RELEASE-NAME-datashield-opal

# Describe pod for events
kubectl describe pod POD-NAME

# Check persistent volume claims
kubectl get pvc

# Check secrets (shows keys but not values)
kubectl describe secret RELEASE-NAME-datashield-secrets

# Retrieve generated passwords
kubectl get secret RELEASE-NAME-datashield-secrets -o jsonpath='{.data.opal-administrator-password}' | base64 --decode

# Port forward to access services
kubectl port-forward service/RELEASE-NAME-datashield-opal 8080:8080
kubectl port-forward service/RELEASE-NAME-datashield-rock 8085:8085

# Test connectivity
kubectl run test-pod --rm -i --tty --image=busybox -- /bin/sh
```

### Testing the Deployment

The chart includes a test framework to validate the deployment:

```bash
# Run Helm tests
helm test RELEASE-NAME

# Check test results
kubectl get pods -l app.kubernetes.io/instance=RELEASE-NAME
```

## Contributing

Contributions are welcome! Please read the contributing guidelines and submit pull requests to the repository.

## License

This chart is licensed under the same license as the DataShield project.
