resource "aws_codedeploy_app" "ia-codedeploy-app" {
    compute_platform = "Server"
    name = "ia-codedeploy-app"
}