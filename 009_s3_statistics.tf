locals {
  bucket_name_statistics = "devops-statistics-middleware"
}

module "s3_bucket_statistics" {
  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-s3-bucket-module?ref=v2.11.1"
  providers = {
    aws = aws.prodbackoffice
  }
  bucket        = local.bucket_name_statistics
  acl           = "private"
  force_destroy = true

  tags = merge(var.tags,
    {
      "ib:resource:name" = local.bucket_name_statistics
    },
    {
      "Name" = local.bucket_name_statistics
    }
  )

  versioning = {
    enabled = false
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        bucket_key_enabled = true
        kms_master_key_id  = aws_kms_key.kms-s3.key_id
        sse_algorithm      = "aws:kms"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = "tomcaterrors"
      enabled = true
      prefix  = "tomcat-errors/"

      expiration = {
        days = 30
      }
    },
    {
      id      = "dbconnections"
      enabled = true
      prefix  = "db-connections/"

      expiration = {
        days = 30
      }
    }
  ]

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # S3 Bucket Ownership Controls
  control_object_ownership = true
  #object_ownership         = "BucketOwnerPreferred"
}

### Crear carpetas devops-statistics-middleware
resource "aws_s3_bucket_object" "tomcat-errors" {
  provider = aws.prodbackoffice
  bucket   = module.s3_bucket_statistics.s3_bucket_id
  acl      = "private"
  key      = "tomcat-errors/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "db-connections" {
  provider = aws.prodbackoffice
  bucket   = module.s3_bucket_statistics.s3_bucket_id
  acl      = "private"
  key      = "db-connections/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "Big-Bang" {
  provider = aws.prodbackoffice
  bucket   = module.s3_bucket_statistics.s3_bucket_id
  acl      = "private"
  key      = "Big-Bang/"
  source   = "/dev/null"
}

### Subcarpetas tomcat-errors
resource "aws_s3_bucket_object" "tomcat-errors_backoffice-people--sla3--eap--infra-8004" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/tomcat-errors/"
  acl      = "private"
  key      = "backoffice-people--sla3--eap--infra-8004/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "tomcat-errors_backoffice-people--sla3--ews--infra-8009" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/tomcat-errors/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8009/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "tomcat-errors_backoffice-people--sla3--ews--infra-8012" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/tomcat-errors/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8012/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "tomcat-errors_backoffice-people--sla3--ews--infra-8015" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/tomcat-errors/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8015/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "tomcat-errors_backoffice-people--sla3--ews--infra-8017" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/tomcat-errors/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8017/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "tomcat-errors_backoffice-people--sla3--ews--infra-8022" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/tomcat-errors/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8022/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "tomcat-errors_backoffice-people--sla3--ews--infra-8028" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/tomcat-errors/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8028/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "tomcat-errors_backoffice-people--sla3--ews--infra-8112" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/tomcat-errors/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8112/"
  source   = "/dev/null"
}

### Subcarpetas db-connections
resource "aws_s3_bucket_object" "db-connections_backoffice-people--sla3--eap--infra-8004" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/db-connections/"
  acl      = "private"
  key      = "backoffice-people--sla3--eap--infra-8004/"
  source   = "/dev/null"
}


resource "aws_s3_bucket_object" "db-connections_backoffice-people--sla3--ews--infra-8009" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/db-connections/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8009/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "db-connections_backoffice-people--sla3--ews--infra-8012" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/db-connections/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8012/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "db-connections_backoffice-people--sla3--ews--infra-8015" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/db-connections/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8015/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "db-connections_backoffice-people--sla3--ews--infra-8017" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/db-connections/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8017/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "db-connections_backoffice-people--sla3--ews--infra-8022" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/db-connections/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8022/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "db-connections_backoffice-people--sla3--ews--infra-8028" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/db-connections/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8028/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "db-connections_backoffice-people--sla3--ews--infra-8112" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/db-connections/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8112/"
  source   = "/dev/null"
}

### Subcarpetas Big-Bang
resource "aws_s3_bucket_object" "Big-Bang_backoffice-people--sla3--eap--infra-8004" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/Big-Bang/"
  acl      = "private"
  key      = "backoffice-people--sla3--eap--infra-8004/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "Big-Bang_backoffice-people--sla3--ews--infra-8009" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/Big-Bang/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8009/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "Big-Bang_backoffice-people--sla3--ews--infra-8012" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/Big-Bang/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8012/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "Big-Bang_backoffice-people--sla3--ews--infra-8015" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/Big-Bang/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8015/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "Big-Bang_backoffice-people--sla3--ews--infra-8017" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/Big-Bang/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8017/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "Big-Bang_backoffice-people--sla3--ews--infra-8022" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/Big-Bang/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8022/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "Big-Bang_backoffice-people--sla3--ews--infra-8028" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/Big-Bang/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8028/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "Big-Bang_backoffice-people--sla3--ews--infra-8112" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket_statistics.s3_bucket_id}/Big-Bang/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8112/"
  source   = "/dev/null"
}
