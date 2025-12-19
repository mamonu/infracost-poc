provider "aws" {
  region                      = "eu-west-2"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  default_tags {
    tags = {
      business-unit = "Platforms"
      application   = "coat-team"
      owner         = "finops-poc"
      is-production = "false"
      namespace     = "tag-enforcement-spike-dev"
      service-area  = "Cloud Optimisation"
      environment   = "dev"
    }
  }
}

provider "aws" {
  alias                       = "no_default_tags"
  region                      = "eu-west-2"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}
