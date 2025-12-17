# Gopal Cloud Project: Full Stack Microservices on Azure

This project deploys a complete 3-Tier Microservices architecture on Azure using Terraform and Kubernetes. It provisions an AKS cluster, an API Management gateway, and a managed PostgreSQL database, then deploys a custom React Frontend and Node.js Backend.

## Architecture

The infrastructure follows a modern cloud-native design where the frontend and backend run as containerized microservices in Kubernetes, connected to a managed database.

![Architecture Diagram](./images/image.png)

## Components

* **Frontend (UI):** React.js application running on AKS (User Interface).
* **Backend (API):** Node.js Express API running on AKS (Business Logic).
* **Database:** Azure Database for PostgreSQL (Flexible Server).
* **Orchestration:** Azure Kubernetes Service (AKS).
* **Gateway:** Azure API Management (APIM) for potential routing and security.

## Prerequisites

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Terraform](https://www.terraform.io/downloads.html)
* [Docker Desktop](https://www.docker.com/products/docker-desktop)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Deployment Instructions

### Phase 1: Infrastructure (Terraform)
Provision the hardware (Cluster, Database, Networking).

1.  **Clone the repository:**
    ```bash
    git clone <your-repo-url>
    cd gopal-terraform-demo/terraform
    ```

2.  **Login to Azure:**
    ```bash
    az login
    ```

3.  **Deploy Resources:**
    ```bash
    terraform init
    terraform apply -auto-approve
    ```
    *Note: This creates the "dev" environment in West US 2.*

### Phase 2: Software Build (Docker)
Package the application code into containers.

1.  **Build & Push API:**
    ```bash
    cd ../zzz/api
    docker build -t <your-docker-hub-user>/my-api:v1 .
    docker push <your-docker-hub-user>/my-api:v1
    ```

2.  **Build & Push UI:**
    ```bash
    cd ../zzz/ui
    docker build -t <your-docker-hub-user>/my-ui:v1 .
    docker push <your-docker-hub-user>/my-ui:v1
    ```

### Phase 3: Deployment (Kubernetes)
Launch the containers into the AKS cluster.

1.  **Connect to Cluster:**
    ```bash
    az aks get-credentials --resource-group GopalCloud-dev-resources --name GopalCloud-dev-aks
    ```

2.  **Deploy Services:**
    ```bash
    cd ..
    kubectl apply -f k8s/deployment.yaml    # Deploys API
    kubectl apply -f k8s/ui-deployment.yaml # Deploys UI
    ```

## Verification & Testing

Get the public IP addresses for your services:

```bash
kubectl get services
```
* **Test Frontend:** Copy the `EXTERNAL-IP` of `ui-service` and paste it into your browser.
    * *Success:* You see the "Gopal's Cloud Project" React Dashboard.
* **Test Backend:** Copy the `EXTERNAL-IP` of `api-service` and append `/db-test`.
    * *Success:* Returns JSON `{ "message": "Database Connected!", "time": "..." }`.

## Project Structure 

* `terraform/`: Infrastructure as Code (AKS, PGSQL, APIM).
* `zzz/ui/`: React Source Code.
* `zzz/api/`: Node.js Source Code.
* `k8s/`: Kubernetes Manifests (Deployments & Services).

## Cleanup

To destroy all resources and stop billing:

```bash
cd terraform
terraform destroy -auto-approve 