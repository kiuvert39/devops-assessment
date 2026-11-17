output "load_balancer_ip" {
  description = "Global external IP address"
  value       = google_compute_global_address.lb_ip.address
}

output "load_balancer_url" {
  description = "HTTP load balancer URL"
  value       = "http://${google_compute_global_address.lb_ip.address}"
}