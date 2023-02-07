variable "region" {
    default = "ap-south-1"
    type = string
}

variable "multi_az" {
  type        = bool
  default     = true
}

variable identifier {
  type        = string
  default     = ""
}

variable instance_class {
  type        = string
  default     = ""
}

variable allocated_storage {
  type        = number
}

variable engine {
  type        = string
  default     = ""
}

variable engine_version {
  type        = string
  default     = ""
}

variable username {
  type        = string
  default     = ""
}

variable vpc_security_group_ids {
  type        = list
  default     = []
}

variable publicly_accessible {
  type        = bool
  default     = false
}

variable skip_final_snapshot {
  type        = bool
  default     = true
}

variable parameter_group_family {
  type        = string
  default     = ""
}

variable subnet_ids {
  type        = list
  default     = []
}
