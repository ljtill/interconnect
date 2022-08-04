// Virtual Cloud
resource "aws_vpc" "main" {
  cidr_block = local.aws.vpc_cidr_block

  tags = local.common_tags
}

// Subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.aws.vpc_subnet_cidr_block

  tags = local.common_tags
}

// Route Table
resource "aws_vpn_gateway_route_propagation" "main" {
  vpn_gateway_id = aws_vpn_gateway.main.id
  route_table_id = aws_vpc.main.main_route_table_id
}

// VPN Gateway
resource "aws_vpn_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = local.common_tags
}

// Customer Gateways
resource "aws_customer_gateway" "main_1" {
  ip_address = data.azurerm_public_ip.main_1.ip_address
  bgp_asn    = local.azure.vpn_bgp_asn
  type       = "ipsec.1"

  tags = local.common_tags

  lifecycle {
    ignore_changes = [ip_address]
  }

  depends_on = [
    data.azurerm_public_ip.main_1
  ]
}
resource "aws_customer_gateway" "main_2" {
  ip_address = data.azurerm_public_ip.main_2.ip_address
  bgp_asn    = local.azure.vpn_bgp_asn
  type       = "ipsec.1"

  tags = local.common_tags

  lifecycle {
    ignore_changes = [ip_address]
  }

  depends_on = [
    data.azurerm_public_ip.main_2
  ]
}

// VPN Connections
resource "aws_vpn_connection" "main_1" {
  vpn_gateway_id      = aws_vpn_gateway.main.id
  customer_gateway_id = aws_customer_gateway.main_1.id

  type                = "ipsec.1"
  tunnel1_inside_cidr = local.aws.vpn_bgp_peering_cidr_1
  tunnel2_inside_cidr = local.aws.vpn_bgp_peering_cidr_2

  tags = local.common_tags
}
resource "aws_vpn_connection" "main_2" {
  vpn_gateway_id      = aws_vpn_gateway.main.id
  customer_gateway_id = aws_customer_gateway.main_2.id

  type                = "ipsec.1"
  tunnel1_inside_cidr = local.aws.vpn_bgp_peering_cidr_3
  tunnel2_inside_cidr = local.aws.vpn_bgp_peering_cidr_4

  tags = local.common_tags
}
