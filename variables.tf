variable "availability_zones" {
  type    = string
  default = "us-east-2a"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "amis" {
  type = map(any)
  default = {
    "us-east-2" : "ami-04f167a56786e4b09"
    "us-west-2" : "ami-0cd825c0e361f324e"
  }
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}