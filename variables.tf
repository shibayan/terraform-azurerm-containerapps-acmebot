variable "function_app_name" {
  type        = string
  description = "The name of the Function App to create."
}

variable "app_service_plan_name" {
  type        = string
  description = "The name of the App Service Plan to create."
}

variable "storage_account_name" {
  type        = string
  description = "The name of the Storage Account to create."
}

variable "app_insights_name" {
  type        = string
  description = "The name of the Application Insights to create."
}

variable "workspace_name" {
  type        = string
  description = "The name of the Log Analytics Workspace to create."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name to be added."
}

variable "location" {
  type        = string
  description = "Azure region to create resources."
}

variable "subscription_id" {
  type        = string
  description = "The Subscription ID that contains the target App Service"
}

variable "mail_address" {
  type        = string
  description = "Email address for ACME account."
}

variable "acme_endpoint" {
  type        = string
  description = "Certification authority ACME Endpoint."
  default     = "https://acme-v02.api.letsencrypt.org/"
}

variable "environment" {
  type        = string
  description = "The name of the Azure environment."
  default     = "AzureCloud"
}

variable "time_zone" {
  type        = string
  description = "The name of time zone as the basis for automatic update timing."
  default     = "UTC"
}

variable "webhook_url" {
  type        = string
  description = "The webhook where notifications will be sent."
  default     = null
}

variable "external_account_binding" {
  type = object({
    key_id    = string
    hmac_key  = string
    algorithm = string
  })
  default = null
}

variable "auth_settings" {
  type = object({
    enabled                       = bool
    issuer                        = string
    token_store_enabled           = bool
    unauthenticated_client_action = string
    active_directory = object({
      client_id         = string
      allowed_audiences = list(string)
    })
  })
  description = "Authentication settings for the function app"
  default     = null
}

variable "app_settings" {
  description = "Additional settings to set for the function app"
  type        = map(string)
  default     = {}
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "A list of allowed ip addresses that can access the Acmebot UI."
  default     = []
}

locals {
  external_account_binding = var.external_account_binding != null ? {
    "Acmebot:ExternalAccountBinding:KeyId"     = var.external_account_binding.key_id
    "Acmebot:ExternalAccountBinding:HmacKey"   = var.external_account_binding.hmac_key
    "Acmebot:ExternalAccountBinding:Algorithm" = var.external_account_binding.algorithm
  } : {}

  webhook_url = var.webhook_url != null ? {
    "Acmebot:Webhook" = var.webhook_url
  } : {}

  common = {
    "Acmebot:SubscriptionId" = var.subscription_id
    "Acmebot:Contacts"       = var.mail_address
    "Acmebot:Endpoint"       = var.acme_endpoint
    "Acmebot:Environment"    = var.environment
  }

  acmebot_app_settings = merge(
    local.common,
    local.external_account_binding,
    local.webhook_url
  )
}