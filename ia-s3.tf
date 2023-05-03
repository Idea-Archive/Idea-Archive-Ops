resource "aws_s3_bucket" "ia-s3-buckets" {
    bucket = "ia-spring-build-bucket-0502"
    acl = "private"
}