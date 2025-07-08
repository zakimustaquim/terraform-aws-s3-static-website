# the s3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.config.bucket_name

  force_destroy = var.config.destroy_bucket
  tags          = var.config.bucket_tags
}

# bucket website configuration
resource "aws_s3_bucket_website_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = var.config.index_suffix # default is "index.html"
  }
  error_document {
    key = var.config.error_key # default is "error.html"
  }
}

# upload the index.html file and make it publicly accessible
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = var.config.index_suffix
  source       = "${path.module}/www/${var.config.index_suffix}"
  content_type = "text/html"
  etag         = filemd5("${path.module}/www/${var.config.index_suffix}") # MD5 hash to track file changes

  depends_on = [ aws_s3_bucket_public_access_block.public_access_block ] 
}

# upload the error.html file and make it publicly accessible
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = var.config.error_key
  source       = "${path.module}/www/${var.config.error_key}"
  content_type = "text/html"
  etag         = filemd5("${path.module}/www/${var.config.error_key}") # MD5 hash to track file changes

  depends_on = [ aws_s3_bucket_public_access_block.public_access_block ] 
}

# manage public access to the s3 bucket
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false

  # explicitly making sure the bucket is created before applying the public access block
  depends_on = [ aws_s3_bucket.s3_bucket ]
}

# s3 bucket policy allowing read on all objects
resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          "${aws_s3_bucket.s3_bucket.arn}/*"
        ]
      },
    ]
  })
  depends_on = [ aws_s3_bucket_public_access_block.public_access_block ]
}
