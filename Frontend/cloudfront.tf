resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "s3-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn_distribution" {

  enabled = true

  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id   = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  origin {
    domain_name = aws_lb.app_alb.dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {

  path_pattern     = "/api/*"
  target_origin_id = "alb-origin"

  viewer_protocol_policy = "redirect-to-https"

  allowed_methods = [
    "GET",
    "HEAD",
    "OPTIONS",
    "PUT",
    "POST",
    "PATCH",
    "DELETE"
  ]

  cached_methods = [
    "GET",
    "HEAD"
  ]

  forwarded_values {

    query_string = true

    headers = ["*"]

    cookies {
      forward = "all"
    }
  }

  min_ttl     = 0
  default_ttl = 0
  max_ttl     = 0
}

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}


