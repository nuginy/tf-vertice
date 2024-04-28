variable "amplify_name_prefix" {
  description = "Value of the name of the Amplify app"
  type = string
  default = "GettingStarted"
}

variable "git_repo_name" {
  description = "Value of the name of the Git repository"
  type = string
  default = "https://github.com/nuginy/tf-vertice"
}

variable "git_access_token" {}

variable "amplify_env" {
  description = "Value of the Amplify env var for variable ENV"
  type = string
  default = "dev"
}

variable "amplify_api_gw_address" {
  description = "Value of the Amplify env var for variable API_GW_ADDRESS"
  type = string
  default = ""
}

variable "amplify_enable_branch_auto_build" {
  description = "Enable or disable auto branch build"
  type = bool
  default = true
}

variable "amplify_enable_branch_auto_creation" {
  description = "Enable or disable auto branch creation"
  type = bool
  default = true
}

variable "amplify_branch_auto_creation_pattern" {
  description = "Pattern for branch auto creation"
  type = list(string)
  default = ["main"]
}

variable "amplify_tags" {
  description = "Value of the Amplify tags"
  type = map(string)
  default = {
    ENV = "Dev"
  }
}
