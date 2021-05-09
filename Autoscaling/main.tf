#----Create Launch Template---------#
resource "aws_launch_template" "foobar" {
  name_prefix   = "foobar"
  image_id      = "ami-013f17f36f8b1fefb"
  instance_type = "t2.micro"
  key_name = "test"
  vpc_security_group_ids = [var.allow_web_traffic]
  user_data = filebase64("${path.module}/test.sh")
}

#-----Create Autoscaling Group------#
resource "aws_autoscaling_group" "bar" {
  vpc_zone_identifier = [var.public_subnet_1,var.public_subnet_2]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}

#--------Attach Autoscaling Group to Target Group--------#
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.bar.id
  alb_target_group_arn   = var.alb_target_group_arn
}


#-----Integration Terraform with Ansible-------#


# resource "aws_instance" "Test-Ansible" {
#   ami = "ami-013f17f36f8b1fefb"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [var.allow_web_traffic]
#   subnet_id = var.public_subnet_1
#   associate_public_ip_address = true
#   key_name = "test"
#   tags = {
#     Name = "Test-ansible"
#   }
  
#   provisioner "remote-exec" {
#     inline = ["sudo apt update", "sudo apt install python3 -y", "sudo apt install ansible -y", "echo Done!"]

#     connection {
#       type = "ssh"
#       user = var.ssh_user
#       private_key = file(var.private_key_path)
#       host = aws_instance.Test-Ansible.public_ip
#     }
#   }

#   provisioner "local-exec" {
#     command = "ansible-playbook -i ${aws_instance.Test-Ansible.public_ip}, --private-key ${var.private_key_path} ../Ansible/nginx.yml"
#   }
# }