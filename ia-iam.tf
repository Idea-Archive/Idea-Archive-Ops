resource "aws_iam_role" "ia-codepipeline-role" {
    name = "ia-codepipeline-role"

    assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement" : [
            {
                "Action":"sts:AssumeRole",
                "Principal" : {
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