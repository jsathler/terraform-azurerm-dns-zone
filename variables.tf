variable "resource_group_name" {
  description = "The name of the resource group in which the VGW will be created. This parameter is required"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources."
  type        = map(string)
  default     = null
}

variable "zones" {
  description = <<DESCRIPTION
  A MAP of dns zones to be created. The key is the zone name and the value are the properties
  - private:                (optional) If true, the zone will be created as "private zone" otherwise it will be created as "public zone". Defaults to 'false'
  - link_only:              (optional) If true, only the vnet link will be created. In this case the private zone should already exist. Defaults to 'false'
  - vnets:                  (optional) A block as defined bellow (MAP of vnets)
    - id:                   (required) The ID of the Virtual Network that should be linked to the DNS Zone
    - registration_enabled: (Optional) Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? Defaults to 'false'
  - soa:                    (optional) A block as defined bellow
    - email:                (Required) The email contact for the SOA record. Defaults to 'null'
    - expire_time:          (optional) The expire time for the SOA record. Defaults to 'null'
    - minimum_ttl:          (optional) The minimum Time To Live for the SOA record. By convention, it is used to determine the negative caching duration. Defaults to 'null'
    - refresh_time:         (optional) The refresh time for the SOA record. Defaults to 'null'
    - retry_time:           (optional) The retry time for the SOA record. Defaults to 'null'
    - serial_number:        (optional) The serial number for the SOA record. Defaults to 'null'
    - ttl:                  (optional) The Time To Live of the SOA Record in seconds. Defaults to 'null'
  DESCRIPTION
  type = map(object({
    private   = optional(bool, false)
    link_only = optional(bool, false)
    vnets = optional(map(object({
      id                   = string
      registration_enabled = optional(bool, false)
    })))
    soa = optional(object({
      email         = optional(string, null)
      expire_time   = optional(string, null)
      minimum_ttl   = optional(string, null)
      refresh_time  = optional(string, null)
      retry_time    = optional(string, null)
      serial_number = optional(string, null)
      ttl           = optional(string, null)
    }), null)
  }))
}
