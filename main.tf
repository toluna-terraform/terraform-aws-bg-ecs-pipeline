locals{
    source_repository_url = "https://bitbucket.org/${var.source_repository}"    
}

module "code-pipeline" {
  source              = "toluna-terraform/code-pipeline/aws"
  version             = "~>0.0.5"
  env_name            = var.env_name
  source_repository   = var.source_repository
  s3_bucket           = aws_s3_bucket.codepipeline_bucket.bucket
  code_build_projects = ["codebuild-${var.env_name}"]
  code_deploy_applications = ["ecs-${var.env_name}-deploy"]
  trigger_branch      = var.trigger_branch // should be changed to the branch from environments.json
  trigger_events      = ["push","merge"]
}

module "code-build" {
  source                = "toluna-terraform/code-build/aws"
  version               = "~>0.0.5"
  env_name              = var.env_name
  s3_bucket             = aws_s3_bucket.codepipeline_bucket.bucket
  privileged_mode       = true
  source_branch         = var.trigger_branch // should be changed to the branch from environments.json
  source_repository     = var.source_repository
  source_repository_url = local.source_repository_url
  environment_variables_parameter_store = var.environment_variables_parameter_store
  environment_variables = var.environment_variables
  buildspec_file = var.buildspec_file
}


module "code_deploy" {
  source           = "toluna-terraform/code-deploy/aws"
  version          = "~>0.0.1"
  env_name         = var.env_name
  s3_bucket        = aws_s3_bucket.codepipeline_bucket.bucket
  ecs_service_name = var.ecs_service_name
  ecs_cluster_name = var.ecs_cluster_name
  alb_listener_arn = var.alb_listener_arn
  alb_tg_blue_name = var.alb_tg_blue_name
  alb_tg_green_name = var.alb_tg_green_name
}

resource "aws_s3_bucket" "codepipeline_bucket" {
 bucket = "s3-${var.env_name}-codepipeline"
 acl = "private"
 tags = tomap({
   UseWithCodeDeploy = true
   created_by       = "terraform"
 })
}
