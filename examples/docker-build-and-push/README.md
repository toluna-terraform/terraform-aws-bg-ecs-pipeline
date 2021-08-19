## In this folder you able to find a Buildspec.yml.tpl sample for Docker Build & Push

### 📃 Buildspec file
This Buildspec.yml.tpl is a template that should be located in your Terraform folder, beside to "pipelines.tf" file.
The Buildspec.yml configures all the steps that will be executed in your CodedBuild project as part of your Pipeline.

### Variables
This Buildspec.yml.tpl contains number of variables that will be replaced during the ```terraform apply``` execution.
The "Source" column presents the place of the value, if you would like to change the value, go the the source of the var.
Additionally, if these are a unique vars without secured strings - you can set the values hardcoded as well.

| Variable  | Value | Source | Usage | 
| --------- |:-------------:| :-------------:| :----------:|
| AWS_REGION | us-east-1 (will be changed between services)| data.tf in the module repository. | ```ecr get-login``` command. |
| IMAGE_URI | REPO_URL:latest | based on the var:ecr_repo_url in pipelines.tf file in your repository. | ```ecs describe-task-definition``` command. | 
| DOCKERFILE_PATH | service/ | The path to the Dockerfile in your repository. | This is the working dir. |
| ADO_USER | JenkinsArtifact | SSM parameter /app/ado_user | In use in ```docker build``` command. |
| ADO_PASSWORD | ****** | SSM parameter /app/ado_password | In use in ```docker build``` command. |

### ✍🏼 Edit your Buildspec.yml.tpl
If you want to add some tests or commands in your Buildspec - you can do it, all you need to do is:
- Add a line as a Bash command in the file.
- Apply your changes (```terraform apply```).
