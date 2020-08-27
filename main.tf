locals {
  download_buckets = [for b in var.buckets : b if length(regexall("^s3://", b.source)) > 0]
  upload_buckets   = [for b in var.buckets : b if length(regexall("^s3://", b.source)) == 0]
  directories      = [for d in local.download_buckets.*.destination : d if length(regexall(".*\\.\\w+$", d)) == 0]

  data = templatefile("${path.module}/component.yml.tpl", {
    description        = var.description
    name               = var.name
    max_attempts       = var.max_attempts
    download_buckets   = local.download_buckets
    upload_buckets     = local.upload_buckets
    create_directories = var.create_directories
    directories        = local.directories
  })
}

resource "aws_cloudformation_stack" "this" {
  name               = "${var.name}-${uuid()}"
  on_failure         = "ROLLBACK"
  timeout_in_minutes = var.cloudformation_timeout

  tags = merge(
    var.tags,
    { Name : "${var.name}-stack" }
  )

  template_body = templatefile("${path.module}/cloudformation.yml.tpl", {
    change_description = var.change_description
    data               = var.data_uri == null ? local.data : null
    description        = var.description
    kms_key_id         = var.kms_key_id
    name               = var.name
    platform           = var.platform
    uri                = var.data_uri
    version            = var.component_version

    tags = merge(
      var.tags,
      { Name : var.name }
    )
  })

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      name
    ]
  }
}
