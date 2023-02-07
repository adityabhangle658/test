variable region {
  type        = string
  default     = ""
  description = ""
}

variable "prefix" {
  type        = string
  default     = ""
  description = "Prefix for all tagging"
}

variable vpc_cidr {
  type        = string
  default     = ""
  description = "VPC Cidr"
}

variable mgt_subnet_cidr {
  type        = list
  default     = []
  description = "Management Subnet CIDR"
}

variable web_subnet_cidr {
  type        = list
  default     = []
  description = "Web Subnet CIDR"
}

variable app_subnet_cidr {
  type        = list
  default     = []
  description = "APP Subnet CIDR"
}

variable db_subnet_cidr {
  type        = list
  default     = []
  description = "DB Subnet CIDR"
}