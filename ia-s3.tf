resource "aws_s3_bucket" "ia-s3-bucket" {
    bucket = "ia-spring-build-bucket-0503"
    acl = "private"
}