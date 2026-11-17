resource "google_cloud_run_v2_service" "application" {
  name     = var.service_name
  location = var.region

  deletion_protection = false

  ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    service_account = var.service_account_email

    scaling {
      min_instance_count = 0
      max_instance_count = 3
    }



    volumes {
      name = "cloudsql"

      cloud_sql_instance {
        instances = [var.cloud_sql_connection_name]
      }
    }

    # Nginx ingress container
    containers {
      name  = "nginx"
      image = var.nginx_image

      ports {
        container_port = 8080
      }

      env {
        name  = "PHP_FPM_HOST"
        value = "127.0.0.1"
      }

      env {
        name  = "APP_ENV"
        value = var.environment
      }
      depends_on = ["php"]
    }

    # php  container
    containers {
      name  = "php"
      image = var.php_image

      env {
        name  = "APP_ENV"
        value = var.environment
      }

      env {
        name  = "DB_SOCKET"
        value = "/cloudsql/${var.cloud_sql_connection_name}"
      }

      env {
        name  = "DB_DATABASE"
        value = var.database_name
      }

      env {
        name  = "DB_USERNAME"
        value = var.db_username
      }

      env {
        name  = "GCS_BUCKET"
        value = var.bucket_name
      }

      env {
        name = "DB_PASSWORD"

        value_source {
          secret_key_ref {
            secret  = var.db_password_secret_id
            version = "latest"
          }
        }
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }

      startup_probe {
        tcp_socket {
          port = 9000
        }

        initial_delay_seconds = 5
        period_seconds        = 5
        failure_threshold     = 10
      }
    }
  }
  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
      template[0].containers[1].image
    ]
  }
}