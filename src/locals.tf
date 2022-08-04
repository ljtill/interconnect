locals {
  common_tags = {
    "Provisioner" = "Terraform Cloud"
  }

  aws = {
    location                  = "eu-west-1"
    location_prefix           = "EU"
    vpc_cidr_block            = "172.30.0.0/16"
    vpc_subnet_cidr_block     = "172.30.0.0/24"
    vpn_bgp_asn               = 64512
    vpn_bgp_peering_cidr_1    = "169.254.21.0/30"
    vpn_bgp_peering_cidr_2    = "169.254.22.0/30"
    vpn_bgp_peering_cidr_3    = "169.254.21.4/30"
    vpn_bgp_peering_cidr_4    = "169.254.22.4/30"
    vpn_bgp_peering_address_1 = "169.254.21.1"
    vpn_bgp_peering_address_2 = "169.254.22.1"
    vpn_bgp_peering_address_3 = "169.254.21.5"
    vpn_bgp_peering_address_4 = "169.254.22.5"
  }

  azure = {
    location                  = "northeurope"
    location_prefix           = "EUN"
    vnet_address_prefix       = "172.31.0.0/16"
    vnet_subnet_prefix_1      = "172.31.0.0/24"
    vnet_subnet_prefix_2      = "172.31.254.0/24"
    vpn_bgp_asn               = 65515
    vpn_bgp_peering_cidr_1    = "169.254.21.0/30"
    vpn_bgp_peering_cidr_2    = "169.254.22.0/30"
    vpn_bgp_peering_cidr_3    = "169.254.21.4/30"
    vpn_bgp_peering_cidr_4    = "169.254.22.4/30"
    vpn_bgp_peering_address_1 = "169.254.21.2"
    vpn_bgp_peering_address_2 = "169.254.22.2"
    vpn_bgp_peering_address_3 = "169.254.21.6"
    vpn_bgp_peering_address_4 = "169.254.22.6"
  }

  google = {}
}
