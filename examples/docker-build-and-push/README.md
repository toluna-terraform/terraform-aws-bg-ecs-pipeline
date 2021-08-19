**In this folder you able to find a Buildspec.yml.tpl sample for Docker Build & Push**

The Buildspec.yml.tpl contains number of variables that will be replaced in the ```terraform apply``` command,.

| Variable  | Value | Source | Usage | 
| --------- |:-------------:| :-------------:| :----------:|
| AWS_REGION | us-east-1 (will be changed between services)| data.tf in the module repository. | ```ecr get-login``` command. |
| IMAGE_URI | REPO_URL:latest | based on the var:ecr_repo_url in pipelines.tf file in your repository. | ```ecs describe-task-definition``` command. | 
| DOCKERFILE_PATH | service/ | The path to the Dockerfile in your repository. | This is the working dir. |
| ADO_USER | JenkinsArtifact | SSM parameter /app/ado_user | In use in ```docker build``` command. |
| ADO_PASSWORD | ****** | SSM parameter /app/ado_password | In use in ```docker build``` command. |