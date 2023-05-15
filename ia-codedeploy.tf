resource "aws_codedeploy_app" "ia-codedeploy-app" {
    compute_platform = "Server"
    name = "ia-codedeploy-app"
}

data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"

    principals {
        type        = "Service"
        identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "codepipeline_role" {
    name               = "codepipeline_iam_role"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
    role       = aws_iam_role.codepipeline_role.name
}

resource "aws_sns_topic" "ia-topic" {
    name = "ia-topic"
}

resource "aws_codedeploy_deployment_group" "ia-codedeploy-group" {
    app_name              = aws_codedeploy_app.ia-codedeploy-app.name
    deployment_group_name = "ia-codedeploy-group"
    service_role_arn      = aws_iam_role.codepipeline_role.arn

ec2_tag_set {
    ec2_tag_filter {
        key   = "Name"
        type  = "KEY_AND_VALUE"
        value = "ia-main-server"
    }

}

trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "ia-trigger"
    trigger_target_arn = aws_sns_topic.ia-topic.arn
}

auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
}

alarm_configuration {
    alarms  = ["my-alarm-name"]
    enabled = true
    }
}