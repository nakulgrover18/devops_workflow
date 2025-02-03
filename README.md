
# **CI/CD with AWS: Deploying a Static Website Using Multiple Services**  

## **Overview**  
This project demonstrates **CI/CD automation on AWS** using **Terraform, GitHub, AWS CodePipeline, and CodeBuild**. It highlights how **multiple AWS services** can be used for the **same functionality**, giving flexibility in cloud architecture choices.  

## **Key Concepts**  
- **Compute Options:** Deploy a static website using **EC2 with Apache** OR **S3 static website hosting**  
- **Load Balancing Options:** Use an **Application Load Balancer (ALB)** OR **CloudFront** for distribution  
- **Storage Options:** Store website files in **EC2 instance storage** OR **S3 bucket**  

---

## **Project Structure**  
```
📂 cicd
│── 📂 modules
│   ├── 📂 ec2              # EC2 instances with Apache & user data
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── 📂 s3               # S3 static website hosting
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── 📂 alb              # Load balancer configuration
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── 📂 iam              # IAM roles & policies
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── 📂 sg               # Security group configuration
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│── main.tf                 # Calls all modules
│── variables.tf            # Variables for Terraform
│── outputs.tf              # Outputs after deployment
│── terraform.tfvars        # Variable values
│── 📂 static-site          # Static website code
│   ├── index.html
│   ├── style.css
│   ├── script.js
│── buildspec.yml           # CodeBuild configuration file

📂 backend_setup           # Folder for backend setup (S3 & DynamoDB)
│── main.tf                # Terraform code for S3 and DynamoDB

📂 pipeline_setup          # Folder for Pipeline setup (CodePipeline & CodeBuild)
│── main.tf                # Terraform code for CodePipeline & CodeBuild
```

---

## **How It Works**  
1. **Code Push to GitHub** → Triggers AWS **CodePipeline**  
2. **AWS CodeBuild** → Runs Terraform code from the `cicd` folder  
3. **Terraform Modules Provision:**  
   - **Compute:** EC2 instance with Apache **OR** S3 for static hosting  
   - **Load Balancing:** ALB **OR** CloudFront for content delivery  
   - **Storage:** EC2 instance storage **OR** S3  
4. **Static Website Deployment:**  
   - Apache on EC2 **OR** S3 bucket serving the website  

---

## **Why Use Terraform Modules?**  
- **Reusability:** Define infrastructure components once, reuse them across environments  
- **Flexibility:** Easily switch between services (EC2 ↔ S3, ALB ↔ CloudFront)  
- **Scalability:** Modular approach makes it easy to extend  

---

## **Step-by-Step Setup & Deployment**  

### **Step 1: Install Terraform**  
1. Download and install Terraform from the [official website](https://www.terraform.io/downloads.html).  
2. Verify the installation:  
   ```sh
   terraform --version
   ```

---

### **Step 2: Create an IAM User in AWS**  
1. Go to the **AWS Management Console** → **IAM** → **Users** → **Create User**.  
2. Add the following permissions:  
   - **AmazonS3FullAccess**  
   - **AmazonDynamoDBFullAccess**  
   - **AmazonEC2FullAccess**  
   - **AWSCodePipelineFullAccess**  
   - **AWSCodeBuildAdmin**  
   - **AmazonVPCFullAccess**  
3. Create an **Access Key** and **Secret Key** for the IAM user.  

---

### **Step 3: Configure AWS CLI**  
1. Install the AWS CLI if not already installed:  
   ```sh
   sudo apt install awscli  # For Linux
   brew install awscli      # For macOS
   ```
2. Configure the AWS CLI with the IAM user credentials:  
   ```sh
   aws configure
   ```
   - Enter the **Access Key**, **Secret Key**, **Region** (e.g., `us-east-1`), and default output format (e.g., `json`).  

---

### **Step 4: Clone the Repository**  
1. Clone the repository to your local machine:  
   ```sh
   git clone https://github.com/nakulgrover18/devops_workflow.git
   cd your-repo-name
   ```

---

### **Step 5: Set Up Terraform Backend**  
1. Navigate to the `backend_setup` folder:  
   ```sh
   cd backend_setup
   ```

2. Initialize Terraform:  
   ```sh
   terraform init
   ```

3. Plan and apply the backend setup:  
   ```sh
   terraform plan
   terraform apply -auto-approve
   ```

4. Note the outputs:  
   - **S3 Bucket Name**: Used for storing the Terraform state file.  
   - **DynamoDB Table Name**: Used for state locking.  

5. Update the `backend.tf` file in the `cicd` folder with the S3 bucket and DynamoDB table details:  
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "your-terraform-state-bucket"  
       key            = "path/to/terraform.tfstate"  
       region         = "us-east-1"                 
       encrypt        = true
       dynamodb_table = "your-terraform-lock-table" 
     }
   }
   ```

---

### **Step 6: Set Up CI/CD Pipeline**  
1. Navigate to the `pipeline_setup` folder:  
   ```sh
   cd ../pipeline_setup
   ```

2. Initialize Terraform:  
   ```sh
   terraform init
   ```

3. Plan and apply the pipeline setup:  
   ```sh
   terraform plan
   terraform apply -auto-approve
   ```

4. **Authorize GitHub Connection**:  
   - Go to the AWS Management Console → CodePipeline → Connections.  
   - Find the GitHub connection and authorize it.  

---

### **Step 7: Push the Code to GitHub**  
1. Create a new repository on GitHub.  
2. Add the remote origin to your local repository:  
   ```sh
   git remote add origin https://github.com/your-github-username/your-repo-name.git
   ```
3. Push the code to GitHub:  
   ```sh
   git add .
   git commit -m "Initial commit"
   git push -u origin main
   ```

4. The pipeline will automatically trigger and deploy the infrastructure.  

---

### **Step 8: Verify Deployment**  
- **EC2 Website:** Check the Load Balancer DNS.  
- **S3 Website:** Enable static website hosting and access the S3 endpoint.  

---

## **Cleanup**  
To delete all resources:  
1. Destroy the main infrastructure:  
   ```sh
   cd cicd
   terraform destroy -auto-approve
   ```

2. Destroy the CI/CD pipeline:  
   ```sh
   cd ../pipeline_setup
   terraform destroy -auto-approve
   ```

3. Destroy the backend setup:  
   ```sh
   cd ../backend_setup
   terraform destroy -auto-approve
   ```

---

## **Conclusion**  
This project demonstrates how **multiple AWS services can be used for the same purpose** using **Terraform modules**, giving DevOps engineers **flexibility, scalability, and automation** in cloud deployments.  

