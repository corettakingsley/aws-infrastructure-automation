
# Retrieve the latest Amazon Linux 2023 ARM64 AMI
data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

# EC2 Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-app-"
  image_id      = data.aws_ssm_parameter.amazon_linux.value
  instance_type = "t4g.micro"

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    mkdir -p /var/www/html

    cat > /var/www/html/index.html <<'HTML'
    <html>
      <head><title>Nova Retail</title></head>
      <body>
        <h1>Nova Retail Application</h1>
        <p>EC2 infrastructure is running successfully.</p>
      </body>
    </html>
    HTML

    cat > /etc/systemd/system/nova-retail.service <<'UNIT'
    [Unit]
    Description=Nova Retail Web Server
    After=network.target

    [Service]
    ExecStart=/usr/bin/python3 -m http.server 80 --directory /var/www/html
    Restart=always

    [Install]
    WantedBy=multi-user.target
    UNIT

    systemctl daemon-reload
    systemctl enable --now nova-retail.service
  EOF
  )

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-app-server"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
