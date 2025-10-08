output "instance_id" {
  value = aws_instance.app.id
}

output "public_dns" {
  value = aws_instance.app.public_dns
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app.public_ip  
}
