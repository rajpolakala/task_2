variable "region" {
  default = "ap-southeast-1"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "ami" {
  default = "ami-005835d578c62050d"
}
variable "AWS_ACCESS_KEY_ID" {
  module "AWS_ACCESS_KEY_ID" {
    source = "var.AWS_ACCESS_KEY_ID"
  }

}
