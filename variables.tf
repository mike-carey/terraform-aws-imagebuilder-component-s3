variable "change_description" {
  default     = null
  description = "description of changes since last version"
  type        = string
}

variable "cloudformation_timeout" {
  default     = 10
  description = "How long to wait (in minutes) for CFN to apply before giving up"
  type        = number
}

variable "buckets" {
  description = "The buckets to download files from. If the source is an s3 url, the bucket will be considered a download; otherwise, an upload"
  type = list(object({
    source      = string
    destination = string
  }))

  # validation {
  #   condition     = length(var.buckets) > 0
  #   error_message = "The buckets variable cannot be empty."
  # }
}

variable "create_directories" {
  description = "If true, an ExecuteBash step will be added before the uploads/downloads"
  default     = true
}

variable "max_attempts" {
  description = "The maximum number of attempts to fetch"
  default     = 3
}

variable "component_version" {
  description = "Version of the component"
  type        = string
}

variable "data_uri" {
  default     = null
  description = "Use this to override the component document with one at a particular URL endpoint"
  type        = string
}

variable "description" {
  default     = null
  description = "description of component"
  type        = string
}

variable "kms_key_id" {
  default     = null
  description = "KMS key to use for encryption"
  type        = string
}

variable "name" {
  description = "name to use for component"
  type        = string
}

variable "platform" {
  default     = "Linux"
  description = "platform of component (Linux or Windows)"
  type        = string

  # validation {
  #   condition     = contains(["Linux", "Windows"], var.platform)
  #   error_message = "The platform variable must be one of: [Linux, Windows]."
  # }
}

variable "tags" {
  default     = {}
  description = "map of tags to use for CFN stack and component"
  type        = map(string)
}
