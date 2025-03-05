output "instance_public_ip" {
     value = aws_instance.tf_ec2_instance.public_ip
   }

output "instance_id" {
     value = aws_instance.tf_ec2_instance.id
   }

output "Permissions_for_ssh_connection" {
  value = "Ensure the SSH private key has correct permissions by running: chmod 400 ~/.ssh/masani.pem"
}
output "ssh_to_ec2_instance" {
  value = "ssh -i ~/.ssh/masani.pem ubuntu@${aws_instance.tf_ec2_instance.public_ip}"
}
