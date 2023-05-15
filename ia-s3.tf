resource "aws_s3_bucket" "ia-s3-buckets" {
    bucket = var.code_pipeline_bucekt
    acl = "private"
}