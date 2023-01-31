locals {
  bucket_name = "iberia-configs-files-apps-production-backoffice"

}

module "s3_bucket" {
  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-s3-bucket-module?ref=v2.11.1"
  providers = {
    aws = aws.prodbackoffice
  }
  bucket        = local.bucket_name
  acl           = "private"
  force_destroy = true

  tags = merge(var.tags,
    {
      "ib:resource:name" = local.bucket_name
    },
    {
      "Name" = local.bucket_name
    }
  )

  versioning = {
    enabled = true
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

  object_lock_configuration = {
    object_lock_enabled = "Enabled"
    rule = {
      default_retention = {
        mode = "GOVERNANCE"
        days = 1
      }
    }
  }

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # S3 Bucket Ownership Controls
  control_object_ownership = true
  #object_ownership         = "BucketOwnerPreferred"

}


resource "aws_s3_bucket_object" "Peoplesoft" {
  provider = aws.prodbackoffice
  bucket   = module.s3_bucket.s3_bucket_id
  acl      = "private"
  key      = "Peoplesoft/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "Datasource" {
  provider = aws.prodbackoffice
  bucket   = module.s3_bucket.s3_bucket_id
  acl      = "private"
  key      = "Datasource/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "Swm" {
  provider = aws.prodbackoffice
  bucket   = module.s3_bucket.s3_bucket_id
  acl      = "private"
  key      = "Swm/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "catalina" {
  provider = aws.prodbackoffice
  bucket   = module.s3_bucket.s3_bucket_id
  acl      = "private"
  key      = "Catalina/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "standalone" {
  provider = aws.prodbackoffice
  bucket   = module.s3_bucket.s3_bucket_id
  acl      = "private"
  key      = "Standalone/"
  source   = "/dev/null"
}

##Subcarpetas etc

resource "aws_s3_bucket_object" "etc_backoffice-people--sla3--ews--infra-8022" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Etc/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8022/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "etc_backoffice-people--sla3--ews--infra-8012" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Etc/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8012/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "etc_backoffice-people--sla3--ews--infra-8112" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Etc/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8112/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "etc_backoffice-people--sla3--ews--infra-8028" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Etc/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8028/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "etc_backoffice-people--sla3--ews--infra-8017" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Etc/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8017/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "etc_backoffice-people--sla3--eap--infra-8004" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Etc/"
  acl      = "private"
  key      = "backoffice-people--sla3--eap--infra-8004/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "backoffice-people--sla3--ews--infra-8022" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Datasource/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8022/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "backoffice-people--sla3--ews--infra-8012" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Datasource/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8012/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "backoffice-people--sla3--ews--infra-8112" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Datasource/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8112/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "backoffice-people--sla3--ews--infra-8028" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Datasource/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8028/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "backoffice-people--sla3--ews--infra-8017" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Datasource/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8017/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "backoffice-people--sla3--eap--infra-8004" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Datasource/"
  acl      = "private"
  key      = "backoffice-people--sla3--eap--infra-8004/"
  source   = "/dev/null"
}

## Subcarpetas Catalina

resource "aws_s3_bucket_object" "catalina-8022" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Catalina/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8022/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "catalina-8012" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Catalina/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8012/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "catalina-8112" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Catalina/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8112/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "catalina-8028" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Catalina/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8028/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "catalina-8017" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Catalina/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8017/"
  source   = "/dev/null"
}

## Subcarpetas Certificates

resource "aws_s3_bucket_object" "certificates-8022" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Certificates/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8022/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "certificates-8012" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Certificates/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8012/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "certificates-8112" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Certificates/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8112/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "certificates-8028" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Certificates/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8028/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "certificates-8017" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Certificates/"
  acl      = "private"
  key      = "backoffice-people--sla3--ews--infra-8017/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "certificates-policies-8017" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Certificates/backoffice-people--sla3--ews--infra-8017/"
  acl      = "private"
  key      = "policies/"
  source   = "/dev/null"
}



resource "aws_s3_bucket_object" "etc_8009" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Etc/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--infra-8009/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "datasource_8009" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Datasource/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--infra-8009/"
  source   = "/dev/null"
}


resource "aws_s3_bucket_object" "catalina_8009" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Catalina/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--infra-8009/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "conf_8009" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Conf/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--infra-8009/"
  source   = "/dev/null"
}

### Folders for cluster 8015
resource "aws_s3_bucket_object" "etc_8015" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Etc/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--infra-8015/"
  source   = "/dev/null"
}
resource "aws_s3_bucket_object" "datasource_8015" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Datasource/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--infra-8015/"
  source   = "/dev/null"
}
resource "aws_s3_bucket_object" "catalina_8015" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Catalina/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--infra-8015/"
  source   = "/dev/null"
}
resource "aws_s3_bucket_object" "conf_8015" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Conf/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--infra-8015/"
  source   = "/dev/null"
}

## Subcarpetas Standalone.conf

resource "aws_s3_bucket_object" "standalone_backoffice-people--sla3--eap--infra-8004" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Standalone/"
  acl      = "private"
  key      = "backoffice-people--sla3--eap--infra-8004/"
  source   = "/dev/null"
}




### Folders for cluster 8025

resource "aws_s3_bucket_object" "etc_8025" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Etc/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--8025--infra/"
  source   = "/dev/null"
}
resource "aws_s3_bucket_object" "datasource_8025" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Datasource/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--8025--infra/"
  source   = "/dev/null"
}
resource "aws_s3_bucket_object" "catalina_8025" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Catalina/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--8025--infra/"
  source   = "/dev/null"
}
resource "aws_s3_bucket_object" "conf_8025" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Conf/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--8025--infra/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "certificates-8025" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Certificates/"
  acl      = "private"
  key      = "backoffice-finance--sla3--ews--8025--infra/"
  source   = "/dev/null"
}

resource "aws_s3_bucket_object" "certificates-policies-8025" {
  provider = aws.prodbackoffice
  bucket   = "${module.s3_bucket.s3_bucket_id}/Certificates/backoffice-finance--sla3--ews--8025--infra/"
  acl      = "private"
  key      = "policies/"
  source   = "/dev/null"
}