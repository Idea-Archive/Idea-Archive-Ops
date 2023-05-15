resource "aws_iam_role" "ia-codepipeline-role" {
    name = "ia-codepipeline-role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement" : [
        {
            "Action":"sts:AssumeRole",
            "Principal" : 
            {
                "Service": "codepipeline.amazonaws.com"
            },
        "Effect" : "Allow",
        "Sid" : ""
        }
    ]
}
EOF

    tags = {
        Name = "ia-codepipeline-role"
    }
}

data "aws_iam_policy_document" "ia-codepipeline-policies"{
    statement{
        sid = ""
        actions = ["codestar-connections:UserConnection"]
        resources = ["*"]
        effect = "Allow"
    }
    statement {
        sid = ""
        actions = ["cloudwatch:*", "s3:*", "codebuild:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "ia-pipeline-policy" {
    name = "ia-cicd-pipeline-policy"
    path = "/"
    description = "pipeline policy"
    policy = data.aws_iam_policy_document.ia-codepipeline-policies.json
}

resource "aws_iam_role_policy_attachment" "ia-pipeline-attachment-1" {
    policy_arn = aws_iam_policy.ia-pipeline-policy.arn
    role = aws_iam_role.ia-codepipeline-role.id
}

resource "aws_iam_role_policy_attachment" "ia-pipeline-attachment-2" {
    policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
    role = aws_iam_role.ia-codepipeline-role.id
}

resource "aws_iam_role" "ia-codebuild-role" {
    name = "ia-codebuild-role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement" : [
        {
            "Action":"sts:AssumeRole",
            "Principal": {
                "Service" : "codebuild.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "ia-cicd-build-policies" {
    statement{
        sid = ""
        actions = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*", "iam:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "ia-cicd-build-policy" {
    name = "tf-cicde-build-policy"
    path = "/"
    description = "Codebuild policy"
    policy = data.aws_iam_policy_document.ia-cicd-build-policies.json
}

resource "aws_iam_role_policy_attachment" "ia-cicd-codebuild-attachment1" {
    policy_arn = aws_iam_policy.ia-cicd-build-policy.arn
    role       = aws_iam_role.ia-codebuild-role.id
}

resource "aws_iam_role_policy_attachment" "ia-cicde-codebuild-attachment2" {
    policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
    role       = aws_iam_role.ia-codebuild-role.id
}