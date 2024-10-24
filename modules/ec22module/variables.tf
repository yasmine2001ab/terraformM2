variable "instance_type" {
  type = string
}

variable "aws_common_tag" {
  type = map(string)
}

variable "aws_security" {
  type = string
}

variable "security_group_ids" {
   type        = list(string)
}

variable "key" {
  type = string
}

variable "size" {
  type = number
}
