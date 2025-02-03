resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name

  tags = {
    Name = "Static Website Bucket"
  }
}

# Disable Block Public Access for the bucket
resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_website.bucket
  key          = "index.html"
  source       = "${path.module}/../../static-site/index.html"
  content_type = "text/html"
  etag = filemd5("${path.module}/../../static-site/index.html")
}

resource "aws_s3_object" "style" {
  bucket       = aws_s3_bucket.static_website.bucket
  key          = "style.css"
  source       = "${path.module}/../../static-site/style.css"
  content_type = "text/css"
  etag = filemd5("${path.module}/../../static-site/style.css")
}

resource "aws_s3_object" "script" {
  bucket       = aws_s3_bucket.static_website.bucket
  key          = "script.js"
  source       = "${path.module}/../../static-site/script.js"
  content_type = "application/javascript"
  etag = filemd5("${path.module}/../../static-site/script.js")

}
