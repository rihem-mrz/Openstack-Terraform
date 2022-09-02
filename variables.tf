variable "user_name" {
    description = "The username to be used for authentication in Openstack"
    type        = string
}

variable "password" {
    description = "The password to be used for authentication in Openstack"
    type        = string
}

variable "region" {
    description = "The Openstack region for provisioned VMs"
    type        = string
    default     = "RegionOne"
}

variable "auth_url" {
    description = "The URL for Openstack"
    type        = string
}

variable "key_name" {
    description = "Name for SSH key"
    type        = string
}

variable "ssh_key" {
    description = "SSH key to access Openstack instance"
    type        = string
}

variable "network_name" {
    description = "Name of the network"
    type        = string
}

variable "subnet_name" {
    description = "Name of the subnet"
    type        = string
}

variable "router_name" {
    description = "Name of the router"
    type        = string
}

variable "secgroup_name" {
    description = "Name of the security group"
    type        = string
}

variable "pool" {
    description = "Define the pool where it belong"
    type        = string
    default     = "provider"
}

variable "num-instance" {
    description = "Number of instances to deploy"
    type        = number 
}

variable "image" {
    description = "The Os image for the instance"
    type        = string
}

variable "flavor" {
    description = "define the flavor to get the hardware description for instances"
    type        = string
    default     = "m1.small"
}

variable "ip_address" {
    description = "IP address for each instance"
    type = list(string)
}


