```text
What is a Provisioner?

A Terraform provisioner is used to execute some action after Terraform creates a resource.

For example, you create an EC2 instance and then want to run a shell command on it.

resource "aws_instance" "app" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y nginx",
      "sudo systemctl start nginx"
    ]
  }
}

Terraform first creates:

EC2 Instance
     ↓
Terraform connects to it
     ↓
Runs shell commands
     ↓
Install nginx
When would you use a provisioner?

Only when there is no better Terraform-native solution.

For example, imagine you absolutely need to execute a script after creating an instance:

provisioner "local-exec" {
  command = "echo ${aws_instance.app.public_ip} >> inventory.txt"
}

Here Terraform runs a command on the machine where Terraform is running.
```
```text
Another example is remote-exec, where Terraform executes commands inside the created machine.

local-exec
Terraform machine
      ↓
   command

remote-exec
Terraform machine
      ↓
   EC2 instance
Why should we avoid provisioners?

There are several reasons.

1. It breaks the declarative model

Terraform is normally:

"Tell me what the infrastructure should look like."

For example:

instance_type = "t3.medium"

Terraform figures out how to achieve that state.

But provisioner says:

"After creating this, execute these commands. "That's more imperative.
```
```text

2. Provisioners are often not idempotent

Suppose you have:

sudo yum install nginx

The first time:

Install nginx

But if the provisioner runs again, you may get different behavior.

Terraform's preferred approach is to describe the desired state rather than repeatedly executing commands.

3. They can fail unpredictably

For remote-exec, Terraform needs connectivity:

Terraform
   |
   | SSH
   ↓
EC2

If SSH isn't ready yet:

Connection refused

Or:

Timeout

Or:

Security group blocking port 22

The EC2 instance itself may have been created successfully, but the provisioner fails.

What should we use instead?

Usually, prefer:

User data

For EC2 bootstrapping:

resource "aws_instance" "app" {
  ami           = "ami-123456"
  instance_type = "t3.micro"

  user_data = <<-EOF
    #!/bin/bash
    yum install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF
}

The flow becomes:

Terraform
   ↓
Create EC2
   ↓
EC2 starts
   ↓
User data executes
   ↓
Install/configure application

This is generally better for initial EC2 bootstrapping.

Configuration management

For more complex configuration, use something like Ansible.

Terraform
   ↓
Create infrastructure
   ↓
Ansible
   ↓
Configure servers

Terraform handles:

VPC
EC2
ALB
RDS
Security Groups

Ansible handles:

Packages
Configuration files
Users
Services
Application configuration
```
```text
"I use Terraform provisioners only as a last resort when there is no better native solution. Provisioners are avoided because they are imperative, can break Terraform's declarative model, are difficult to make idempotent, and can fail due to connectivity or timing issues. For EC2 bootstrap, I prefer user data, and for configuration management I prefer tools like Ansible."

Remember this simple rule:
Terraform → Build infrastructure
User Data → Initial server bootstrap
Ansible   → Server configuration
Provisioner → Last resort

```
