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
```


<div class="section">
    <h2>Helm Chart Structure</h2>
    <p>The application is deployed using a Helm chart located in <code>helm/sample-test</code>. This chart organizes Kubernetes resources in a modular and reusable way, enabling easy configuration, upgrades, and rollbacks.</p>

<p>The directory structure of the Helm chart is as follows:</p>

<pre><code>
helm/sample-test
├── Chart.yaml           
├── charts               
├── templates            
│   ├── _helpers.tpl     
│   ├── deployment.yaml  
│   ├── hpa.yaml         
│   ├── ingress.yaml     
│   ├── pdb.yaml         
│   ├── priorityclass.yaml 
│   └── service.yaml     
└── values.yaml          
</code></pre>

<p>This Helm chart structure allows for:</p>
<ul>
    <li>Separation of configuration values from templates</li>
    <li>Reusable templates across environments</li>
    <li>Easy integration with CI/CD pipelines (GitHub Actions)</li>
    <li>Support for advanced Kubernetes features such as HPA, PDB, and priority classes</li>
</ul>
</div>







<div>
  <h2>Kubernetes Cluster Information</h2>

  <pre>
kubectl cluster-info
Kubernetes control plane is running at https://0E7051FFB039A5277635629067CAB801.gr7.us-east-1.eks.amazonaws.com
CoreDNS is running at https://0E7051FFB039A5277635629067CAB801.gr7.us-east-1.eks.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

aws eks list-clusters --region us-east-1
{
    "clusters": [
        "ignitesol-dev-eks"
    ]
}

kubectl get node
NAME                          STATUS   ROLES    AGE     VERSION
ip-10-0-11-120.ec2.internal   Ready    <none>   6h44m   v1.34.7-eks-7fcd7ec
ip-10-0-12-234.ec2.internal   Ready    <none>   6h44m   v1.34.7-eks-7fcd7ec
  </pre>
</div>






<div>
  <h2> Deployment Evidence</h2>
  <table border="1" cellpadding="8" cellspacing="0">
    <thead>
      <tr>
        <th>Client Question</th>
        <th>Actual Output / Evidence</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>How many replicas are running?</td>
        <td>
<pre>
kubectl get deployment sample-test
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
sample-test   8/8     8            8           5h31m
</pre>
        </td>
      </tr>
      <tr>
        <td>Is autoscaling configured at 50% CPU and 60% memory?</td>
        <td>
<pre>
kubectl get hpa sample-test-hpa
NAME              REFERENCE                TARGETS                        MINPODS   MAXPODS   REPLICAS   AGE
sample-test-hpa   Deployment/sample-test   cpu: 1%/50%, memory: 43%/60%   8         12        8          5h31m
</pre>
        </td>
      </tr>
      <tr>
        <td>Is a custom Docker image used (sample-test:latest) hosted on ECR?</td>
        <td>
<pre>
kubectl get pods -l app=sample-test -o=jsonpath='{.items[*].spec.containers[*].image}'
sample-test:1023946f1a323addc734d8f5822ae51f16cd87aa-4
</pre>
        </td>
      </tr>
      <tr>
        <td>Is the app exposed on port 8080 via Load Balancer?</td>
        <td>
<pre>
kubectl get svc sample-test-service
NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
sample-test-service   ClusterIP   172.20.21.252  &lt;none&gt;    8080/TCP   5h32m
</pre>
        </td>
      </tr>
      <tr>
        <td>Are at least 5 replicas ensured during updates?</td>
        <td>
<pre>
kubectl get pdb sample-test-pdb
NAME              MIN AVAILABLE   MAX UNAVAILABLE   ALLOWED DISRUPTIONS   AGE
sample-test-pdb   5               N/A               3                     5h32m

kubectl describe pdb sample-test-pdb
Status:
    Allowed disruptions:  3
    Current:              8
    Desired:              5
    Total:                8
</pre>
        </td>
      </tr>
    </tbody>
  </table>

  <h3>Summary</h3>
  <ul>
    <li>High availability and scaling are ensured via Horizontal Pod Autoscaler (HPA) and Pod Disruption Budget (PDB).</li>
    <li>The deployment uses a custom Docker image from ECR and runs 8 replicas at all times.</li>
  </ul>

  <p><strong>Conclusion:</strong> Deployment is fully compliant with client specifications, scalable, and production-ready.</p>
</div>




<div>
  <h2>Metrics Overview</h2>
  
  <h3>Horizontal Pod Autoscaler (HPA)</h3>
  <p>The HPA ensures the <strong>sample-test</strong> deployment scales automatically based on CPU and memory utilization.</p>
  <pre>
kubectl get hpa sample-test-hpa
NAME              REFERENCE                TARGETS                        MINPODS   MAXPODS   REPLICAS   AGE
sample-test-hpa   Deployment/sample-test   cpu: 1%/50%, memory: 43%/60%   8         12        8          5h51m
  </pre>
  <p><em>Insight:</em> CPU usage is currently very low (1%), memory usage around 43%, well below autoscaling thresholds. This indicates the deployment has sufficient headroom for traffic spikes.</p>



  <h3>Pod Resource Usage</h3>
  <pre>
kubectl top pods
NAME                           CPU(cores)   MEMORY(bytes)
sample-test-5f46b6fd65-brk7s   1m           55Mi
sample-test-5f46b6fd65-cjpg2   1m           56Mi
sample-test-5f46b6fd65-fhgw5   1m           55Mi
sample-test-5f46b6fd65-gb9lq   1m           56Mi
sample-test-5f46b6fd65-l4nxw   1m           55Mi
sample-test-5f46b6fd65-mftcl   1m           56Mi
sample-test-5f46b6fd65-ns286   1m           55Mi
sample-test-5f46b6fd65-vf9wt   1m           55Mi
  </pre>
  <p><em>Insight:</em> All pods are running at minimal CPU usage (~1m) and stable memory (~55-56Mi). This confirms pods are healthy and the system is not under stress.</p>

  <h3>Ingress and External Access</h3>
  <pre>
kubectl get ingress
NAME                  CLASS   HOSTS   ADDRESS                                                                  PORTS   AGE
sample-test-ingress   alb     *       k8s-default-samplete-e1682dd1d0-1740006910.us-east-1.elb.amazonaws.com   80      5h50m

curl http://k8s-default-samplete-e1682dd1d0-1740006910.us-east-1.elb.amazonaws.com
{"hostname":"sample-test-5f46b6fd65-brk7s","message":"Ignitesol Sample Application Running","status":"success"}
  </pre>
  <p><em>Insight:</em> The application is accessible externally through the ALB, confirming successful routing and that the sample-test app is responding correctly.</p>

  <h3>Service Exposure</h3>
  <pre>
kubectl get svc
NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kubernetes            ClusterIP   172.20.0.1      &lt;none&gt;    443/TCP    6h30m
sample-test-service   ClusterIP   172.20.21.252   &lt;none&gt;    8080/TCP   5h51m
  </pre>
  <p><em>Insight:</em> The ClusterIP service exposes the application internally on port 8080. External traffic is managed by the ingress ALB.</p>

  <h3>Metrics Server Deployment</h3>
  <pre>
kubectl get deployment metrics-server -n kube-system
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
metrics-server   1/1     1            1           6h18m
  </pre>
  <p><em>Insight:</em> The metrics-server is healthy and available, enabling HPA to retrieve accurate CPU and memory metrics for autoscaling.</p>
</div>





<div>
  <h2>Horizontal Pod Autoscaler (HPA) Live Watch</h2>
  <p>The following is the live HPA watch output for the <strong>sample-test</strong> deployment. It shows how replicas scale dynamically based on CPU and memory usage.</p>

  <pre>
NAME              REFERENCE                TARGETS                        MINPODS   MAXPODS   REPLICAS   AGE
sample-test-hpa   Deployment/sample-test   cpu: 1%/50%, memory: 43%/60%   8         12        8          3h6m
sample-test-hpa   Deployment/sample-test   cpu: 6%/50%, memory: 43%/60%   8         12        8          3h7m
sample-test-hpa   Deployment/sample-test   cpu: 19%/50%, memory: 43%/60%  8         12        8          3h7m
sample-test-hpa   Deployment/sample-test   cpu: 16%/50%, memory: 43%/60%  8         12        8          3h7m
sample-test-hpa   Deployment/sample-test   cpu: 19%/50%, memory: 43%/60%  8         12        8          3h7m
sample-test-hpa   Deployment/sample-test   cpu: 19%/50%, memory: 43%/60%  8         12        8          3h8m
sample-test-hpa   Deployment/sample-test   cpu: 20%/50%, memory: 43%/60%  8         12        8          3h8m
sample-test-hpa   Deployment/sample-test   cpu: 20%/50%, memory: 43%/60%  8         12        8          3h8m
sample-test-hpa   Deployment/sample-test   cpu: 20%/50%, memory: 43%/60%  8         12        8          3h8m
sample-test-hpa   Deployment/sample-test   cpu: 19%/50%, memory: 43%/60%  8         12        8          3h9m
sample-test-hpa   Deployment/sample-test   cpu: 20%/50%, memory: 43%/60%  8         12        8          3h9m
sample-test-hpa   Deployment/sample-test   cpu: 10%/50%, memory: 43%/60%  8         12        8          3h9m
sample-test-hpa   Deployment/sample-test   cpu: 1%/50%, memory: 43%/60%   8         12        8          3h10m
sample-test-hpa   Deployment/sample-test   cpu: 62%/50%, memory: 43%/60%  8         12        8          3h10m
sample-test-hpa   Deployment/sample-test   cpu: 164%/50%, memory: 45%/60% 8         12        10         3h11m
sample-test-hpa   Deployment/sample-test   cpu: 42%/50%, memory: 45%/60%  8         12        12         3h11m
sample-test-hpa   Deployment/sample-test   cpu: 36%/50%, memory: 45%/60%  8         12        12         3h11m
sample-test-hpa   Deployment/sample-test   cpu: 119%/50%, memory: 45%/60% 8         12        12         3h12m
sample-test-hpa   Deployment/sample-test   cpu: 1%/50%, memory: 45%/60%   8         12        12         3h12m
sample-test-hpa   Deployment/sample-test   cpu: 1%/50%, memory: 45%/60%   8         12        12         3h13m
sample-test-hpa   Deployment/sample-test   cpu: 1%/50%, memory: 45%/60%   8         12        12         3h14m
  </pre>

  <p><strong>Explanation:</strong> The HPA dynamically adjusts the number of replicas based on CPU usage. For instance, when CPU spikes above 100%, replicas increased from 8 → 10 → 12. Memory usage remains stable at 43–45%, so scaling is primarily CPU-driven. This ensures the application stays responsive during varying traffic loads.</p>
</div>






<div>
  <h2>Note</h2>
  <p>⚠️ Due to billing concerns, the current infrastructure has been deleted. If needed again, it can be recreated, and I will provide the access links to the services once the cluster is up.</p>

  <pre>
# Note:
# - All EKS cluster resources have been removed.
# - If required, the infrastructure can be recreated quickly, and links to access the application and services will be shared.
  </pre>
</div>
