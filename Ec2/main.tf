#---Create Bastion Host-----#
resource "aws_instance" "Bastion" {
    ami = var.image
    instance_type = var.type
    vpc_security_group_ids = [var.allow_web_traffic]
    key_name = "test"
    subnet_id = var.public_subnet_3
    tags = {
      Name = "Bastion"
    }
    user_data = filebase64("${path.module}/bastion.sh")
}

#---Create Frontend Host---#
resource "aws_instance" "Frontend_1" {
    ami = var.image
    instance_type = var.type
    vpc_security_group_ids = [var.allow_web_traffic]
    key_name = "test"
    subnet_id = var.public_subnet_1
    tags = {
      Name = "Frontend 1"
    }
    user_data = filebase64("${path.module}/frontend.sh")
}

resource "aws_instance" "Frontend_2" {
    ami = var.image
    instance_type = var.type
    vpc_security_group_ids = [var.allow_web_traffic]
    key_name = "test"
    subnet_id = var.public_subnet_2
    tags = {
      Name = "Frontend 2"
    }
    user_data = filebase64("${path.module}/frontend.sh")
}

#----Create Backend Host------#
resource "aws_instance" "Backend" {
    ami = var.image
    instance_type = var.type
    vpc_security_group_ids = [var.allow_web_traffic]
    key_name = "test"
    subnet_id = var.private_subnet
    tags = {
      Name = "Backend"
    }
    user_data = filebase64("${path.module}/backend.sh")
}
