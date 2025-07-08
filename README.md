# S3 Static Website Module

This Terraform module sets up an Amazon S3 bucket configured to host a static website. It automatically uploads `index.html` and `error.html` files and applies a public bucket policy to make the content accessible. The module also configures the website for the bucket and outputs key information including the bucket's ARN, name, and website URL.

## Usage

To invoke this module, pass a `config` object with the following structure in your root module:

```hcl
module "website-s3-bucket" {
  source = "app.terraform.io/<organization name>/s3-static-website/aws"  # required
  version = "1.0.0"   # recommended

  config = {
    bucket_name    = "<globally-unique-bucket-name>"
    destroy_bucket = false
    index_suffix   = "index.html"
    error_key      = "error.html"
    bucket_tags = {
      key = "value"
    }
  }
}
```

## Variables

| Name              | Type         | Default     | Description                                     |
|-------------------|--------------|-------------|-------------------------------------------------|
| `config`          | object       | n/a         | Object containing the following attributes:     |
| - `bucket_name`   | string       | n/a         | Required globally unique name of the S3 bucket. |
| - `destroy_bucket`| bool         | `false`     | Optional flag to force destroy of S3 bucket.    |
| - `index_suffix`  | string       | `index.html`| Optional suffix for the index document.         |
| - `error_key`     | string       | `error.html`| Optional error document key.                    |
| - `bucket_tags`   | map(string)  | `{}`        | Optional tags to be applied to the S3 bucket.   |

## Outputs

| Name              | Description                            |
|-------------------|----------------------------------------|
| `bucket_arn`      | ARN of the S3 bucket.                  |
| `bucket_name`     | The name of the S3 bucket.             |
| `bucket_domain`   | The S3 bucket website domain name.     |
| `bucket_tags`     | The tags applied to the S3 bucket.     |
| `website_endpoint`| The full URL endpoint for the website. |

## Example Output in Root Module

Once this module is applied, you can retrieve the S3 website’s URL with the following in the root module:

```hcl
output "website_url" {
  description = "The full HTTP URL for the static website on S3"
  value       = "http://${module.website_s3_bucket.website_endpoint}"
}
```
This will output the accessible website URL formatted as `http://bucket-name.s3-website-region.amazonaws.com`.

## Notes

- The module will delete the S3 bucket and **ALL contents** if `terraform destroy` is run and `force_destroy = true`.
- Ensure the `bucket_name` is globally unique to avoid naming conflicts.
- The `website_endpoint` does not include the protocol, so the `http://` prefix is added manually in the root module output.

## Author
Developed by \<Author\>. Contributions and feedback are welcome!