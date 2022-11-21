# terraform-s3-backend-codepipeline

1. VPC with CIDR 10.0.0.0/16

2. 2 subnets (public) with CIDR 10.0.1.0/24 and 10.0.2.0/24

3. An autoscaling group with Amazon Linux 2 instance (t3.micro) with a min of 2 instances and a max of 3

4. Create a bucket to store your terraform state

5. Use AWS Codepipeline to create a CI/CD pipeline that will test and deploy the infrastructure through AWS