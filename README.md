# 🛤️ Jerney — Blog Platform (Enterprise DevSecOps Edition)

A Gen-Z vibe blog platform built with a robust 3-tier architecture, fully automated via GitOps and secured with a modern DevSecOps pipeline.

![Azure](https://img.shields.io/badge/Azure-AKS-0078D4?style=for-the-badge&logo=microsoft-azure)
![Terraform](https://img.shields.io/badge/Terraform-1.9+-623CE4?style=for-the-badge&logo=terraform)
![ArgoCD](https://img.shields.io/badge/ArgoCD-GitOps-EF7B4D?style=for-the-badge&logo=argo)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI/CD-2088FF?style=for-the-badge&logo=github-actions)

---

## 🏗️ Architecture & Workflow

This project demonstrates a complete **Infrastructure-as-Code (IaC)** and **GitOps** lifecycle. When a developer pushes code, the following automated workflow triggers:

### 🛡️ DevSecOps Lifecycle (The "Inner & Outer Loop")

```mermaid
graph TD
    subgraph "Developer Workspace"
    A[Code Change] -->|git push| B(GitHub Repo)
    end

    subgraph "CI Pipeline (GitHub Actions)"
    B --> C{Security Gates}
    C -->|ESLint| D[Code Linting]
    C -->|npm audit| E[SCA Scan]
    C -->|Hadolint| F[Docker Lint]
    D & E & F --> G[Docker Build]
    G --> H[Trivy Image Scan]
    H -->|Push| I[GHCR.io Registry]
    end

    subgraph "GitOps Loop (ArgoCD)"
    I --> J[Update values.yaml Tag]
    J -->|Detect Change| K[ArgoCD Controller]
    K -->|Sync State| L[AKS Cluster]
    end

    subgraph "Azure Cloud (AKS)"
    L --> M[Frontend React]
    L --> N[Backend Node.js]
    L --> O[PostgreSQL DB]
    end
```

---

## 🚀 Key Features

- **Infrastructure as Code**: Entire Azure environment (AKS, VNet, Log Analytics) managed via **Terraform**.
- **GitOps Management**: **ArgoCD** ensures the cluster state always matches the repository. No manual `kubectl apply` needed.
- **Automated Security**: 
    - **SCA**: Dependency auditing via `npm audit`.
    - **Image Scanning**: Critical/High vulnerability detection via **Trivy**.
    - **IaC Scanning**: Security best practices for Terraform/Helm via **Checkov**.
- **Cloud Native Storage**: Dynamic provisioning of Azure Managed Disks (CSI) for persistent PostgreSQL storage.

---

## 📁 Project Structure

```text
Jerney/
├── .github/workflows/   # DevSecOps CI/CD Pipeline
├── backend/             # Node.js Express API
├── frontend/            # React (Vite) frontend
├── k8s-chart/           # Helm Chart for the entire 3-tier app
├── terraform/           # Azure Infrastructure (AKS + ArgoCD)
└── jerney-argocd-app.yaml # ArgoCD Application Manifest
```

---

## 🛠️ Setup & Deployment

### Phase 1: Infrastructure
Provision the Azure environment and ArgoCD:
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

### Phase 2: GitOps Activation
Connect the GitHub repository to your cluster:
```bash
az aks get-credentials --resource-group jerney-aks-rg --name jerney-aks
kubectl apply -f jerney-argocd-app.yaml
```

---

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |
| GET | `/api/posts` | Get all posts |
| POST | `/api/posts` | Create a new post |

---

Built with 💜 and strictly enforced security gates. No cap, this infrastructure hits different. 🛤️
