variable "availability_zone" {
  type = string
}

variable "size" {
  type = number
}

variable "instance_id" {
  type = string
}

variable "volume_tag" {
  type = map(string)
}
