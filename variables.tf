
variable "project" {}

#
# files
#

variable "file-account" {
}

variable "file-ca-chain-cert" {
    default = "files/ca-chain.cert.pem"
}

variable "file-etcd-server-key" {
    default = "files/etcd-server.key.pem"
}

variable "file-etcd-server-cert" {
    default = "files/etcd-server.cert.pem"
}

variable "file-etcd-ssh-pub-key" {
    default = "files/id_rsa.pub"
}

# infrastructure

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

variable "machine_type" {
    default = "n1-standard-1"
}

# coreos-alpha-801-0-0-v20150910
# coreos-beta-766-3-0-v20150902
# coreos-stable-766-3-0-v20150908
variable "image" {
	default = "coreos-alpha-801-0-0-v20150910"
}
