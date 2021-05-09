variable "allow_web_traffic" {}
variable "alb_target_group_arn" {}
variable "public_subnet_1" {}
variable "public_subnet_2" {}
variable "ssh_user" {
    type = string
    default = "ubuntu"
}
variable "private_key_path" {}

# variable "path_file" {
#     default =  "./scripts/test.sh"
# }