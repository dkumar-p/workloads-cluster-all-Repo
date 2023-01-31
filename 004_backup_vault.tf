locals {
  name_vault_irlanda   = format("%s-%s-%s", "ocpame2-vb", "account", "eu-west-1")
  name_vault_francfort = format("%s-%s-%s", "ocpame2-vb", "account", "eu-central-1")

  name_sns = format("%s-%s-%s", "ocpame2-sns", var.tags["ib:account:short_name"], "backup-vault-events")

}

## ROL IAM ASUME ROL------------------------------------------------------------
resource "aws_iam_role" "vault-backup" {
  provider           = aws.prodbackoffice
  count              = var.create_vault == true ? 1 : 0
  name               = "backup-rol-account"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "vault-backup" {
  provider   = aws.prodbackoffice
  count      = var.create_vault == true ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.vault-backup[0].name
}

## VAULT eu-west-1 -------------------------------------------------------------
resource "aws_backup_vault" "vault-backup" {
  provider = aws.prodbackoffice
  count    = var.create_vault == true ? 1 : 0
  #count    = "${var.tags["environment"] == "devops" ? 1:0}"
  name        = local.name_vault_irlanda
  kms_key_arn = aws_kms_key.kms-backup.arn
  tags = merge(var.tags, {
    Name = local.name_vault_irlanda
    }
  )
}

resource "aws_backup_vault_policy" "vault-backup" {
  provider          = aws.prodbackoffice
  count             = var.create_vault == true ? 1 : 0
  backup_vault_name = aws_backup_vault.vault-backup[0].name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement": [
    {
      "Sid": "default",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "backup:DescribeBackupVault",
        "backup:DeleteBackupVault",
        "backup:PutBackupVaultAccessPolicy",
        "backup:DeleteBackupVaultAccessPolicy",
        "backup:GetBackupVaultAccessPolicy",
        "backup:StartBackupJob",
        "backup:GetBackupVaultNotifications",
        "backup:PutBackupVaultNotifications"
      ],
      "Resource": "${aws_backup_vault.vault-backup[0].arn}"
    }
  ]
}
POLICY
}


## VAULT eu-central-1 -------------------------------------------------------------
resource "aws_backup_vault" "vault-backup-francfort" {
  provider    = aws.francfort
  count       = var.create_vault == true ? 1 : 0
  name        = local.name_vault_francfort
  kms_key_arn = aws_kms_key.kms-backup-francfort.arn
  tags = merge(var.tags, {
    Name = local.name_vault_francfort
    }
  )
}

resource "aws_backup_vault_policy" "vault-backup-francfort" {
  count             = var.create_vault == true ? 1 : 0
  provider          = aws.francfort
  backup_vault_name = aws_backup_vault.vault-backup-francfort[0].name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement": [
    {
      "Sid": "default",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "backup:DescribeBackupVault",
        "backup:DeleteBackupVault",
        "backup:PutBackupVaultAccessPolicy",
        "backup:DeleteBackupVaultAccessPolicy",
        "backup:GetBackupVaultAccessPolicy",
        "backup:StartBackupJob",
        "backup:GetBackupVaultNotifications",
        "backup:PutBackupVaultNotifications"
      ],
      "Resource": "${aws_backup_vault.vault-backup-francfort[0].arn}"
    }
  ]
}
POLICY
}

## SNS Y NOTIFICATIONS ---------------------------------------------------------
resource "aws_sns_topic" "vault-backup" {
  provider = aws.prodbackoffice
  count    = var.create_vault == true ? 1 : 0
  name     = local.name_sns
  tags = merge(var.tags, {
    Name = local.name_sns
    }
  )
}


data "aws_iam_policy_document" "vault-backup" {
  provider  = aws.prodbackoffice
  count     = var.create_vault == true ? 1 : 0
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Publish",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    resources = [
      "${aws_sns_topic.vault-backup[0].arn}"
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic_policy" "vault-backup" {
  provider = aws.prodbackoffice
  count    = var.create_vault == true ? 1 : 0
  arn      = aws_sns_topic.vault-backup[0].arn
  policy   = data.aws_iam_policy_document.vault-backup[0].json
}

resource "aws_backup_vault_notifications" "vault-backup" {
  provider            = aws.prodbackoffice
  count               = var.create_vault == true ? 1 : 0
  backup_vault_name   = aws_backup_vault.vault-backup[0].name
  sns_topic_arn       = aws_sns_topic.vault-backup[0].arn
  backup_vault_events = ["BACKUP_JOB_STARTED", "RESTORE_JOB_COMPLETED"]
}

/* ## PLAN Y SELECTION EC2---------------------------------------------------------
resource "aws_backup_plan" "ec2" {
  count = var.create_vault == true ? 1 : 0
  name  = format("%s-%s-%s", "ec2-plan", var.tags["ib:account:short_name"], "001")

  rule {
    rule_name         = format("%s-%s-%s", "ec2-rule", var.tags["ib:account:short_name"], "001")
    target_vault_name = aws_backup_vault.vault-backup[0].name
    schedule          = "cron(30 0 * * ? *)"
    start_window      = 120
    completion_window = 360
    recovery_point_tags = {
      "ib:resource:name"        = ""
      "group:component-grouping" = ""
      "ib:resurce:environment"  = ""
    }

    lifecycle {
      cold_storage_after = 0
      delete_after       = 30
    }

    copy_action {
      lifecycle {
        cold_storage_after = 0
        delete_after       = 30
      }
      destination_vault_arn = aws_backup_vault.vault-backup_francfort[0].arn

    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }

}

resource "aws_backup_selection" "ec2" {
  count        = var.create_vault == true ? 1 : 0
  iam_role_arn = aws_iam_role.vault-backup[0].arn
  name         = format("%s-%s-%s", "ec2-selection", var.tags["ib:account:short_name"], "001")
  plan_id      = aws_backup_plan.ec2[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "ib:resource:type:backup"
    value = "ec2"
  }
}


## PLAN Y SELECTION RDS---------------------------------------------------------
resource "aws_backup_plan" "rds" {
  count = var.create_vault == true ? 1 : 0
  name  = format("%s-%s-%s", "rds-plan", var.tags["ib:account:short_name"], "001")

  rule {
    rule_name         = format("%s-%s-%s", "rds-rule", var.tags["ib:account:short_name"], "001")
    target_vault_name = aws_backup_vault.vault-backup[0].name
    schedule          = "cron(30 0 * * ? *)"
    start_window      = 120
    completion_window = 360
    recovery_point_tags = {
      "ib:resource:name"        = ""
      "group:component-grouping" = ""
      "ib:resurce:environment"  = ""
    }

    lifecycle {
      cold_storage_after = 0
      delete_after       = 30
    }

    copy_action {
      lifecycle {
        cold_storage_after = 0
        delete_after       = 30
      }
      destination_vault_arn = aws_backup_vault.vault-backup_francfort[0].arn

    }
  }

}

resource "aws_backup_selection" "rds" {
  count        = var.create_vault == true ? 1 : 0
  iam_role_arn = aws_iam_role.vault-backup[0].arn
  name         = format("%s-%s-%s", "rds-selection", var.tags["ib:account:short_name"], "001")
  plan_id      = aws_backup_plan.rds[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "ib:resource:type:backup"
    value = "rds"
  }
}


## PLAN Y SELECTION EBS---------------------------------------------------------
resource "aws_backup_plan" "ebs" {
  count = var.create_vault == true ? 1 : 0
  name  = format("%s-%s-%s", "ebs-plan", var.tags["ib:account:short_name"], "001")

  rule {
    rule_name         = format("%s-%s-%s", "ebs-rule", var.tags["ib:account:short_name"], "001")
    target_vault_name = aws_backup_vault.vault-backup[0].name
    schedule          = "cron(30 0 * * ? *)"
    start_window      = 120
    completion_window = 360
    recovery_point_tags = {
      "ib:resource:name"        = ""
      "group:component-grouping" = ""
      "ib:resurce:environment"  = ""
    }

    lifecycle {
      cold_storage_after = 0
      delete_after       = 30
    }

    copy_action {
      lifecycle {
        cold_storage_after = 0
        delete_after       = 30
      }
      destination_vault_arn = aws_backup_vault.vault-backup_francfort[0].arn

    }
  }

}

resource "aws_backup_selection" "ebs" {
  count        = var.create_vault == true ? 1 : 0
  iam_role_arn = aws_iam_role.vault-backup[0].arn
  name         = format("%s-%s-%s", "ebs-selection", var.tags["ib:account:short_name"], "001")
  plan_id      = aws_backup_plan.ebs[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "ib:resource:type:backup"
    value = "ebs"
  }
}

## PLAN Y SELECTION EFS---------------------------------------------------------
resource "aws_backup_plan" "efs" {
  count = var.create_vault == true ? 1 : 0
  name  = format("%s-%s-%s", "efs-plan", var.tags["ib:account:short_name"], "001")

  rule {
    rule_name         = format("%s-%s-%s", "efs-rule", var.tags["ib:account:short_name"], "001")
    target_vault_name = aws_backup_vault.vault-backup[0].name
    schedule          = "cron(30 0 * * ? *)"
    start_window      = 120
    completion_window = 360
    recovery_point_tags = {
      "ib:resource:name"        = ""
      "group:component-grouping" = ""
      "ib:resurce:environment"  = ""
    }

    lifecycle {
      cold_storage_after = 0
      delete_after       = 30
    }

    copy_action {
      lifecycle {
        cold_storage_after = 0
        delete_after       = 30
      }
      destination_vault_arn = aws_backup_vault.vault-backup_francfort[0].arn

    }
  }

}

resource "aws_backup_selection" "efs" {
  count        = var.create_vault == true ? 1 : 0
  iam_role_arn = aws_iam_role.vault-backup[0].arn
  name         = format("%s-%s-%s", "efs-selection", var.tags["ib:account:short_name"], "001")
  plan_id      = aws_backup_plan.efs[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "ib:resource:type:backup"
    value = "efs"
  }
}

## PLAN Y SELECTION AURORA---------------------------------------------------------
resource "aws_backup_plan" "aurora" {
  count = var.create_vault == true ? 1 : 0
  name  = format("%s-%s-%s", "aurora-plan", var.tags["ib:account:short_name"], "001")

  rule {
    rule_name         = format("%s-%s-%s", "aurora-rule", var.tags["ib:account:short_name"], "001")
    target_vault_name = aws_backup_vault.vault-backup[0].name
    schedule          = "cron(30 0 * * ? *)"
    start_window      = 120
    completion_window = 360
    recovery_point_tags = {
      "ib:resource:name"        = ""
      "group:component-grouping" = ""
      "ib:resurce:environment"  = ""
    }

    lifecycle {
      cold_storage_after = 0
      delete_after       = 30
    }

    copy_action {
      lifecycle {
        cold_storage_after = 0
        delete_after       = 30
      }
      destination_vault_arn = aws_backup_vault.vault-backup_francfort[0].arn

    }
  }

}

resource "aws_backup_selection" "aurora" {
  count        = var.create_vault == true ? 1 : 0
  iam_role_arn = aws_iam_role.vault-backup[0].arn
  name         = format("%s-%s-%s", "aurora-selection", var.tags["ib:account:short_name"], "001")
  plan_id      = aws_backup_plan.aurora[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "ib:resource:type:backup"
    value = "aurora"
  }
}

## PLAN Y SELECTION DYNAMODB---------------------------------------------------------
resource "aws_backup_plan" "dynamodb" {
  count = var.create_vault == true ? 1 : 0
  name  = format("%s-%s-%s", "dynamodb-plan", var.tags["ib:account:short_name"], "001")

  rule {
    rule_name         = format("%s-%s-%s", "dynamodb-rule", var.tags["ib:account:short_name"], "001")
    target_vault_name = aws_backup_vault.vault-backup[0].name
    schedule          = "cron(30 0 * * ? *)"
    start_window      = 120
    completion_window = 360
    recovery_point_tags = {
      "ib:resource:name"        = ""
      "group:component-grouping" = ""
      "ib:resurce:environment"  = ""
    }

    lifecycle {
      cold_storage_after = 0
      delete_after       = 30
    }

    copy_action {
      lifecycle {
        cold_storage_after = 0
        delete_after       = 30
      }
      destination_vault_arn = aws_backup_vault.vault-backup_francfort[0].arn

    }
  }

}

resource "aws_backup_selection" "dynamodb" {
  count        = var.create_vault == true ? 1 : 0
  iam_role_arn = aws_iam_role.vault-backup[0].arn
  name         = format("%s-%s-%s", "dynamodb-selection", var.tags["ib:account:short_name"], "001")
  plan_id      = aws_backup_plan.dynamodb[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "ib:resource:type:backup"
    value = "dynamodb"
  }
}

## PLAN Y SELECTION FSX---------------------------------------------------------
resource "aws_backup_plan" "fsx" {
  count = var.create_vault == true ? 1 : 0
  name  = format("%s-%s-%s", "fsx-plan", var.tags["ib:account:short_name"], "001")

  rule {
    rule_name         = format("%s-%s-%s", "fsx-rule", var.tags["ib:account:short_name"], "001")
    target_vault_name = aws_backup_vault.vault-backup[0].name
    schedule          = "cron(30 0 * * ? *)"
    start_window      = 120
    completion_window = 360
    recovery_point_tags = {
      "ib:resource:name"        = ""
      "group:component-grouping" = ""
      "ib:resurce:environment"  = ""
    }

    lifecycle {
      cold_storage_after = 0
      delete_after       = 30
    }

    copy_action {
      lifecycle {
        cold_storage_after = 0
        delete_after       = 30
      }
      destination_vault_arn = aws_backup_vault.vault-backup_francfort[0].arn

    }
  }

}

resource "aws_backup_selection" "fsx" {
  count        = var.create_vault == true ? 1 : 0
  iam_role_arn = aws_iam_role.vault-backup[0].arn
  name         = format("%s-%s-%s", "fsx-selection", var.tags["ib:account:short_name"], "001")
  plan_id      = aws_backup_plan.fsx[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "ib:resource:type:backup"
    value = "fsx"
  }
}
 */
