/*
 * External HTTP Load Balancer
 *
 * Exposes the Cloud Run application through a stable public IP address.
 *
 * It provisions:
 * - A reserved global IP address for the load balancer.
 * - A serverless Network Endpoint Group (NEG) connected to Cloud Run.
 * - A backend service that forwards traffic to the serverless NEG.
 * - An HTTP forwarding rule and URL routing configuration.
 *
 * The load balancer acts as the public entry point for application traffic
 * and routes requests to the Cloud Run service.
 */

resource "google_compute_global_address" "lb_ip" {
  name = "${var.name}-ip"
}

resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "${var.name}-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = var.cloud_run_service_name
  }
}

resource "google_compute_backend_service" "backend" {
  name                  = "${var.name}-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg.id
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.name}-url-map"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name                  = "${var.name}-forwarding-rule"
  ip_address            = google_compute_global_address.lb_ip.address
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_proxy.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
}