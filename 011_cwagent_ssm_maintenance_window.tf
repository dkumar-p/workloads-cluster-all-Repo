### SSM Parameter Store files to configure cloudwatch agent metrics and logs

resource "aws_ssm_parameter" "CWagent_linux_amzn2_metrics" {
  provider = aws.prodbackoffice
  name     = "CloudWatch-Agent-metrics-Linux"
  type     = "String"
  value    = file("${path.module}/src/CWagent_linux_amzn2_metrics.json")
}

resource "aws_ssm_parameter" "CWagent_linux_amzn2_logs" {
  provider = aws.prodbackoffice
  name     = "CloudWatch-Agent-logs-Linux"
  type     = "String"
  value    = file("${path.module}/src/CWagent_linux_amzn2_logs.json")
}

resource "aws_ssm_parameter" "CWagent_windows_metrics" {
  provider = aws.prodbackoffice
  name     = "CloudWatch-Agent-metrics-Windows"
  type     = "String"
  value    = file("${path.module}/src/CWagent_windows_metrics.json")
}

resource "aws_ssm_parameter" "CWagent_windows_logs" {
  provider = aws.prodbackoffice
  name     = "CloudWatch-Agent-logs-Windows"
  type     = "String"
  value    = file("${path.module}/src/CWagent_windows_logs.json")
}

resource "aws_ssm_parameter" "CWagent_jboss_apps_logs_1" {
  provider = aws.prodbackoffice
  name     = "CloudWatch-Agent-logs-jboss-apps-1"
  type     = "String"
  value    = file("${path.module}/src/CWagent_linux_amzn2_logs_wl_app_1.json")
}

resource "aws_ssm_parameter" "CWagent_jboss_apps_logs_2" {
  provider = aws.prodbackoffice
  name     = "CloudWatch-Agent-logs-jboss-apps-2"
  type     = "String"
  value    = file("${path.module}/src/CWagent_linux_amzn2_logs_wl_app_2.json")
}

resource "aws_ssm_parameter" "CWagent_jboss_apps_logs_3" {
  provider = aws.prodbackoffice
  name     = "CloudWatch-Agent-logs-jboss-apps-3"
  type     = "String"
  value    = file("${path.module}/src/CWagent_linux_amzn2_logs_wl_app_3.json")
}

resource "aws_ssm_parameter" "CWagent_jboss_apps_logs_4" {
  provider = aws.prodbackoffice
  name     = "CloudWatch-Agent-logs-jboss-apps-4"
  type     = "String"
  value    = file("${path.module}/src/CWagent_linux_amzn2_logs_wl_app_4.json")
}

resource "aws_ssm_parameter" "CWagent_jboss_apps_logs_5" {
  provider = aws.prodbackoffice
  name     = "CloudWatch-Agent-logs-jboss-apps-5"
  type     = "String"
  value    = file("${path.module}/src/CWagent_linux_amzn2_logs_wl_app_5.json")
}

### SSM Documents to configure cloudwatch agent metrics and logs

resource "aws_ssm_document" "Ib-CloudWatch-ManageAgent-Generic-Metrics" {
  provider      = aws.prodbackoffice
  name          = "Ib-CloudWatch-ManageAgent-Generic-Metrics"
  document_type = "Command"

  content = file("src/CloudWatch_ManageAgent_ssm_document_generic_metrics.json")
}

resource "aws_ssm_document" "Ib-CloudWatch-ManageAgent-Generic-Logs" {
  provider      = aws.prodbackoffice
  name          = "Ib-CloudWatch-ManageAgent-Generic-Logs"
  document_type = "Command"

  content = file("src/CloudWatch_ManageAgent_ssm_document_generic_logs.json")
}

resource "aws_ssm_document" "Ib-CloudWatch-ManageAgent-no-proxy" {
  provider      = aws.prodbackoffice
  name          = "Ib-CloudWatch-ManageAgent-no-proxy"
  document_type = "Command"

  content = file("src/CloudWatch_ManageAgent_ssm_document_no_proxy.json")
}

### SSM Maintenance Window to install and configure cloudwatch agent

resource "aws_ssm_maintenance_window" "cwagent_install_and_config" {
  provider = aws.prodbackoffice
  name     = "CloudWatch-Agent-Install-and-Configure-TF"
  schedule = "cron(0 00 07 ? * * *)"
  duration = 3
  cutoff   = 1
}

resource "aws_ssm_maintenance_window_target" "cwagent_generic_config" {
  provider      = aws.prodbackoffice
  window_id     = aws_ssm_maintenance_window.cwagent_install_and_config.id
  name          = "CloudWatch-Agent-Install-and-Configure-target"
  description   = "This is a maintenance window target"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:ib:resource:monitoring"
    values = ["true"]
  }
}

resource "aws_ssm_maintenance_window_target" "cwagent_jboss_apps_config" {
  provider      = aws.prodbackoffice
  window_id     = aws_ssm_maintenance_window.cwagent_install_and_config.id
  name          = "CloudWatch-Agent-Configure-JBoss-apps-target"
  description   = "This is a maintenance window target"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:ib:resource:monitoring"
    values = ["true"]
  }
  targets {
    key    = "tag:ib:resource:apptype"
    values = ["ews", "eap"]
  }
}

### TASK 1 in Maintenance Window to Install AmazonCloudWatchAgent package in both Windows and Linux

resource "aws_ssm_maintenance_window_task" "cloudWatch_agent_install" {
  provider        = aws.prodbackoffice
  name            = "CloudWatch-Agent-Install"
  max_concurrency = 10
  max_errors      = 3
  priority        = 1
  task_arn        = "AWS-ConfigureAWSPackage"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.cwagent_install_and_config.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.cwagent_generic_config.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      cloudwatch_config {
        cloudwatch_log_group_name = "aws-systemsmanager/maintenance-cloudwatch-agent"
        cloudwatch_output_enabled = true
      }
      document_version = "$DEFAULT"
      timeout_seconds  = 600
      parameter {
        name   = "action"
        values = ["Install"]
      }
      parameter {
        name   = "installationType"
        values = ["Uninstall and reinstall"]
      }
      parameter {
        name   = "name"
        values = ["AmazonCloudWatchAgent"]
      }
    }
  }
}

### TASK 2 in Maintenance Window to Configure AmazonCloudWatchAgent package with no proxy for Windows and Linux

resource "aws_ssm_maintenance_window_task" "cloudWatch_agent_no_proxy" {
  provider        = aws.prodbackoffice
  name            = "CloudWatch-Agent-no-proxy"
  max_concurrency = 10
  max_errors      = 3
  priority        = 2
  task_arn        = "Ib-CloudWatch-ManageAgent-no-proxy"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.cwagent_install_and_config.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.cwagent_generic_config.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      cloudwatch_config {
        cloudwatch_log_group_name = "aws-systemsmanager/maintenance-cloudwatch-agent"
        cloudwatch_output_enabled = true
      }
      document_version = "$DEFAULT"
      timeout_seconds  = 600
    }
  }
}

### TASK 3 in Maintenance Window to Configure AmazonCloudWatchAgent Metrics in both Windows and Linux

resource "aws_ssm_maintenance_window_task" "cloudWatch_agent_configure_generic_metrics" {
  provider        = aws.prodbackoffice
  name            = "CloudWatch-Agent-Configure-generic-metrics"
  max_concurrency = 10
  max_errors      = 3
  priority        = 3
  task_arn        = "Ib-CloudWatch-ManageAgent-Generic-Metrics"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.cwagent_install_and_config.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.cwagent_generic_config.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      cloudwatch_config {
        cloudwatch_log_group_name = "aws-systemsmanager/maintenance-cloudwatch-agent"
        cloudwatch_output_enabled = true
      }
      document_version = "$DEFAULT"
      timeout_seconds  = 600
      parameter {
        name   = "action"
        values = ["configure"]
      }
      parameter {
        name   = "mode"
        values = ["ec2"]
      }
      parameter {
        name   = "optionalConfigurationSource"
        values = ["ssm"]
      }
      parameter {
        name   = "optionalConfigurationLocation"
        values = ["CloudWatch-Agent-metrics"]
      }
      parameter {
        name   = "optionalRestart"
        values = ["yes"]
      }
    }
  }
}

### TASK 4 in Maintenance Window to Configure AmazonCloudWatchAgent Logs in both Windows and Linux

resource "aws_ssm_maintenance_window_task" "cloudWatch_agent_configure_generic_logs" {
  provider        = aws.prodbackoffice
  name            = "CloudWatch-Agent-Configure-generic-logs"
  max_concurrency = 10
  max_errors      = 3
  priority        = 4
  task_arn        = "Ib-CloudWatch-ManageAgent-Generic-Logs"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.cwagent_install_and_config.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.cwagent_generic_config.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      cloudwatch_config {
        cloudwatch_log_group_name = "aws-systemsmanager/maintenance-cloudwatch-agent"
        cloudwatch_output_enabled = true
      }
      timeout_seconds = 600
      parameter {
        name   = "action"
        values = ["configure (append)"]
      }
      parameter {
        name   = "mode"
        values = ["ec2"]
      }
      parameter {
        name   = "optionalConfigurationSource"
        values = ["ssm"]
      }
      parameter {
        name   = "optionalConfigurationLocation"
        values = ["CloudWatch-Agent-logs"]
      }
      parameter {
        name   = "optionalRestart"
        values = ["yes"]
      }
    }
  }
}

### TASK 5 in Maintenance Window to Configure AmazonCloudWatchAgent App Logs in Linux JBoss applications

resource "aws_ssm_maintenance_window_task" "cloudWatch_agent_configure_logs_jboss_app_1" {
  provider        = aws.prodbackoffice
  name            = "CloudWatch-Agent-Configure-generic-logs"
  max_concurrency = 10
  max_errors      = 3
  priority        = 5
  task_arn        = "AmazonCloudWatch-ManageAgent"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.cwagent_install_and_config.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.cwagent_jboss_apps_config.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      cloudwatch_config {
        cloudwatch_log_group_name = "aws-systemsmanager/maintenance-cloudwatch-agent"
        cloudwatch_output_enabled = true
      }
      timeout_seconds = 600
      parameter {
        name   = "action"
        values = ["configure (append)"]
      }
      parameter {
        name   = "mode"
        values = ["ec2"]
      }
      parameter {
        name   = "optionalConfigurationSource"
        values = ["ssm"]
      }
      parameter {
        name   = "optionalConfigurationLocation"
        values = ["CloudWatch-Agent-logs-jboss-apps-1"]
      }
      parameter {
        name   = "optionalRestart"
        values = ["yes"]
      }
    }
  }
}

### TASK 6 in Maintenance Window to Configure AmazonCloudWatchAgent App Logs in Linux JBoss applications

resource "aws_ssm_maintenance_window_task" "cloudWatch_agent_configure_logs_jboss_app_2" {
  provider        = aws.prodbackoffice
  name            = "CloudWatch-Agent-Configure-generic-logs"
  max_concurrency = 10
  max_errors      = 3
  priority        = 6
  task_arn        = "AmazonCloudWatch-ManageAgent"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.cwagent_install_and_config.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.cwagent_jboss_apps_config.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      cloudwatch_config {
        cloudwatch_log_group_name = "aws-systemsmanager/maintenance-cloudwatch-agent"
        cloudwatch_output_enabled = true
      }
      timeout_seconds = 600
      parameter {
        name   = "action"
        values = ["configure (append)"]
      }
      parameter {
        name   = "mode"
        values = ["ec2"]
      }
      parameter {
        name   = "optionalConfigurationSource"
        values = ["ssm"]
      }
      parameter {
        name   = "optionalConfigurationLocation"
        values = ["CloudWatch-Agent-logs-jboss-apps-2"]
      }
      parameter {
        name   = "optionalRestart"
        values = ["yes"]
      }
    }
  }
}

### TASK 7 in Maintenance Window to Configure AmazonCloudWatchAgent App Logs in Linux JBoss applications

resource "aws_ssm_maintenance_window_task" "cloudWatch_agent_configure_logs_jboss_app_3" {
  provider        = aws.prodbackoffice
  name            = "CloudWatch-Agent-Configure-generic-logs"
  max_concurrency = 10
  max_errors      = 3
  priority        = 6
  task_arn        = "AmazonCloudWatch-ManageAgent"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.cwagent_install_and_config.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.cwagent_jboss_apps_config.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      cloudwatch_config {
        cloudwatch_log_group_name = "aws-systemsmanager/maintenance-cloudwatch-agent"
        cloudwatch_output_enabled = true
      }
      timeout_seconds = 600
      parameter {
        name   = "action"
        values = ["configure (append)"]
      }
      parameter {
        name   = "mode"
        values = ["ec2"]
      }
      parameter {
        name   = "optionalConfigurationSource"
        values = ["ssm"]
      }
      parameter {
        name   = "optionalConfigurationLocation"
        values = ["CloudWatch-Agent-logs-jboss-apps-3"]
      }
      parameter {
        name   = "optionalRestart"
        values = ["yes"]
      }
    }
  }
}

### TASK 7 in Maintenance Window to Configure AmazonCloudWatchAgent App Logs in Linux JBoss applications

resource "aws_ssm_maintenance_window_task" "cloudWatch_agent_configure_logs_jboss_app_4" {
  provider        = aws.prodbackoffice
  name            = "CloudWatch-Agent-Configure-generic-logs"
  max_concurrency = 10
  max_errors      = 3
  priority        = 6
  task_arn        = "AmazonCloudWatch-ManageAgent"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.cwagent_install_and_config.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.cwagent_jboss_apps_config.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      cloudwatch_config {
        cloudwatch_log_group_name = "aws-systemsmanager/maintenance-cloudwatch-agent"
        cloudwatch_output_enabled = true
      }
      timeout_seconds = 600
      parameter {
        name   = "action"
        values = ["configure (append)"]
      }
      parameter {
        name   = "mode"
        values = ["ec2"]
      }
      parameter {
        name   = "optionalConfigurationSource"
        values = ["ssm"]
      }
      parameter {
        name   = "optionalConfigurationLocation"
        values = ["CloudWatch-Agent-logs-jboss-apps-4"]
      }
      parameter {
        name   = "optionalRestart"
        values = ["yes"]
      }
    }
  }
}

### TASK 8 in Maintenance Window to Configure AmazonCloudWatchAgent App Logs in Linux JBoss applications

resource "aws_ssm_maintenance_window_task" "cloudWatch_agent_configure_logs_jboss_app_5" {
  provider        = aws.prodbackoffice
  name            = "CloudWatch-Agent-Configure-generic-logs"
  max_concurrency = 10
  max_errors      = 3
  priority        = 6
  task_arn        = "AmazonCloudWatch-ManageAgent"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.cwagent_install_and_config.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.cwagent_jboss_apps_config.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      cloudwatch_config {
        cloudwatch_log_group_name = "aws-systemsmanager/maintenance-cloudwatch-agent"
        cloudwatch_output_enabled = true
      }
      timeout_seconds = 600
      parameter {
        name   = "action"
        values = ["configure (append)"]
      }
      parameter {
        name   = "mode"
        values = ["ec2"]
      }
      parameter {
        name   = "optionalConfigurationSource"
        values = ["ssm"]
      }
      parameter {
        name   = "optionalConfigurationLocation"
        values = ["CloudWatch-Agent-logs-jboss-apps-5"]
      }
      parameter {
        name   = "optionalRestart"
        values = ["yes"]
      }
    }
  }
}
