# terraform-aws-mcaf-ipam

Terraform module to manage AWS VPC IPAM.

## Usage

```
module "ipam" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-ipam?ref=VERSION"

  aws_ipam_pool = ["10.64.0.0/12", "10.80.0.0/16"]

  pools = {
    sandbox = {
      cidr = ["10.64.0.0/16", "10.65.0.0/16"]
      shared_principal = ["arn:aws:organizations::123456789123:ou/o-a1a1a1a1a1/ou-1a1a-1a1a1a1a"]
    }
  }
}
```

**NOTE**: Review the documentation for the permissions needed to integrate with [AWS Organizations](https://docs.aws.amazon.com/vpc/latest/ipam/choose-single-user-or-orgs-ipam.html): The following Terraform resources need to be deployed prior to deploying this module in the AWS Organizations admin account:

```
resource "aws_ram_sharing_with_organization" "default" {}

resource "aws_vpc_ipam_organization_admin_account" "default" {
  delegated_admin_account_id = "123456789123"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_vpc_ipam.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam) | resource |
| [aws_vpc_ipam_pool.aws_pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool) | resource |
| [aws_vpc_ipam_pool.environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool) | resource |
| [aws_vpc_ipam_pool_cidr.aws_pool_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr) | resource |
| [aws_vpc_ipam_pool_cidr.environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr) | resource |
| [aws_region.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_ipam_pool"></a> [aws\_ipam\_pool](#input\_aws\_ipam\_pool) | The top level CIDR(s) available for usage on AWS | `list(string)` | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | n/a | <pre>map(object({<br/>    cidr             = list(string)<br/>    shared_principal = optional(list(string))<br/>    tags             = optional(map(string))<br/>  }))</pre> | n/a | yes |
| <a name="input_ipam_description"></a> [ipam\_description](#input\_ipam\_description) | A description for the IPAM | `string` | `"Organization IPAM"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region where resources will be created; if omitted the default provider region is used | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to set on Terraform created resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ipam_pool_id"></a> [ipam\_pool\_id](#output\_ipam\_pool\_id) | The ID of the AWS IPAM pool |
| <a name="output_ipam_sub_pools_ids"></a> [ipam\_sub\_pools\_ids](#output\_ipam\_sub\_pools\_ids) | The IDs of the sub pools of the AWS IPAM pool |
<!-- END_TF_DOCS -->

## Licensing

100% Open Source and licensed under the Apache License Version 2.0. See [LICENSE](https://github.com/schubergphilis/terraform-aws-mcaf-ipam/blob/main/LICENSE) for full details.
