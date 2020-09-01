data "aws_caller_identity" "current" {
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  tags       = module.tags.tags_no_name
}

module "tags" {
  source = "git::https://github.com/rhythmictech/terraform-terraform-tags.git?ref=v1.0.0"

  names = [
    "smiller",
    "imagebuilder-test"
  ]

  tags = merge({
    "Env"       = "test"
    "Namespace" = "smiller"
    "notes"     = "Testing only - Can be safely deleted"
    "Owner"     = var.owner
  }, var.additional_tags)
}

module "test_s3_component" {
  source = "git::https://github.com/mike-carey/imagebuilder-component-s3/aws"

  component_version = "1.0.0"
  description       = "Testing component"
  name              = "testing-component"

  buckets = [
    {
      source      = "s3://download-bucket/file.txt"
      destination = "/var/ami/file.txt"
    },
    {
      source      = "s3://download-bucket/dependencies/*"
      destination = "/var/ami/deps"
    },
    {
      source      = "/var/log/my-custom-script.log"
      destination = "s3://upload-bucket/logs/my-custom-script.log"
    },
  ]

  tags = local.tags
}

module "test_recipe" {
  source  = "rhythmictech/imagebuilder-recipe/aws"
  version = "~> 0.2.0"

  description    = "Testing recipe"
  name           = "test-recipe"
  parent_image   = "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-2-x86/x.x.x"
  recipe_version = "1.0.0"
  tags           = local.tags
  update         = true

  component_arns = [
    module.test_shell_component.component_arn,
    "arn:aws:imagebuilder:us-east-1:aws:component/simple-boot-test-linux/1.0.0/1",
    "arn:aws:imagebuilder:us-east-1:aws:component/reboot-test-linux/1.0.0/1"
  ]
}

module "test_pipeline" {
  source  = "rhythmictech/imagebuilder-pipeline/aws"
  version = "~> 0.3.0"

  description = "Testing pipeline"
  name        = "test-pipeline"
  tags        = local.tags
  recipe_arn  = module.test_recipe.recipe_arn
  public      = false
}
