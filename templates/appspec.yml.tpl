version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "<TASKDEF_ARN>"
        LoadBalancerInfo:
          ContainerName: "<CONTAINER_NAME>"
          ContainerPort: 80

#Hooks:
#  - BeforeInstall: "LambdaFunctionToValidateBeforeInstall"
#  - AfterInstall: "LambdaFunctionToValidateAfterInstall"
#  - AfterAllowTestTraffic: "LambdaFunctionToValidateAfterTestTrafficStarts"
#  - BeforeAllowTraffic: "LambdaFunctionToValidateBeforeAllowingProductionTraffic"
#  - AfterAllowTraffic: "LambdaFunctionToValidateAfterAllowingProductionTraffic"