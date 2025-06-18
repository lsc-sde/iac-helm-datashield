# DataShield Helm Chart

A comprehensive Helm chart for deploying DataShield, a platform for privacy-preserving federated data analysis.

## Overview

DataShield is a suite of software packages that enable privacy-preserving federated data analysis. This Helm chart deploys the core components of the DataShield infrastructure including:

- **Opal**: Data repository and analysis server
- **Rock**: R server for DataShield analysis
- **Agate**: Optional authentication and authorization server
- **Mica**: Optional metadata catalog and data discovery portal

**Database Requirements**: This chart expects external databases to be deployed separately using well-maintained Helm charts (e.g., Bitnami). The chart provides configuration options to connect Opal to your existing MongoDB, MySQL, MariaDB, and PostgreSQL instances.

## Security

⚠️ **Important Security Update**: This chart now implements secure secret management. Plaintext passwords are no longer supported in `values.yaml`. See [SECURITY.md](SECURITY.md) for detailed information about:

- Automatic random secret generation
- Using external Kubernetes secrets
- Migration from previous versions
- Best practices for secret management

## Prerequisites

- Kubernetes 1.19+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

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
| `opal.config.administratorPassword` | Opal administrator password | `password` |
| `opal.config.existingSecret` | Use existing secret for Opal config | `""` |
| `opal.config.csrfAllowed` | CSRF allowed hosts | `datashield.local` |
| `opal.demo.enabled` | Enable demo data loading | `true` |
| `opal.demo.userName` | Demo user name | `dsuser` |

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
| `rock.config.administratorName` | Rock administrator name | `admin` |
| `rock.config.administratorPassword` | Rock administrator password | `secure-admin-password` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `true` |
| `ingress.className` | Ingress class name | `nginx` |
| `ingress.annotations` | Ingress annotations | See values.yaml |
| `ingress.hosts` | Ingress hosts configuration | See values.yaml |
| `ingress.tls` | Ingress TLS configuration | See values.yaml |

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

#### Production Installation with All Components

```yaml
# production-values.yaml
# External database configuration
externalDatabases:
  mongodb:
    host: "prod-mongodb.example.com"
    port: 27017
    user: "datashield"
    password: "production-password"
  mysql:
    host: "prod-mysql.example.com"
    port: 3306
    database: "datashield"
    user: "datashield"
    password: "production-password"

# Increase resource limits
opal:
  resources:
    limits:
      cpu: 4000m
      memory: 8Gi
    requests:
      cpu: 2000m
      memory: 4Gi

rock:
  resources:
    limits:
      cpu: 4000m
      memory: 8Gi
    requests:
      cpu: 2000m
      memory: 4Gi

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

# Use custom storage class
global:
  storageClass: fast-ssd

# Increase persistent volume sizes
opal:
  persistence:
    size: 100Gi
```

```bash
helm install datashield ./datashield -f production-values.yaml
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
   - Password: The value set in `opal.config.administratorPassword`

## Persistence

The chart mounts persistent volumes for:

- Opal data at `/srv`

**Note**: Database persistence is handled by your external database deployments (MongoDB, MySQL, etc.) deployed separately.

## Security Considerations

- **Change default passwords**: Always change default passwords in production
- **Use secrets**: Consider using Kubernetes secrets or external secret management
- **Enable authentication**: Configure proper authentication for database components
- **Network policies**: Implement network policies to restrict access
- **TLS**: Enable TLS for external communications

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

# Check logs
kubectl logs deployment/RELEASE-NAME-datashield-opal

# Describe pod for events
kubectl describe pod POD-NAME

# Check persistent volume claims
kubectl get pvc

# Port forward to access services
kubectl port-forward service/RELEASE-NAME-datashield-opal 8080:8080
```

## Contributing

Contributions are welcome! Please read the contributing guidelines and submit pull requests to the repository.

## License

This chart is licensed under the same license as the DataShield project.
