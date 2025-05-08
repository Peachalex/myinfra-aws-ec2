output "vpc_id" {
  value = aws_vpc.web.id
}

output "subnet1_id" {
  value = aws_subnet.subnet1.id
}

output "web_instance_public_ip" {
  value = aws_instance.webserver.public_ip
}