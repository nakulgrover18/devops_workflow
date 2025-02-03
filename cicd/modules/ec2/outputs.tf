output "instance_public_ips" {
  value = aws_instance.web[*].public_ip
}

output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.web[*].id
}