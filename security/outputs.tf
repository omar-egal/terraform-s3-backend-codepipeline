#---security/outputs.tf---

output "security_group_id" {
  value = [aws_security_group.week24_sg["public"].id]
}