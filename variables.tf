variable "env_name" {
    type = string
    default = "devops-ecs-pipe"
}

variable "source_repository" {
    type = string
    default = "tolunaengineering/chorus"
}

variable "trigger_branch" {
    type     = string
 }

variable "dockerfile_path" {
    type = string
    default = "service/"
} 

 variable "ecs_cluster_name" {
     type = string
     default = "chorus-devops"
 }

variable "ecs_service_name" {
     type = string
     default = "chorus-devops"
 }

variable "alb_listener_arn" {
     type = string
     default = "arn:aws:elasticloadbalancing:us-east-1:047763475875:listener/app/chorus-devops/ed1ae8441cfeca71/20496ed7dcadde70"
 }

variable "alb_tg_blue_name" {
     type = string
     default = "chorus-devops-blue"
 }

variable "alb_tg_green_name" {
     type = string
     default = "chorus-devops-green"
 }

variable "ecs_iam_roles_arns" {
     type = list(string)
     default = ["arn:aws:iam::047763475875:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"]
 }

 variable "ecr_repo_name" {
     type = string
     default = "chorus-devops"
 }

variable "environment_variables_parameter_store" {
 type = map(string)
 default = {
    "ADO_USER" = "/app/ado_user",
    "ADO_PASSWORD" = "/app/ado_password"
 }
}

variable "environment_variables" {
 type = map(string)
 default = {
 }
}