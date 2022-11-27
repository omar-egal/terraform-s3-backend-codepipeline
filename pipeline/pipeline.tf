#---pipeline/pipeline.tf

# Codebuild project for plan
resource "aws_codebuild_project" "tf_plan" {
  name          = "tf-cicd-plan"
  description   = "Plan stage for Terraform"
  service_role  = aws_iam_role.tf_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = var.type
    image_pull_credentials_type = "CODEBUILD"
#     registry_credential{
#         credential = var.dockerhub_credentials
#         credential_provider = "SECRETS_MANAGER"
#     }
#  }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("/plan-buildspec.yaml")
 }
}

# Codebuild project for apply 
resource "aws_codebuild_project" "tf_apply" {
  name          = "tf-cicd-apply"
  description   = "Apply stage for Terraform"
  service_role  = aws_iam_role.tf_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = var.type
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
 }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("/apply-buildspec.yaml")
 }
}

# Create CICD Pipeline 
resource "aws_codepipeline" "cicd_pipeline" {

    name = "tf-cicd"
    role_arn = aws_iam_role.tf_codepipeline_role.arn

    artifact_store {
        type="S3"
        location = aws_s3_bucket.codepipeline_artifacts.id
    }

    stage {
        name = "Source"
        action{
            name = "Source"
            category = "Source"
            owner = "AWS"
            provider = "CodeStarSourceConnection"
            version = "1"
            output_artifacts = ["tf-code"]
            configuration = {
                FullRepositoryId = "omar-egal/terraform-s3-backend-codepipeline"
                BranchName   = "main"
                ConnectionArn = var.codestar_connector_credentials
                OutputArtifactFormat = "CODE_ZIP"
            }
        }
    }

    stage {
        name ="Plan"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["tf-code"]
            configuration = {
                ProjectName = "tf-cicd-plan"
            }
        }
    }

    stage {
        name ="Deploy"
        action{
            name = "Deploy"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["tf-code"]
            configuration = {
                ProjectName = "tf-cicd-apply"
            }
        }
    }

}