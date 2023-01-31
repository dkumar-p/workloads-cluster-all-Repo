# backoffice-people--sla3--ews--infra-8028
 
## DESIGN
 
![Scenarios](../images/design/Diagrama_backoffice_pro.png)
 
## AMIS
everything related to the AMIS and their configuration is in the AMIS.md file
 
- [AMIS](./AMIS.md)
 

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.74.0 |
| <a name="provider_aws.monitoring"></a> [aws.monitoring](#provider\_aws.monitoring) | 3.74.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="create_alarms_alb_rds"></a> [create\_alarms\_alb\_rds](#module\_create\_alarms\_alb\_rds) | git@github.com:Iberia-Ent/software-engineering--monitoring--infra.git//modules/create_alarms_alb_rds | n/a |
| <a name="module_lb-alb"></a> [lb-alb](#module\_lb-alb) | git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-alb-module | v6.6.1 |
| <a name="module_lb-nlb"></a> [lb-nlb](#module\_lb-nlb) | git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-alb-module | v6.6.1 |
| <a name="module_lb_netwrking"></a> [lb\_netwrking](#module\_lb\_netwrking) | git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-alb-module | v6.6.1 |
| <a name="module_security_group_ec2"></a> [security\_group\_ec2](#module\_security\_group\_ec2) | git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-security-group-module | v4.7.0 |
| <a name="module_vpc-Cluster"></a> [vpc-Cluster](#module\_vpc-Cluster) | git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-vpc-module.git | v3.11.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_notification.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_notification) | resource |
| [aws_autoscaling_policy.checkpoint-cpu-policy-down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_policy.checkpoint-cpu-policy-up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_cloudwatch_metric_alarm.checkpoint-cpu-alarm-down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.checkpoint-cpu-alarm-up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_codedeploy_app.PLE005](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_config.PLE005](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_config) | resource |
| [aws_codedeploy_deployment_group.PLE005](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.vpc-Cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_launch_template.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_route.route-subnet-0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_resolver_rule_association.workload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_route53_zone_association.workload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association) | resource |
| [aws_security_group_rule.icmp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.port_389](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.port_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.port_8080](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.port_8443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.port_9990](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_sns_topic.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.email-target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_vpc_endpoint.vpce-s3-transit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_iam_policy_document.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_resolver_rules.workload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_resolver_rules) | data source |
| [terraform_remote_state.globalsharedservices](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.workloads-prod-backoffice](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_number"></a> [account\_number](#input\_account\_number) | Account number | `string` | n/a | yes |
| <a name="input_ami_master"></a> [ami\_master](#input\_ami\_master) | Id AMI of the master instance jboss | `string` | `""` | no |
| <a name="input_dashboard_name_cw"></a> [dashboard\_name\_cw](#input\_dashboard\_name\_cw) | Name of Dashboard in Cloudwatch | `string` | `""` | no |
| <a name="input_flow_log_cloudwatch_log_group_retention_in_days"></a> [flow\_log\_cloudwatch\_log\_group\_retention\_in\_days](#input\_flow\_log\_cloudwatch\_log\_group\_retention\_in\_days) | Flow vpc Retention Days | `number` | `14` | no |
| <a name="input_flow_log_file_format"></a> [flow\_log\_file\_format](#input\_flow\_log\_file\_format) | Flow vpc file format | `string` | `"parquet"` | no |
| <a name="input_flow_log_log_format"></a> [flow\_log\_log\_format](#input\_flow\_log\_log\_format) | Flow vpc log format | `string` | `"${version} ${account-id} ${vpc-id} ${subnet-id} ${instance-id} ${interface-id} ${srcaddr} ${srcport} ${dstaddr} ${dstport} ${protocol} ${tcp-flags} ${type} ${pkt-srcaddr} ${pkt-src-aws-service} ${pkt-dstaddr} ${pkt-dst-aws-service} ${action} ${log-status}"` | no |
| <a name="input_flow_log_max_aggregation_interval"></a> [flow\_log\_max\_aggregation\_interval](#input\_flow\_log\_max\_aggregation\_interval) | Flow vpc aggregation\_interval | `number` | `60` | no |
| <a name="input_gcc_tgw_id"></a> [gcc\_tgw\_id](#input\_gcc\_tgw\_id) | TGW GCC | `string` | `"tgw-0858e4d5e466d734d"` | no |
| <a name="input_globalsharedservices_profile"></a> [globalsharedservices\_profile](#input\_globalsharedservices\_profile) | SSO profile for this account | `string` | n/a | yes |
| <a name="input_iberia_tgw_id"></a> [iberia\_tgw\_id](#input\_iberia\_tgw\_id) | TGW Iberia | `string` | `"tgw-0db3fdc0f9da71974"` | no |
| <a name="input_main_profile"></a> [main\_profile](#input\_main\_profile) | SSO profile for this account | `string` | n/a | yes |
| <a name="input_monitoring_profile"></a> [monitoring\_profile](#input\_monitoring\_profile) | SSO profile for this account | `string` | n/a | yes |
| <a name="input_name_vpc_cluster"></a> [name\_vpc\_cluster](#input\_name\_vpc\_cluster) | Vpc name for account | `string` | `""` | no |
| <a name="input_networking_profile"></a> [networking\_profile](#input\_networking\_profile) | SSO profile for this account | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(any)` | n/a | yes |
| <a name="input_vpc_azs"></a> [vpc\_azs](#input\_vpc\_azs) | List AZS for Subnets | `list(string)` | <pre>[<br>  "eu-west-1a",<br>  "eu-west-1b"<br>]</pre> | no |
| <a name="input_vpc_cidr_cluster"></a> [vpc\_cidr\_cluster](#input\_vpc\_cidr\_cluster) | Vpc CIDR for Account | `string` | `""` | no |
| <a name="input_vpc_private_subnets_cluster"></a> [vpc\_private\_subnets\_cluster](#input\_vpc\_private\_subnets\_cluster) | List private subnets for Account | `list(string)` | `[]` | no |
| <a name="input_vpc_public_subnets_cluster"></a> [vpc\_public\_subnets\_cluster](#input\_vpc\_public\_subnets\_cluster) | List public subnets for Account | `list(string)` | `[]` | no |
| <a name="input_vpc_secundary_cidr_cluster"></a> [vpc\_secundary\_cidr\_cluster](#input\_vpc\_secundary\_cidr\_cluster) | Vpc sencundary CIDR for Account | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ID ALB |
| <a name="output_alb_id"></a> [alb\_id](#output\_alb\_id) | ID ALB |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | ID ALB |
| <a name="output_all_vpc_ids"></a> [all\_vpc\_ids](#output\_all\_vpc\_ids) | List of all vpc´s in this account |
| <a name="output_nlb_arn"></a> [nlb\_arn](#output\_nlb\_arn) | ID NLB |
| <a name="output_nlb_id"></a> [nlb\_id](#output\_nlb\_id) | ID NLB |
| <a name="output_nlb_networking_arn"></a> [nlb\_networking\_arn](#output\_nlb\_networking\_arn) | ID NLB |
| <a name="output_nlb_networking_id"></a> [nlb\_networking\_id](#output\_nlb\_networking\_id) | ID NLB |
| <a name="output_nlb_nteworking_zone_id"></a> [nlb\_nteworking\_zone\_id](#output\_nlb\_nteworking\_zone\_id) | ID NLB |
| <a name="output_nlb_zone_id"></a> [nlb\_zone\_id](#output\_nlb\_zone\_id) | ID NLB |
| <a name="output_private_route_tables"></a> [private\_route\_tables](#output\_private\_route\_tables) | List private route tables of private subnets |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List private subnets of vpc |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | vpc id of vpc |
<!-- END_TF_DOCS -->
