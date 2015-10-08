variable "project" {
    default = "sheriff-woody"
}

#
# files
#

variable "file-account" {
    default = "files/sheriff-woody.json"
}

variable "file-ca-cert" {
    default = "files/ca.pem"
}

variable "file-etcd-server-cert" {
    default = "files/etcd.server.pem"
}

variable "file-etcd-server-key" {
    default = "files/etcd.server.key.pem"
}

variable "file-etcd-client-cert" {
    default = "files/etcd.client.pem"
}

variable "file-etcd-client-key" {
    default = "files/etcd.client.key.pem"
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
    default = "etcd"
}

variable "etcd-ipv4-prefix" {
    default = "10.1.0."
}

variable "etcd-node-zones" {
    default = {
        "0" = "us-central1-a"
        "1" = "us-central1-b"
        "2" = "us-central1-c"
    }
}

variable "etcd-tags" {
    default = "role=etcd,environment=production"
}

variable "machine_type" {
    default = "n1-standard-1"
}

variable "coreos-image" {
    default = "coreos-alpha-801-0-0-v20150910"
}

variable "coreos-update-group" {
    default = "stable"
}

variable "coreos-update-server" {
    default = "https://public.update.core-os.net/v1/update/"
}
