output "addresses" {
    value = ["${join(" | ", google_compute_instance.etcd-nodes.*.network_interface.0.access_config.0.nat_ip)}"]
}
