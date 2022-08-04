// Resource Group
resource "azurerm_resource_group" "main" {
  name     = "Network"
  location = local.azure.location

  tags = local.common_tags
}

// Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${local.azure.location_prefix}-VN0"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  address_space = [local.azure.vnet_address_prefix]

  tags = local.common_tags
}

// Subnets
resource "azurerm_subnet" "main_1" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = [local.azure.vnet_subnet_prefix_1]
}
resource "azurerm_subnet" "main_2" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = [local.azure.vnet_subnet_prefix_2]
}

// Security Groups
resource "azurerm_network_security_group" "main" {
  name                = "${local.azure.location_prefix}-NG0"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.common_tags
}
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main_1.id
  network_security_group_id = azurerm_network_security_group.main.id
}

// Public IPs
resource "azurerm_public_ip" "main_1" {
  name                = "${local.azure.location_prefix}-IP0"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Dynamic"

  tags = local.common_tags
}
resource "azurerm_public_ip" "main_2" {
  name                = "${local.azure.location_prefix}-IP1"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Dynamic"

  tags = local.common_tags
}

// VPN Gateway
resource "azurerm_virtual_network_gateway" "main" {
  name                = "${local.azure.location_prefix}-VG0"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  type          = "Vpn"
  vpn_type      = "RouteBased"
  active_active = true
  enable_bgp    = true
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig1"
    public_ip_address_id          = azurerm_public_ip.main_1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.main_2.id
  }
  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.main_2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.main_2.id
  }

  bgp_settings {
    asn = local.azure.vpn_bgp_asn
    peering_addresses {
      ip_configuration_name = "vnetGatewayConfig1"
      apipa_addresses = [
        local.azure.vpn_bgp_peering_address_1,
        local.azure.vpn_bgp_peering_address_2,
      ]
    }
    peering_addresses {
      ip_configuration_name = "vnetGatewayConfig2"
      apipa_addresses = [
        local.azure.vpn_bgp_peering_address_3,
        local.azure.vpn_bgp_peering_address_4,
      ]
    }
  }

  tags = local.common_tags
}

// Local Gateway
resource "azurerm_local_network_gateway" "main_1" {
  name                = "${local.azure.location_prefix}-LG0"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  gateway_address = aws_vpn_connection.main_1.tunnel1_address
  bgp_settings {
    asn                 = local.aws.vpn_bgp_asn
    bgp_peering_address = local.aws.vpn_bgp_peering_address_1
  }

  tags = local.common_tags
}
resource "azurerm_local_network_gateway" "main_2" {
  name                = "${local.azure.location_prefix}-LG1"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  gateway_address = aws_vpn_connection.main_1.tunnel2_address
  bgp_settings {
    asn                 = local.aws.vpn_bgp_asn
    bgp_peering_address = local.aws.vpn_bgp_peering_address_2
  }

  tags = local.common_tags
}
resource "azurerm_local_network_gateway" "main_3" {
  name                = "${local.azure.location_prefix}-LG2"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  gateway_address = aws_vpn_connection.main_2.tunnel1_address
  bgp_settings {
    asn                 = local.aws.vpn_bgp_asn
    bgp_peering_address = local.aws.vpn_bgp_peering_address_3
  }

  tags = local.common_tags
}
resource "azurerm_local_network_gateway" "main_4" {
  name                = "${local.azure.location_prefix}-LG3"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  gateway_address = aws_vpn_connection.main_2.tunnel2_address
  bgp_settings {
    asn                 = local.aws.vpn_bgp_asn
    bgp_peering_address = local.aws.vpn_bgp_peering_address_4
  }

  tags = local.common_tags
}

// Connections
resource "azurerm_virtual_network_gateway_connection" "main_1" {
  name                = "${local.azure.location_prefix}-CN0"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.main.id
  local_network_gateway_id   = azurerm_local_network_gateway.main_1.id
  shared_key                 = aws_vpn_connection.main_1.tunnel1_preshared_key
  enable_bgp                 = true

  tags = local.common_tags
}
resource "azurerm_virtual_network_gateway_connection" "main_2" {
  name                = "${local.azure.location_prefix}-CN1"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.main.id
  local_network_gateway_id   = azurerm_local_network_gateway.main_2.id
  shared_key                 = aws_vpn_connection.main_1.tunnel2_preshared_key
  enable_bgp                 = true

  tags = local.common_tags
}
resource "azurerm_virtual_network_gateway_connection" "main_3" {
  name                = "${local.azure.location_prefix}-CN2"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.main.id
  local_network_gateway_id   = azurerm_local_network_gateway.main_3.id
  shared_key                 = aws_vpn_connection.main_2.tunnel1_preshared_key
  enable_bgp                 = true

  tags = local.common_tags
}
resource "azurerm_virtual_network_gateway_connection" "main_4" {
  name                = "${local.azure.location_prefix}-CN3"
  location            = local.azure.location
  resource_group_name = azurerm_resource_group.main.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.main.id
  local_network_gateway_id   = azurerm_local_network_gateway.main_4.id
  shared_key                 = aws_vpn_connection.main_2.tunnel2_preshared_key
  enable_bgp                 = true

  tags = local.common_tags
}
