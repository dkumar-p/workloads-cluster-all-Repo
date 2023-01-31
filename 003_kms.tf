
## KMS-S3---------------------------------------------
resource "aws_kms_key" "kms-s3" {
  provider    = aws.prodbackoffice
  description = "S3 KMS to account"
  tags        = var.tags
}

resource "aws_kms_alias" "kms-s3" {
  provider      = aws.prodbackoffice
  name          = "alias/infra-kms-s3"
  target_key_id = aws_kms_key.kms-s3.key_id
}

## KMS-EBS---------------------------------------------
resource "aws_kms_key" "kms-ebs" {
  provider    = aws.prodbackoffice
  description = "Ebs KMS to account"
  tags        = var.tags
}

resource "aws_kms_alias" "kms-ebs" {
  provider      = aws.prodbackoffice
  name          = "alias/infra-kms-ebs"
  target_key_id = aws_kms_key.kms-ebs.key_id
}

## KMS-EFS---------------------------------------------
resource "aws_kms_key" "kms-efs" {
  provider    = aws.prodbackoffice
  description = "Efs KMS to account"
  tags        = var.tags
}

resource "aws_kms_alias" "kms-efs" {
  provider      = aws.prodbackoffice
  name          = "alias/infra-kms-efs"
  target_key_id = aws_kms_key.kms-efs.key_id
}

## KMS-FSX---------------------------------------------
resource "aws_kms_key" "kms-fsx" {
  provider    = aws.prodbackoffice
  description = "Fsx KMS to account"
  tags        = var.tags
}

resource "aws_kms_alias" "kms-fsx" {
  provider      = aws.prodbackoffice
  name          = "alias/infra-kms-fsx"
  target_key_id = aws_kms_key.kms-fsx.key_id
}


## KMS-backup---------------------------------------------
resource "aws_kms_key" "kms-backup" {
  provider    = aws.prodbackoffice
  description = "Backup KMS to account"
  tags        = var.tags
}

resource "aws_kms_alias" "kms-backup" {
  provider      = aws.prodbackoffice
  name          = "alias/infra-kms-backup"
  target_key_id = aws_kms_key.kms-backup.key_id
}


## KMS-backup francfort---------------------------------------------
resource "aws_kms_key" "kms-backup-francfort" {
  provider    = aws.francfort
  description = "Backup KMS to account"
  tags        = var.tags
}

resource "aws_kms_alias" "kms-backup-francfort" {
  provider      = aws.francfort
  name          = "alias/infra-kms-backup"
  target_key_id = aws_kms_key.kms-backup-francfort.key_id
}
