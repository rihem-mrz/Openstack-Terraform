#define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

#define provider access credentials
provider "openstack" {
  user_name   = var.user_name  #tenant_name = "admin"
  password    = var.password
  auth_url    = var.auth_url
  region      = var.region
  tenant_name = "admin"
  domain_id   = "default"
}


#provide ssh key to access instance
resource "openstack_compute_keypair_v2" "nodekey" {
  name       = var.key_name
  public_key = var.ssh_key
}


#define network and subnet 
resource "openstack_networking_network_v2" "network" {
  name           = var.network_name
  admin_state_up = "true"
}
resource "openstack_networking_subnet_v2" "subnet" {
  name       = var.subnet_name
  network_id = "${openstack_networking_network_v2.network.id}"
  cidr       = "***/24"
  ip_version = 4
}


#define router and router interface 
resource "openstack_networking_router_v2" "router" {
  name             = var.router_name
  admin_state_up   = "true"
}
resource "openstack_networking_router_interface_v2" "router-interface" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet.id}"
}


#security group add rules accessing instances
resource "openstack_compute_secgroup_v2" "securitygroup" {
  name        = var.secgroup_name
  description = "Security group for instances"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}


#ip flowting to get a public address for external connections 
#resource "openstack_compute_floatingip_v2" "floatip" {
#  pool = var.pool
#}


#create Openstack instance
resource "openstack_compute_instance_v2" "node" {
  count           = var.num-instance
  name            = "node-${count.index}"
  image_name      = var.image
  flavor_name     = var.flavor
  key_pair        = "${openstack_compute_keypair_v2.nodekey.name}"
  security_groups = ["${openstack_compute_secgroup_v2.securitygroup.name}"]

  network {
    uuid        = "${openstack_networking_network_v2.network.id}"
    fixed_ip_v4 = var.ip_address[count.index]
  }

}

