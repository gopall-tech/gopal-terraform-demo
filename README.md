# Gopal Terraform Microservices Infrastructure

This project deploys a complete Microservices architecture on Azure using Terraform. It provisions an AKS cluster with multiple backends, an API Management gateway for routing, and a PostgreSQL database for persistence.

## Architecture

The infrastructure follows a split-service architecture where traffic is routed via an API Gateway to specific microservices running in Kubernetes.

![Architecture Diagram](./images/image.png)

## Components

* **Azure Kubernetes Service (AKS):** Hosts the application workloads.
    * **Backend A:** Nginx service (Simulating User Service).
    * **Backend B:** Apache service (Simulating Order Service).
* **Azure API Management (APIM):** Acts as the API Gateway.
    * Routes `/a` traffic to Backend A.
    * Routes `/b` traffic to Backend B.
* **Azure Database for PostgreSQL:** Managed persistence layer (deployed in East US 2).
* **Networking:** Public Load Balancers expose the pods to the APIM gateway.

## Prerequisites

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Terraform](https://www.terraform.io/downloads.html)
* [Git](https://git-scm.com/)

## Deployment Instructions

1.  **Clone the repository:**
    ```bash
    git clone <your-repo-url>
    cd gopal-terraform-demo
    ```

2.  **Login to Azure:**
    ```bash
    az login
    ```

3.  **Initialize Terraform:**
    ```bash
    terraform init
    ```

4.  **Deploy Infrastructure:**
    ```bash
    terraform apply -auto-approve
    ```
    *Note: API Management creation may take 45-60 minutes.*

5.  **Get Load Balancer IPs (Mid-Deployment Step):**
    If deploying for the first time, you may need to update the `apim.tf` file with the external IPs of the services:
    ```bash
    kubectl get svc
    ```
    Update the `service_url` in `apim.tf` with the resulting IPs.

## Verification & Testing

Once deployment is complete, Terraform will output the `apim_gateway_url`. You can test the routing logic via a web browser:

* **Service A:** `https://<your-apim-url>/a` -> Returns Nginx Welcome Page.
* **Service B:** `https://<your-apim-url>/b` -> Returns Apache 'It works!' Page.

## Project Structure

* `main.tf`: Resource Group and AKS Cluster definition.
* `workloads.tf`: Kubernetes Deployments and Services (Backend A & B).
* `database.tf`: PostgreSQL Flexible Server configuration.
* `apim.tf`: API Management Gateway and routing rules.
* `variables.tf`: Project configuration (Prefix, Region).
* `outputs.tf`: Displays connection URLs and resource names.

## Cleanup

To destroy all resources and avoid costs:

```bash
terraform destroy -auto-approve
```