resource "aws_instance" "web" {
  count                  = 3
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  user_data              = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd

              # Wait for metadata service to be available
              sleep 20

              # Retry fetching metadata
              RETRY_COUNT=5
              while [ $RETRY_COUNT -gt 0 ]; do
                INSTANCE_HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/hostname)
                if [ -n "$INSTANCE_HOSTNAME" ]; then
                  break
                fi
                echo "Waiting for metadata service..."
                sleep 5
                RETRY_COUNT=$((RETRY_COUNT-1))
              done

              # Fallback if metadata fails
              if [ -z "$INSTANCE_HOSTNAME" ]; then
                INSTANCE_HOSTNAME="Metadata-Unavailable"
              fi

              # Fetch EC2 Instance IP
              INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

              # Create custom index.html
              echo "<!DOCTYPE html>
              <html lang='en'>
              <head>
                <meta charset='UTF-8'>
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                <title>CodeFusion: The DevOps Synergy</title>
                <link rel='stylesheet' href='style.css'>
              </head>
              <body>
                <div class='container'>
                  <h1>Welcome to <span class='highlight'>CodeFusion: The DevOps Synergy</span></h1>
                  <h2>Today's Topic: <span class='highlight'>Empowering Innovation: Cloud & DevOps</span></h2>
                  <p>Presented by: <span class='highlight'>Nakul Grover</span></p>
                  <p><strong>Sr. DevOps Engineer</strong></p>
                  <p>Thomson Reuters | Ex – Deloitte USI</p>
                  <hr>
                  <h3>About This Project</h3>
                  <p>
                    This project demonstrates the integration of AWS services like S3, EC2, and Application Load Balancer (ALB) to host a static website.
                    The website is hosted on an S3 bucket and also served via EC2 instances. The ALB distributes traffic across multiple EC2 instances,
                    ensuring high availability and scalability.
                  </p>
                  <p><strong>EC2 Instance Hostname:</strong> $INSTANCE_HOSTNAME</p>
                </div>
                <script src='script.js'></script>
              </body>
              </html>" > /var/www/html/index.html

              # Create style.css
              echo "body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f9;
                color: #333;
                text-align: center;
                padding: 50px;
              }
              .container {
                max-width: 800px;
                margin: 0 auto;
                background: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
              }
              h1, h2, h3 {
                color: #2c3e50;
              }
              .highlight {
                color: #e74c3c;
              }
              p {
                font-size: 1.1em;
                line-height: 1.6;
              }
              hr {
                border: 0;
                height: 1px;
                background: #ddd;
                margin: 20px 0;
              }" > /var/www/html/style.css

              # Create script.js
              echo "// Fetch the EC2 instance Hostname dynamically
              fetch('http://169.254.169.254/latest/meta-data/hostname')
                .then(response => response.text())
                .then(ip => {
                  document.getElementById('ip-address').textContent = ip;
                })
                .catch(() => {
                  document.getElementById('ip-address').textContent = 'Unable to fetch Hostname';
                });" > /var/www/html/script.js

              # Set permissions for Apache files
              chmod 644 /var/www/html/index.html
              chmod 644 /var/www/html/style.css
              chmod 644 /var/www/html/script.js
              EOF

  tags = {
    Name = "web-instance-${count.index}"
  }
}
