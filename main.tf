locals {
  pool_cidr = flatten([
    for k, v in var.pools : [
      for cidr in v.cidr : {
        name = k
        cidr = cidr
      }
    ]]
  )

  pool_principal = flatten([
    for k, v in var.pools : [
      for principal in v.shared_principal : {
        name             = k
        shared_principal = principal
      }
    ]]
  )
}

data "aws_region" "default" {
  region = var.region
}

resource "aws_vpc_ipam" "default" {
  region      = var.region
  description = var.ipam_description
  tags        = var.tags

  operating_regions {
    region_name = data.aws_region.default.region
  }
}

resource "aws_vpc_ipam_pool" "aws_pool" {
  region         = var.region
  address_family = "ipv4"
  description    = "For usage on AWS"
  ipam_scope_id  = aws_vpc_ipam.default.private_default_scope_id
  locale         = data.aws_region.default.region
  tags           = var.tags
}

resource "aws_vpc_ipam_pool_cidr" "aws_pool_cidr" {
  for_each = toset(var.aws_ipam_pool)

  region       = var.region
  cidr         = each.value
  ipam_pool_id = aws_vpc_ipam_pool.aws_pool.id
}

resource "aws_vpc_ipam_pool" "environment" {
  for_each = var.pools

  region              = var.region
  address_family      = "ipv4"
  description         = each.key
  ipam_scope_id       = aws_vpc_ipam.default.private_default_scope_id
  locale              = data.aws_region.default.region
  source_ipam_pool_id = aws_vpc_ipam_pool.aws_pool.id
  tags                = var.tags
}

resource "aws_vpc_ipam_pool_cidr" "environment" {
  for_each = { for pool in local.pool_cidr : "${pool.name}_${pool.cidr}" => pool }

  region       = var.region
  cidr         = each.value.cidr
  ipam_pool_id = aws_vpc_ipam_pool.environment[each.value.name].id
}

resource "aws_ram_resource_share" "default" {
  for_each = var.pools

  region = var.region
  name   = "ipam-pool-${each.key}-share"
  tags   = var.tags
}

resource "aws_ram_resource_association" "default" {
  for_each = var.pools

  region             = var.region
  resource_arn       = aws_vpc_ipam_pool.environment[each.key].arn
  resource_share_arn = aws_ram_resource_share.default[each.key].arn
}

resource "aws_ram_principal_association" "default" {
  for_each = { for pool in local.pool_principal : "${pool.name}_${pool.shared_principal}" => pool }

  region             = var.region
  principal          = each.value.shared_principal
  resource_share_arn = aws_ram_resource_share.default[each.value.name].arn
}
