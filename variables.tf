variable "account_file" {}
variable "project" {}

variable "region" {
    default = "us-central1"
}

variable "etcd-network-name" {
    default = "etcd-network"
}

variable "etcd-network-ipv4-range" {
    default = "10.0.0.0/16"
}

variable "etcd-name-prefix" {
    default = "etcd-production"
}

variable "etcd-ipv4-prefix" {
    default = "10.1.0."
}

variable "etcd-ipv4-offset" {
    default = 10
}

variable "etcd-node-zones" {
    default = {
        "0" = "us-central1-a"
        "1" = "us-central1-b"
        "2" = "us-central1-c"
    }
}

variable "etcd-ssh-pub-key" {
    default = "id_rsa.pub"
}

variable "machine_type" {
    default = "n1-standard-1"
}

# coreos-alpha-801-0-0-v20150910
# coreos-beta-766-3-0-v20150902
# coreos-stable-766-3-0-v20150908
variable "image" {
	default = "coreos-alpha-801-0-0-v20150910"
}
