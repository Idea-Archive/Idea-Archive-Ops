resource "aws_codebuild_project" "ia-codebuild-plan" {
    name = "ia-codebuild-project"
    description = "ia_codebuild_project"
    build_timeout = 5
    service_role = aws_iam_role.ia-codebuild-role.arn

    source {
        type = "GITHUB"
        location = "https://github.com/Idea-Archive/Idea-Archive-Server.git"
        buildspec = file("buildspec/ia-buildspec.yml")
        git_clone_depth = 1

        git_submodules_config{
            fetch_submodules = true
        }
    }

    source_version = "master"
    artifacts {
        type = "NO_ARTIFACTS"
    }

    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image = "aws/codebuild/standard:5.0"
        type = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"

        dynamic "environment_variable" {
            for_each = var.env_vars
            content {
                name = environment_variable.key
                value = environment_variable.value
            }
        }
    }
}