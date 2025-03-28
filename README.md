# Symfony Application Deployment Guide

## Environment Configuration

### Local Environment
- Update the `.env` file in the `my-symfony-app` directory for local environment variables.

### Kubernetes Environment
- Modify the `values.yaml` file in the Helm chart to configure environment-specific values.

## Local Setup

To run the application locally, use Docker Compose:

```bash
docker compose up --build
```

This will build and start the containers for Symfony, Nginx, and PostgreSQL.

## Kubernetes Setup. Building the Symfony Docker Image

To build the Docker image for Symfony, run the following command:

```bash
docker build -t symfony-app .
```

## Push image to any artifact registry

```bash
docker push ... symfony-app
```

## Artifact registry
Use your correct artifact registry in the `values.yaml` file. It is assumed that you will configure access to your artifact registry yourself.

## Deploying with Helm
- Ensure you have Helm installed.
- Kubernetes cluster is up and running.

1. Navigate to the Helm chart directory:
   ```bash
   cd helm-chart
   ```

2. Deploy the chart:
   ```bash
   helm install my-symfony .
   ```

3. Verify the deployment:
   ```bash
   kubectl get all
   ```

## Accessing the Application
### Locally
- The application will be accessible at `http://localhost:8080`.

### Kubernetes
1. Ingress:
- By default, ingress is disabled. You need to configure it based on your cluster. If you configure the ingress yourself and enable it through the `values.yaml` file
- Access the application at `http://my-sym-app.com` (or the host specified in `values.yaml`).

2. Port forward
- The easiest way to test the application is through port forwarding.
- kubectl port-forward pod/nginx-5554df8ddb-49mpp 8081:80 -n symfony
- replace pod/nginx-5554df8ddb-49mpp to proper pod name

## Troubleshooting

- Check container logs:
  ```bash
  docker logs <container_name>
  ```
  or
  ```bash
  kubectl logs <pod_name>
  ```

- Verify service and ingress configurations:
  ```bash
  kubectl describe service <service_name>
  kubectl describe ingress <ingress_name>
  ```