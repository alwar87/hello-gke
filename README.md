# Hello World GKE Deployment

A complete DevOps solution that automatically builds, containers, and deploys a "Hello World" Node.js application to Google Kubernetes Engine (GKE) on every push to `main`.

![Architecture](https://i.imgur.com/placeholder-architecture.png) *Architecture diagram showing GitHub → GCR → GKE flow*

## ✨ Features

- **Infrastructure as Code**: Terraform provisions a secure, production-ready GKE cluster with auto-scaling
- **Secure CI/CD**: GitHub Actions with Workload Identity Federation (no service account keys stored in secrets)
- **Optimized Container**: Multi-stage Docker build (final image < 120MB)
- **Helm Packaging**: Templated Kubernetes manifests with proper health checks
- **Security Scanning**: Trivy vulnerability scanning blocks deployments with HIGH/CRITICAL CVEs
- **Public Access**: GKE Ingress Controller with global static IP for public access
- **Observability**: Built-in liveness/readiness probes and pod-level logging

## 🚀 Quick Start

### Prerequisites
- GCP project with billing enabled
- GitHub repository with admin access
- Terraform v1.5+ installed locally
- `gcloud` CLI authenticated with Owner/Editor permissions

### 1. Provision Infrastructure
```bash
cd terraform
terraform init
terraform apply -var="project_id=your-project-id" \
                -var="project_id_number=123456789012" \
                -var="github_repository=your-org/your-repo"
### **2. Configure GitHub Actions**
In GitHub repo Settings → Secrets and variables → Actions:
No secrets needed! Authentication uses Workload Identity Federation
Push code to main branch to trigger pipeline:
git checkout -b main
git add .
git commit -m "Initial deployment"
git push origin main

### **3. Access Your Application**

After deployment completes (~5 minutes):
  kubectl get ingress hello-world
# Output: ADDRESS          PORTS   AGE
#         34.120.XXX.XXX  80      2m


Visit http://<INGRESS-IP> in your browser!

🌐 Live Application
🔗 Public URL: http://34.120.XXX.XXX (replace with your actual IP after deployment)
🧹 Cleanup

To avoid ongoing charges:

# Destroy Kubernetes resources first
kubectl delete ingress,deployment,service -l app=hello-world

# Then destroy infrastructure
cd terraform
terraform destroy -var="project_id=your-project-id"
