# DataShield Helm Chart

A comprehensive Helm chart for deploying DataShield, a platform for privacy-preserving federated data analysis.

## Overview

DataShield is a suite of software packages that enable privacy-preserving federated data analysis. This Helm chart deploys the core components of the DataShield infrastructure including:

- **Opal**: Data repository and analysis server
- **Rock**: R server for DataShield analysis
- **MongoDB**: Primary database for metadata and configurations
- **MySQL**: Optional relational database for data storage
- **Agate**: Optional authentication and authorization server
- **Mica**: Optional metadata catalog and data discovery portal

## Prerequisites

- Kubernetes 1.19+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `datashield`:

```bash
helm install datashield ./datashield
```

To install with custom values:

```bash
helm install datashield ./datashield -f my-values.yaml
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
| `podSecurityContext.fsGroup` | Pod security context fsGroup | `2000` |
| `securityContext.capabilities.drop` | Container security context capabilities to drop | `["ALL"]` |
| `securityContext.readOnlyRootFilesystem` | Container read-only root filesystem | `false` |
| `securityContext.runAsNonRoot` | Container runs as non-root | `true` |
| `securityContext.runAsUser` | Container user ID | `1000` |

### MongoDB Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mongodb.enabled` | Enable MongoDB deployment | `true` |
| `mongodb.replicaCount` | Number of MongoDB replicas | `1` |
| `mongodb.image.repository` | MongoDB image repository | `mongo` |
| `mongodb.image.tag` | MongoDB image tag | `6.0.13` |
| `mongodb.image.pullPolicy` | MongoDB image pull policy | `IfNotPresent` |
| `mongodb.service.type` | MongoDB service type | `ClusterIP` |
| `mongodb.service.port` | MongoDB service port | `27017` |
| `mongodb.persistence.enabled` | Enable MongoDB persistence | `true` |
| `mongodb.persistence.size` | MongoDB persistent volume size | `8Gi` |
| `mongodb.persistence.accessMode` | MongoDB persistent volume access mode | `ReadWriteOnce` |
| `mongodb.resources.limits.cpu` | MongoDB CPU limit | `1000m` |
| `mongodb.resources.limits.memory` | MongoDB memory limit | `1Gi` |
| `mongodb.resources.requests.cpu` | MongoDB CPU request | `500m` |
| `mongodb.resources.requests.memory` | MongoDB memory request | `512Mi` |

### MySQL Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mysql.enabled` | Enable MySQL deployment | `false` |
| `mysql.replicaCount` | Number of MySQL replicas | `1` |
| `mysql.image.repository` | MySQL image repository | `mysql` |
| `mysql.image.tag` | MySQL image tag | `8.0.35` |
| `mysql.image.pullPolicy` | MySQL image pull policy | `IfNotPresent` |
| `mysql.service.type` | MySQL service type | `ClusterIP` |
| `mysql.service.port` | MySQL service port | `3306` |
| `mysql.persistence.enabled` | Enable MySQL persistence | `true` |
| `mysql.persistence.size` | MySQL persistent volume size | `8Gi` |
| `mysql.auth.rootPassword` | MySQL root password | `secure-root-password` |
| `mysql.auth.database` | MySQL database name | `dsdb` |
| `mysql.auth.username` | MySQL username | `dsdb_user` |
| `mysql.auth.password` | MySQL user password | `secure-user-password` |

### Opal Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `opal.enabled` | Enable Opal deployment | `true` |
| `opal.replicaCount` | Number of Opal replicas | `1` |
| `opal.image.repository` | Opal image repository | `obiba/opal` |
| `opal.image.tag` | Opal image tag | `5.1.4` |
| `opal.image.pullPolicy` | Opal image pull policy | `IfNotPresent` |
| `opal.service.type` | Opal service type | `ClusterIP` |
| `opal.service.port` | Opal service port | `8080` |
| `opal.persistence.enabled` | Enable Opal persistence | `true` |
| `opal.persistence.size` | Opal persistent volume size | `2Gi` |
| `opal.config.administratorPassword` | Opal administrator password | `secure-admin-password` |
| `opal.config.csrfAllowed` | CSRF allowed hosts | `datashield.local` |
| `opal.demo.enabled` | Enable demo data loading | `true` |
| `opal.demo.userName` | Demo user name | `dsuser` |
| `opal.demo.userPassword` | Demo user password | `demo-password` |

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

### Installation with Custom Database Passwords

```yaml
# custom-values.yaml
mongodb:
  auth:
    enabled: true
    rootPassword: "my-secure-mongo-password"

opal:
  config:
    administratorPassword: "my-secure-opal-password"

rock:
  config:
    administratorPassword: "my-secure-rock-password"
```

```bash
helm install datashield ./datashield -f custom-values.yaml
```

### Installation with MySQL Enabled

```yaml
# mysql-values.yaml
mysql:
  enabled: true
  auth:
    rootPassword: "my-mysql-root-password"
    password: "my-mysql-user-password"

mongodb:
  enabled: true  # Keep MongoDB for metadata
```

```bash
helm install datashield ./datashield -f mysql-values.yaml
```

### Production Installation with All Components

```yaml
# production-values.yaml
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

mysql:
  enabled: true

# Configure ingress for your domain
ingress:
  hosts:
    - host: datashield.example.com
      paths:
        - path: /opal(/|$)(.*)
          pathType: ImplementationSpecific
          service:
            name: opal
            port: 8080
  tls:
    - secretName: datashield-tls
      hosts:
        - datashield.example.com

# Use custom storage class
global:
  storageClass: fast-ssd

# Increase persistent volume sizes
mongodb:
  persistence:
    size: 50Gi

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

- MongoDB data at `/data/db`
- Opal data at `/srv`
- MySQL data at `/var/lib/mysql` (if enabled)

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
