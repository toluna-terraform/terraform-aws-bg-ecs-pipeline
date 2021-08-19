version: 0.2

phases:
  install:
    runtime-versions:
      docker: 18
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - $(aws ecr get-login --no-include-email --region $AWS_REGION)
      - CODEBUILD_RESOLVED_SOURCE_VERSION="$CODEBUILD_RESOLVED_SOURCE_VERSION"
      - IMAGE_TAG="$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)_build_$CODEBUILD_BUILD_NUMBER"
      - IMAGE_URI="${IMAGE_URI}"
      - IMAGE_REPO_NAME="${IMAGE_REPO_NAME}"
  build:
    commands:
      - echo Build started on `date`
      - cd ${DOCKERFILE_PATH}
      - echo ADO_USER=$ADO_USER, ADO_PASSWORD=$ADO_PASSWORD
      - docker build -t ${IMAGE_URI} --build-arg ADO_USER=${ADO_USER} --build-arg ADO_PASSWORD=${ADO_PASSWORD} .
  post_build:
    commands:
      - cd $CODEBUILD_SRC_DIR
      - bash -c "if [ /"$CODEBUILD_BUILD_SUCCEEDING/" == /"0/" ]; then exit 1; fi"
      - echo Build stage successfully completed on `date`
      - echo Pushing the Docker image...
      - docker push $IMAGE_URI
      - printf '[{"name":"%s","imageUri":"%s"}]' "$IMAGE_TAG" "$IMAGE_URI" > image_definitions.json
      - aws ecs describe-task-definition --task-definition $IMAGE_REPO_NAME --query "taskDefinition" --output json > taskdef.json
      - export var=$(aws ecs describe-task-definition --task-definition $IMAGE_REPO_NAME --query "taskDefinition.taskDefinitionArn" --output text)
      - echo $APPSPEC > appspec.json
      - sed -i "s+<TASKDEF_ARN>+$var+g" appspec.json
      - sed -i "s+<CONTAINER_NAME>+$IMAGE_REPO_NAME+g" appspec.json

artifacts:
  files:
    - appspec.json
    - taskdef.json
  discard-paths: yes
