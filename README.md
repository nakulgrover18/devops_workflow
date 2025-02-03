# **CI/CD with AWS: Deploying a Static Website Using Multiple Services**  

## **Overview**  
This project demonstrates **CI/CD automation on AWS** using **Terraform, GitHub, AWS CodePipeline, and CodeBuild**. It highlights how **multiple AWS services** can be used for the **same functionality**, giving flexibility in cloud architecture choices.  

## **Key Concepts**  
- **Compute Options:** Deploy a static website using **EC2 with Apache** OR **S3 static website hosting**  
- **Load Balancing Options:** Use an **Application Load Balancer (ALB)** OR **CloudFront** for distribution  
- **Storage Options:** Store website files in **EC2 instance storage** OR **S3 bucket**  

## **Project Structure**  
```
📂 terraform_code
│── 📂 cicd                      # Contains Terraform configurations
│   ├── 📂 modules               # Terraform modules for reusable components
│   │   ├── ec2                  # EC2 instance with Apache
│   │   ├── s3                   # S3 bucket for static website
│   │   ├── alb                  # Load balancer configuration
│   │   ├── iam                  # IAM roles and policies
│   ├── main.tf                  # Main Terraform script (calls modules)
│   ├── variables.tf             # Terraform variables
│   ├── outputs.tf               # Terraform output values
│── buildspec.yml                # AWS CodeBuild build specification
│── README.md                    # Project documentation
```

## **How It Works**  
1. **Code Push to GitHub** → Triggers AWS **CodePipeline**  
2. **AWS CodeBuild** → Runs Terraform code from the `cicd` folder  
3. **Terraform Modules Provision:**  
   - **Compute:** EC2 instance with Apache **OR** S3 for static hosting  
   - **Load Balancing:** ALB **OR** CloudFront for content delivery  
   - **Storage:** EC2 instance storage **OR** S3  
4. **Static Website Deployment:**  
   - Apache on EC2 **OR** S3 bucket serving the website  

## **Why Use Terraform Modules?**  
- **Reusability:** Define infrastructure components once, reuse them across environments  
- **Flexibility:** Easily switch between services (EC2 ↔ S3, ALB ↔ CloudFront)  
- **Scalability:** Modular approach makes it easy to extend  

## **Setup & Deployment**  
### 1️⃣ Clone the repository  
```sh
git clone https://github.com/your-repo/terraform_code.git
cd terraform_code
```

### 2️⃣ Initialize Terraform  
```sh
cd cicd
terraform init
```

### 3️⃣ Plan & Apply Terraform  
```sh
terraform plan
terraform apply -auto-approve
```

### 4️⃣ Verify Deployment  
- **EC2 Website:** Check the Load Balancer DNS  
- **S3 Website:** Enable static website hosting  

### 5️⃣ Trigger CI/CD Pipeline  
Push a new commit to GitHub and check AWS CodePipeline execution.  

## **Cleanup**  
To delete all resources:  
```sh
terraform destroy -auto-approve
```

## **Conclusion**  
This project demonstrates how **multiple AWS services can be used for the same purpose** using **Terraform modules**, giving DevOps engineers **flexibility, scalability, and automation** in cloud deployments.  
