locals{
    source_repository_url = "https://bitbucket.org/${var.source_repository}"  
    //TODO: get image URI as param, we're creating it in the task definition resource
    //TODO: handle image tag - replace "latest"
    image_uri             = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.ecr_repo_name}:latest"
}


module "code-pipeline" {
  #source                   = "toluna-terraform/code-pipeline/aws"
  #version                  = "~>0.0.5"
  source                   = "../terraform-aws-code-pipeline"
  env_name                 = var.env_name
  source_repository        = var.source_repository
  s3_bucket                = aws_s3_bucket.codepipeline_bucket.bucket //TODO: consider remove
  code_build_projects      = [module.code-build.attributes.name] 
  code_deploy_applications = [module.code-deploy.attributes.name] 
  trigger_branch           = var.trigger_branch
  trigger_events           = ["push","merge"]
  depends_on = [
    aws_s3_bucket.codepipeline_bucket, //TODO: consider remove
  ]
}

module "code-build" {
  #source                               = "toluna-terraform/code-build/aws"
  #version                              = "~>0.0.5"
  source                                = "../terraform-aws-code-build"
  env_name                              = var.env_name
  s3_bucket                             = aws_s3_bucket.codepipeline_bucket.bucket //TODO: consider remove
  privileged_mode                       = true
  environment_variables_parameter_store = var.environment_variables_parameter_store
  environment_variables                 = merge(var.environment_variables, {APPSPEC = templatefile("${path.module}/templates/appspec.json.tpl",{ yoyo = "yo"}) }) //TODO: try to replace with file
  buildspec_file                        = templatefile("${path.module}/templates/buildspec.yml.tpl", { IMAGE_URI = local.image_uri, DOCKERFILE_PATH = var.dockerfile_path, IMAGE_REPO_NAME = var.ecr_repo_name ,ADO_USER = data.aws_ssm_parameter.ado_user.value ,ADO_PASSWORD = data.aws_ssm_parameter.ado_password.value})
  depends_on = [
    aws_s3_bucket.codepipeline_bucket, //TODO: consider remove
  ]
}


module "code-deploy" {
  #source             = "toluna-terraform/code-deploy/aws"
  #version            = "~>0.0.1"
  source                   = "../terraform-aws-code-deploy"
  env_name           = var.env_name
  s3_bucket          = aws_s3_bucket.codepipeline_bucket.bucket //TODO: consider remove
  ecs_service_name   = var.ecs_service_name
  ecs_cluster_name   = var.ecs_cluster_name
  alb_listener_arn   = var.alb_listener_arn
  alb_tg_blue_name   = var.alb_tg_blue_name
  alb_tg_green_name  = var.alb_tg_green_name
  ecs_iam_roles_arns = var.ecs_iam_roles_arns
}

//TODO: do we need this bucket at all ?
resource "aws_s3_bucket" "codepipeline_bucket" {
 bucket = "s3-${var.env_name}-codepipeline"
 acl = "private"
 tags = tomap({
   UseWithCodeDeploy = true
   created_by        = "terraform"
 })
}
