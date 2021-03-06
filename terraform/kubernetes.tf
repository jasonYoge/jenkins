provider "kubernetes" {}

resource "kubernetes_deployment" "jenkins" {
  metadata {
    name = "jenkins-deployment"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "jenkins"
      }
    }
    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }
      spec {
        container {
          name  = "jenkins"
          image = "jasonyoge/jenkins"

          volume_mount {
            name       = "docker-sock"
            mount_path = "/var/run/docker.sock"
          }

          port {
            container_port = 8080
          }
        }

        volume {
          name = "docker-sock"
          host_path {
            path = "/var/run/docker.sock"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "jenkins" {
  metadata {
    name = "jenkins"
  }
  spec {
    type = "NodePort"
    port {
      port        = 8080
      target_port = 8080
      node_port   = 30000
    }
    selector = {
      app = kubernetes_deployment.jenkins.spec.0.template.0.metadata.0.labels.app
    }
  }
}
