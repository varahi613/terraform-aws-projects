resource "aws_s3_bucket" "tf_s3_bucket" {
  bucket = "my-tf-nodejs-bucket"

  tags = {
    Name        = "sas_nodejs_bucket"
    Environment = "Dev"
  }
}
resource "aws_s3_object" "tf_s3_object" {
  bucket = aws_s3_bucket.tf_s3_bucket.bucket
  for_each = fileset("../public/images", "**")
  key    = "images/${each.key}"
  source = "../public/images/${each.key}"
}