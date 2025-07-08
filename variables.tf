# input variables passed into the child module when it is called  
variable "config" {
  description = "Values for the configuration of a static website"
  type = object({
    bucket_name    = string
    destroy_bucket = optional(bool, false)
    index_suffix   = optional(string, "index.html")
    error_key      = optional(string, "error.html")
    bucket_tags = optional(map(string), {
    })
  })
}
