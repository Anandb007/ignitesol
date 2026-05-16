<h1>IgniteSol AWS EKS CI/CD Deployment Project</h1>

<div class="section">
    <h2>Overview</h2>
    <p>This project demonstrates a complete end-to-end <strong>DevOps CI/CD pipeline</strong> for deploying a containerized web application on an <strong>AWS EKS Kubernetes Cluster</strong> using modern cloud-native tools and best practices.</p>
    <p>The pipeline covers:</p>
    <ul>
        <li><strong>Source control:</strong> GitHub</li>
        <li><strong>CI/CD automation:</strong> GitHub Actions</li>
        <li><strong>Containerization:</strong> Docker</li>
        <li><strong>Image registry:</strong> Amazon ECR</li>
        <li><strong>Kubernetes orchestration:</strong> Amazon EKS</li>
        <li><strong>Deployment automation:</strong> Helm</li>
        <li><strong>Load balancing:</strong> AWS ALB Ingress</li>
        <li><strong>Autoscaling:</strong> Horizontal Pod Autoscaler (HPA)</li>
    </ul>
</div>

<hr>

<div class="section">
    <h2>Objective</h2>
    <ul>
        <li>Automated build and deployment</li>
        <li>Secure AWS authentication <strong>without access keys</strong></li>
        <li>Scalable application deployment</li>
        <li>High availability (<strong>minimum 8 replicas always running</strong>)</li>
        <li>Auto-scaling based on CPU and memory usage</li>
        <li>External access via <strong>AWS Load Balancer</strong></li>
    </ul>
</div>

<hr>

<div class="section">
    <h2>Application Details</h2>
    <p>A simple <strong>Python Flask-based HTTP application</strong> is deployed.</p>
    
    Features:
        Runs on port <code>8080
        Returns JSON response
  "message": "IgniteSol Sample Application Running",
  "status": "success",
  "hostname": ""
}</code></pre>
</div>

<hr>

<div class="section">
    <h2>Architecture Overview</h2>
    <pre><code>
GitHub Repository
      ↓
GitHub Actions (CI/CD Pipeline)
      ↓
OIDC Authentication (IAM Role - No Access Keys)
      ↓
Amazon ECR (Docker Image Registry)
      ↓
Amazon EKS Cluster (Kubernetes)
      ↓
Helm Deployment
      ↓
AWS ALB Ingress Controller
      ↓
External User Access (HTTP Load Balancer)
    </code></pre>
</div>

<hr>

<div class="section">
    <h2>AWS Services Used</h2>
    <ul>
        <li>Amazon EKS (Kubernetes Cluster)</li>
        <li>Amazon ECR (Container Registry)</li>
        <li>AWS IAM Roles (OIDC Authentication)</li>
        <li>AWS ALB Ingress Controller</li>
        <li>AWS VPC Networking</li>
    </ul>
</div>

<div class="section">
    <h2>Kubernetes Resources Deployed</h2>
    <ul>
        <li>Deployment (8 replicas minimum)</li>
        <li>Service (ClusterIP)</li>
        <li>Ingress (AWS ALB)</li>
        <li>Horizontal Pod Autoscaler (HPA)</li>
        <li>Pod Disruption Budget (PDB)</li>
        <li>Priority Class</li>
        <li>Metrics Server (for HPA monitoring)</li>
    </ul>
</div>

<hr>

<div class="section">
    <h2>CI/CD Pipeline Flow</h2>
    <ul>
        <li>Checkout source code</li>
        <li>Authenticate to AWS using OIDC (no secrets used)</li>
        <li>Build Docker image</li>
        <li>Tag image using Git commit SHA (immutable versioning)</li>
        <li>Push image to Amazon ECR</li>
        <li>Configure kubeconfig for EKS</li>
        <li>Deploy application using Helm</li>
    </ul>
</div>

<hr>

<div class="section">
    <h2>Security Implementation</h2>
    <ul>
        <li>❌ No AWS Access Key / Secret Key used</li>
        <li>✅ Uses GitHub OIDC Federation</li>
        <li>✅ IAM Role: <code>ignitesol_Ci-CD_part</code></li>
        <li>✅ Least privilege access model</li>
        <li>✅ Secure EKS authentication via role assumption</li>
    </ul>
</div>

<hr>

<div class="section">
    <h2>Docker Implementation</h2>
    <ul>
        <li>Multi-stage Docker build used for optimization</li>
        <li>Base image: <code>python:3.11-slim</code></li>
        <li>Application server: gunicorn</li>
        <li>Exposed port: 8080</li>
    </ul>
</div>

<hr>

<div class="section">
    <h2>Deployment Strategy</h2>
    <ul>
        <li>Helm-based deployment</li>
        <li>Rolling updates enabled</li>
        <li>Zero downtime deployment strategy</li>
        <li>Immutable Docker image tags (Git SHA based)</li>
    </ul>
</div>

</body>
</html>



<div class="section">
    <h2>Terraform Infrastructure Overview</h2>
    <p>This project uses <strong>Terraform</strong> to provision and manage the cloud infrastructure for the IgniteSol AWS EKS CI/CD deployment. The setup is modular, reusable, and environment-specific, enabling consistent infrastructure across multiple stages such as development, staging, and production.</p>

<p>The Terraform project is organized into <strong>environments</strong> and <strong>modules</strong>:</p>

<pre><code>
Ignitesol/terraform
├── environments
│   └── dev
│       ├── backend.tf           # Configures Terraform backend storage
│       ├── main.tf              # Main environment-specific resources
│       ├── outputs.tf           # Defines outputs for this environment
│       ├── provider.tf          # Specifies provider configurations (AWS)
│       ├── terraform.tfvars     # Environment-specific variable values
│       └── variables.tf         # Variable definitions
└── modules
    ├── ecr
    │   ├── main.tf              # Creates Amazon ECR repositories
    │   ├── outputs.tf           # ECR outputs
    │   └── variables.tf         # Module input variables
    ├── eks
    │   ├── main.tf              # Creates Amazon EKS cluster
    │   ├── outputs.tf           # EKS outputs
    │   └── variables.tf         # Module input variables
    ├── iam
    │   ├── main.tf              # IAM roles, policies, and OIDC integration
    │   ├── outputs.tf           # IAM outputs
    │   └── variables.tf         # Module input variables
    └── vpc
        ├── main.tf              # VPC, subnets, routing, and networking resources
        ├── outputs.tf           # Networking outputs
        └── variables.tf         # Module input variables
</code></pre>

<p>This structure allows for:</p>
<ul>
    <li>Clear separation of environment-specific and reusable module configurations</li>
    <li>Easy scaling of resources and environments</li>
    <li>Version-controlled, reproducible infrastructure deployments</li>
    <li>Secure and automated provisioning of AWS resources</li>
</ul>
</div>



<div class="section">
    <h2>GitHub Actions CI/CD Workflow</h2>
    <p>The following <strong>GitHub Actions workflow</strong> automates the deployment of the containerized application to the <strong>AWS EKS cluster</strong> whenever changes are pushed to the <code>master</code> branch. It ensures seamless CI/CD by building, tagging, and pushing Docker images to Amazon ECR, followed by deploying the application using Helm.</p>

<p><strong>Workflow highlights:</strong></p>
<ul>
    <li>Triggers on pushes to the <code>master</code> branch</li>
    <li>Uses OIDC-based IAM role authentication (no access keys required)</li>
    <li>Builds and tags Docker images with Git SHA and run number for immutable versioning</li>
    <li>Pushes images to Amazon ECR</li>
    <li>Updates kubeconfig and deploys the application via Helm</li>
</ul>

<h3>Workflow YAML (<code>.github/workflows/deploy.yml</code>)</h3>
<pre><code>name: Deploy to EKS

on:
  push:
    branches:
      - master

permissions:
  id-token: write
  contents: read

env:
  AWS_REGION: us-east-1
  ECR_REPOSITORY: sample-test
  EKS_CLUSTER_NAME: ignitesol-dev-eks
  AWS_ACCOUNT_ID: 163649805097
  #IMAGE_TAG: ${{ github.sha }}
  IMAGE_TAG: ${{ github.sha }}-${{ github.run_number }}
jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:

    - name: Checkout Code
      uses: actions/checkout@v4

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        role-to-assume: arn:aws:iam::163649805097:role/ignitesol_Ci-CD_part
        aws-region: us-east-1

    - name: Login to Amazon ECR
      uses: aws-actions/amazon-ecr-login@v2

    - name: Build Docker Image
      run: |
        docker build -t $ECR_REPOSITORY:$IMAGE_TAG ./app

    - name: Tag Docker Image
      run: |
        docker tag $ECR_REPOSITORY:$IMAGE_TAG \
        $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:$IMAGE_TAG

    - name: Push Docker Image
      run: |
        docker push \
        $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:$IMAGE_TAG

    - name: Update kubeconfig
      run: |
        aws eks update-kubeconfig \
        --region $AWS_REGION \
        --name $EKS_CLUSTER_NAME

    - name: Deploy Application using Helm
      run: |
        helm upgrade --install sample-test ./helm/sample-test \
        --set image.repository=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY \
        --set image.tag=$IMAGE_TAG
</code></pre>

<p>This workflow ensures that the latest application changes are automatically built, securely pushed to the container registry, and deployed to the Kubernetes cluster without manual intervention, following best DevOps practices.</p>
</div>




<div class="section">
    <h2>Full Deployment Logs</h2>
    <p>The following are detailed logs from a successful GitHub Actions deployment of the application to AWS EKS.Build stage logs are omitted due to their large size</p>
    <pre><code>
deploy
succeeded 2 hours ago in 27s
Search logs
2s
1s
0s
Run aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::****:role/ignitesol_Ci-CD_part
    aws-region: us-east-1
    audience: sts.amazonaws.com
    output-env-credentials: true
  env:
    AWS_REGION: us-east-1
    ECR_REPOSITORY: sample-test
    EKS_CLUSTER_NAME: ignitesol-dev-eks
    AWS_ACCOUNT_ID: ****
    IMAGE_TAG: a79163d4bdf42bfe78e79441d1686f63e465c7ee-3
Assuming role with OIDC
Authenticated as assumedRoleId AROASMGSJ3MUWF7YYUIDN:GitHubActions
1s
Run aws-actions/amazon-ecr-login@v2
  with:
    mask-password: true
    registry-type: private
    skip-logout: false
  env:
    AWS_REGION: us-east-1
    ECR_REPOSITORY: sample-test
    EKS_CLUSTER_NAME: ignitesol-dev-eks
    AWS_ACCOUNT_ID: ****
    IMAGE_TAG: a79163d4bdf42bfe78e79441d1686f63e465c7ee-3
    AWS_DEFAULT_REGION: us-east-1
    AWS_ACCESS_KEY_ID: ***
    AWS_SECRET_ACCESS_KEY: ***
    AWS_SESSION_TOKEN: ***
Using environment variable credentials.
Logging into registry ****.dkr.ecr.us-east-1.amazonaws.com
8s
0s
Run docker tag $ECR_REPOSITORY:$IMAGE_TAG \
  docker tag $ECR_REPOSITORY:$IMAGE_TAG \
  ****.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:$IMAGE_TAG
  shell: /usr/bin/bash -e {0}
  env:
    AWS_REGION: us-east-1
    ECR_REPOSITORY: sample-test
    EKS_CLUSTER_NAME: ignitesol-dev-eks
    AWS_ACCOUNT_ID: ****
    IMAGE_TAG: a79163d4bdf42bfe78e79441d1686f63e465c7ee-3
    AWS_DEFAULT_REGION: us-east-1
    AWS_ACCESS_KEY_ID: ***
    AWS_SECRET_ACCESS_KEY: ***
    AWS_SESSION_TOKEN: ***
3s
Run docker push \
The push refers to repository [****.dkr.ecr.us-east-1.amazonaws.com/sample-test]
122f241b77c6: Preparing
4a969e0c8c8c: Preparing
59ab7feebd3b: Preparing
94e760ec3074: Preparing
799edc77eb3d: Preparing
2e53cb234c59: Preparing
79dd1f4c855c: Preparing
2e53cb234c59: Waiting
79dd1f4c855c: Waiting
94e760ec3074: Layer already exists
799edc77eb3d: Layer already exists
2e53cb234c59: Layer already exists
79dd1f4c855c: Layer already exists
122f241b77c6: Pushed
59ab7feebd3b: Pushed
4a969e0c8c8c: Pushed
a79163d4bdf42bfe78e79441d1686f63e465c7ee-3: digest: sha256:0213c9677d6c9713bfcb78c17fcefe067c68813a2f72349110a7c68ff1e48ad5 size: 1783
3s
Run aws eks update-kubeconfig \
  aws eks update-kubeconfig \
  --region $AWS_REGION \
  --name $EKS_CLUSTER_NAME
  shell: /usr/bin/bash -e {0}
  env:
    AWS_REGION: us-east-1
    ECR_REPOSITORY: sample-test
    EKS_CLUSTER_NAME: ignitesol-dev-eks
    AWS_ACCOUNT_ID: ****
    IMAGE_TAG: a79163d4bdf42bfe78e79441d1686f63e465c7ee-3
    AWS_DEFAULT_REGION: us-east-1
    AWS_ACCESS_KEY_ID: ***
    AWS_SECRET_ACCESS_KEY: ***
    AWS_SESSION_TOKEN: ***
Added new context arn:aws:eks:us-east-1:****:cluster/ignitesol-dev-eks to /home/runner/.kube/config
7s
Run helm upgrade --install sample-test ./helm/sample-test \
  helm upgrade --install sample-test ./helm/sample-test \
  --set image.repository=****.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY \
  --set image.tag=$IMAGE_TAG
  shell: /usr/bin/bash -e {0}
  env:
    AWS_REGION: us-east-1
    ECR_REPOSITORY: sample-test
    EKS_CLUSTER_NAME: ignitesol-dev-eks
    AWS_ACCOUNT_ID: ****
    IMAGE_TAG: a79163d4bdf42bfe78e79441d1686f63e465c7ee-3
    AWS_DEFAULT_REGION: us-east-1
    AWS_ACCESS_KEY_ID: ***
    AWS_SECRET_ACCESS_KEY: ***
    AWS_SESSION_TOKEN: ***
Release "sample-test" has been upgraded. Happy Helming!
NAME: sample-test
LAST DEPLOYED: Sat May 16 06:12:01 2026
NAMESPACE: default
STATUS: deployed
REVISION: 2
TEST SUITE: None
    </code></pre>
</div>


## Dockerfile

The application uses a **multi-stage Docker build** to optimize image size and performance.

```dockerfile
# Stage 1: Build stage
FROM python:3.11-slim AS builder

WORKDIR /app

# Copy dependencies file
COPY requirements.txt .

# Install Python dependencies locally
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Final image
FROM python:3.11-slim

WORKDIR /app

# Copy installed dependencies from builder
COPY --from=builder /root/.local /root/.local

# Copy application code
COPY app.py .

# Update PATH to include local binaries
ENV PATH=/root/.local/bin:$PATH

# Expose application port
EXPOSE 8080

# Run the application using Gunicorn
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8080", "app:app"]
