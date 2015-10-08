output "nodes" {
    value = ["${join(" | ", google_compute_instance.etcd-nodes.*.network_interface.0.access_config.0.nat_ip)}"]
}

output "lb" {
    value = "${google_compute_address.etcd-lb.address}"
}
