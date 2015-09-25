resource "google_compute_network" "etcd-network" {
    name       = "${var.etcd-network-name}"
    ipv4_range = "${var.etcd-network-ipv4-range}"
}

resource "google_compute_firewall" "etcd-allow-ssh-from-anywhere" {
    name          = "etcd-allow-ssh-from-gce-developer-console"
    network       = "${google_compute_network.etcd-network.name}"
    source_ranges = [ "0.0.0.0/0" ]

    allow {
        protocol = "tcp"
        ports = [ "22" ]
    }
}

resource "google_compute_firewall" "etcd-allow-internal" {
    name          = "etcd-allow-internal"
    network       = "${google_compute_network.etcd-network.name}"
    source_ranges = [ "10.0.0.0/8" ]

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports = [ "1-65535" ]
    }

    allow {
        protocol = "udp"
        ports = [ "1-65535" ]
    }
}

resource "template_file" "etcd-userdata" {
    filename = "${format("%s/%s", path.module, "files/etcd.yml")}"
    count    = "${length(keys(var.etcd-node-zones))}"
    vars {
        #
        # parameters
        #

        me           = "${format("%s-%d=%s%d", var.etcd-name-prefix, count.index, var.etcd-ipv4-prefix, var.etcd-ipv4-offset+count.index)}"
        # "%s1%s" is a little hack until https://github.com/hashicorp/terraform/issues/3306 gets fixed
        members      = "${join(",", formatlist("%s-%s=%s1%s", var.etcd-name-prefix, keys(var.etcd-node-zones), var.etcd-ipv4-prefix, keys(var.etcd-node-zones)))}"
        private_ipv4 = "${format("%s%d", var.etcd-ipv4-prefix, var.etcd-ipv4-offset+count.index)}"
 
        #
        # files
        #

        ca-chain-cert    = "${base64enc(file(format("%s/%s", path.module, "files/ca-chain.cert.pem")))}"
        etcd-server-key  = "${base64enc(file(format("%s/%s", path.module, "files/etcd-server.key.pem")))}"
        etcd-server-cert = "${base64enc(file(format("%s/%s", path.module, "files/etcd-server.cert.pem")))}"
    }
}

resource "google_compute_disk" "etcd-pds" {
    name  = "${var.etcd-name-prefix}-${count.index}-pd"
    type  = "pd-ssd"
    zone  = "${lookup(var.etcd-node-zones, count.index)}"
    size  = 200
    count = "${length(keys(var.etcd-node-zones))}"
}

resource "google_compute_instance" "etcd-nodes" {
    name           = "${var.etcd-name-prefix}-${count.index}"
    machine_type   = "${var.machine_type}"
    zone           = "${lookup(var.etcd-node-zones, count.index)}"
    can_ip_forward = true
    tags           = [ "etcd" ]
    count          = "${length(keys(var.etcd-node-zones))}"

    disk {
        image       = "${var.image}"
        type        = "pd-ssd"
        size        = 200
        auto_delete = true
    }

    disk {
        disk        = "${var.etcd-name-prefix}-${count.index}-pd"
        auto_delete = false
    }

    network_interface {
        network = "${google_compute_network.etcd-network.name}"
        access_config {
            // Ephemeral IP
        }
    }

    metadata {
        user-data = "${element(template_file.etcd-userdata.*.rendered, count.index)}"
        sshKeys   = "${file(var.etcd-ssh-pub-key)}"
    }

    depends_on = [
        "google_compute_disk.etcd-pds",
        # "google_compute_target_pool.etcd-pool"
    ]
}

resource "google_compute_route" "ip-10-1-0-n" {
    name                   = "${format("ip-%s%d", replace(var.etcd-ipv4-prefix, ".", "-"), var.etcd-ipv4-offset+count.index)}"
    network                = "${google_compute_network.etcd-network.name}"
    next_hop_instance      = "${var.etcd-name-prefix}-${count.index}"
    next_hop_instance_zone = "${lookup(var.etcd-node-zones, count.index)}"
    priority               = 1000
    dest_range             = "${format("%s%d", var.etcd-ipv4-prefix, var.etcd-ipv4-offset+count.index)}/32"
    count                  = "${length(keys(var.etcd-node-zones))}"

    depends_on = [
        "google_compute_instance.etcd-nodes"
    ]
}

## until etcd2 supports authentication or gce supports an internal load balancer
/*
resource "google_compute_http_health_check" "etcd-client-port-check" {
    name               = "etcd-client-port-check"
    port               = 2379
    request_path       = "/v2/keys"
    check_interval_sec = 5
    timeout_sec        = 5
}

resource "google_compute_target_pool" "etcd-pool" {
    name          = "etcd-pool"
    # WARNING, keys(x) & values(x) should be in lexicographical order!!!
    instances     = [ "${formatlist("%s/%s-%s", values(var.etcd-node-zones), var.etcd-name-prefix, keys(var.etcd-node-zones))}" ]
    health_checks = [ "${google_compute_http_health_check.etcd-client-port-check.name}" ]
}

resource "google_compute_address" "etcd-lb" {
    name = "etcd-lb"
}

resource "google_compute_forwarding_rule" "etcd-rule" {
    name       = "etcd-rule"
    ip_address = "${google_compute_address.etcd-lb.address}"
    port_range = "2379-2380"
    target     = "${google_compute_target_pool.etcd-pool.self_link}"
}
*/
