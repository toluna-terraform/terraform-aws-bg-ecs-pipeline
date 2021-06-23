variable "env_name" {
    type = string
}

variable "source_repository" {
    type = string
}

variable "dockerfile_path" {
    type = string
} 

 variable "ecs_cluster_name" {
     type = string
 }

variable "ecs_service_name" {
     type = string
 }

variable "alb_listener_arn" {
     type = string
 }

variable "alb_tg_blue_name" {
     type = string
 }

variable "alb_tg_green_name" {
     type = string
 }

variable "ecs_iam_roles_arns" {
     type = list(string)
 }

 variable "ecr_repo_name" {
     type = string
 }
