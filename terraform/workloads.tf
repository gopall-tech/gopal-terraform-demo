# --- BACKEND A (Simulated User Service) ---
resource "kubernetes_deployment" "backend_a" {
  metadata {
    name = "backend-a"
    labels = { app = "backend-a" }
  }
  spec {
    replicas = 1
    selector { match_labels = { app = "backend-a" } }
    template {
      metadata { labels = { app = "backend-a" } }
      spec {
        container {
          image = "nginx:latest" # Represents Service A
          name  = "backend-a"
        }
      }
    }
  }
}

resource "kubernetes_service" "service_a" {
  metadata { name = "backend-a-svc" }
  spec {
    selector = { app = "backend-a" }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP" # Internal only (APIM will talk to this later)
  }
}

# --- BACKEND B (Simulated Order Service) ---
resource "kubernetes_deployment" "backend_b" {
  metadata {
    name = "backend-b"
    labels = { app = "backend-b" }
  }
  spec {
    replicas = 1
    selector { match_labels = { app = "backend-b" } }
    template {
      metadata { labels = { app = "backend-b" } }
      spec {
        container {
          image = "httpd:latest" # Represents Service B (different image)
          name  = "backend-b"
        }
      }
    }
  }
}

resource "kubernetes_service" "service_b" {
  metadata { name = "backend-b-svc" }
  spec {
    selector = { app = "backend-b" }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}