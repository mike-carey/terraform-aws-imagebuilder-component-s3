# terraform-aws-imagebuilder-component-shell
Terraform module that creates EC2 Image Builder components with CloudFormation

## Example
```hcl
module "test_shell_component" {
  source  = "github.com/mike-carey/terraform-aws-imagebuilder-component-s3"
  version = "~> 0.1.0"

  component_version = "1.0.0"
  description       = "Testing component"
  name              = "testing-component"
  tags              = local.tags

  buckets = [
    {
      source = "s3://download-bucket/file.txt"
      destination = "/var/ami/file.txt"
    },
    {
      source = "s3://download-bucket/dependencies/*"
      destination = "/var/ami/deps"
    },
    {
      source = "/var/log/my-custom-script.log"
      destination = "s3://upload-bucket/logs/my-custom-script.log"
    },
  ]
}
```

## About
This module bridges the gap allowing Terraform to create EC2 Image Builder components (especially with S3) until native support is added to Terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.20 |
| aws | ~> 2.44 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.44 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| buckets | List of buckets with source and destination | `list(map(string))` | n/a | yes |
| component\_version | Version of the component | `string` | n/a | yes |
| name | name to use for component | `string` | n/a | yes |
| change\_description | description of changes since last version | `string` | `null` | no |
| cloudformation\_timeout | How long to wait (in minutes) for CFN to apply before giving up | `number` | `10` | no |
| data\_uri | Use this to override the component document with one at a particular URL endpoint | `string` | `null` | no |
| description | description of component | `string` | `null` | no |
| kms\_key\_id | KMS key to use for encryption | `string` | `null` | no |
| platform | platform of component (Linux or Windows) | `string` | `"Linux"` | no |
| tags | map of tags to use for CFN stack and component | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| component\_arn | ARN of the EC2 Image Builder Component |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## The Giants underneath this module
- pre-commit.com/
- terraform.io/
- github.com/tfutils/tfenv
- github.com/segmentio/terraform-docs
