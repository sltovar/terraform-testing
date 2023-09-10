# This picks the AWS us-east-1 region
provider "aws" {
    region  = "us-east-1"
}
# Creates an aws t2.micro instance with the AMI configuration
resource "aws_instance" "example" {
    ami     = "ami-40d28157"
    instance_type = "t2.micro"
    # Security group ID attribute (type.name.attribute)
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    # Adds a script to print "Hello, World" to index.html
    # using busybox to fire up a web server on port 8080
    # for the file.
    # (EOF to allow for multiple line strings)
    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, World" > index.html
        nohup busybox httpd -f -p 8080 &
        EOF

    # Renames the instance as terraform-example
    tags    = {
        Name = "terraform-example"
    }

}

# Creates a security group to allow for the flow of TCP traffic from
# the EC2 instance on port 8080 on the cidr block 0.0.0.0/0 (all IPs)
resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}