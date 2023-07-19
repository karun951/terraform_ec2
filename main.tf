provider "aws" {
  region = "ap-south-1"  # Set your desired AWS region
  access_key = "AKIAU3ZRH2XBGGDT5JK5"
  secret_key = "/itEQuNGG7dMM6FQh/xlZMD7rDEFRGZI5xxpghzX"
}

# Create a new EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-08e5424edfe926b43"  # Replace with your desired AMI ID
  instance_type = "t2.micro"      # Replace with your desired instance type
  key_name      = "example-key"   # Replace with your desired key pair name

  # Other configuration options for your EC2 instance...
}

resource "aws_key_pair" "example" {
  key_name   = "example-key"  # Replace with your desired key pair name
  public_key = file("/root/.ssh/id_rsa.pub")  # Replace with the path to your public key file
}

data "aws_ami" "example" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]  # Replace with your desired AMI filter string
  }
  
    owners =[ "099720109477" ]
}

# Create a launch configuration
resource "aws_launch_configuration" "example" {
  name          = "example-launch-config"
  image_id      = "ami-08e5424edfe926b43"  # Replace with your desired AMI ID
  instance_type = "t2.micro"      # Replace with your desired instance type
  key_name      = "example-key"   # Replace with your desired key pair name

  # Other configuration options for your launch configuration
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "example" {
  name                 = "example-asg"
  launch_configuration = aws_launch_configuration.example.name
  min_size             = 1   # Replace with your desired minimum size
  max_size             = 3   # Replace with your desired maximum size
  desired_capacity     = 2   # Replace with your desired initial capacity
  vpc_zone_identifier = ["subnet-01eec30f9aee65b2d"]

  # Other configuration options for your Auto Scaling Group...
}

resource "aws_elb" "example" {
  name               = "example-elb"
  security_groups    = [aws_security_group.example.id]  # Replace with your desired security group(s)
  availability_zones = ["ap-south-1a", "ap-south-1b"]     # Replace with your desired availability zones

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  # Other configuration options for your Load Balancer...
}
resource "aws_lb_target_group" "target_group" {
  name = "awstarget"
  port = 80
  protocol = "HTTP"
  vpc_id = "vpc-035ab994df91a362c"
}

# Create a Load Balancer listener
resource "aws_elb_attachment" "example" {
  elb    = aws_elb.example.id
  instance = aws_instance.example.id  # Replace with your instance ID or use the appropriate reference
}

# Create a security group
resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Example security group"

  # Specify your security group rules...
}


# Allocate an Elastic IP
resource "aws_eip" "example" {
  instance = aws_instance.example.id  # Reference the EC2 instance resource

  # Other configuration options for your Elastic IP...
}

# Associate the Elastic IP with the EC2 instance
resource "aws_eip_association" "example" {
  instance_id   = aws_instance.example.id  # Reference the EC2 instance resource
  allocation_id = aws_eip.example.id       # Reference the Elastic IP resource
}

