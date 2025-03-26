# Instala o Helm Provider
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Instala o Helm no cluster
resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "monitoring"
  version    = "6.56.4"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "adminUser"
    value = "admin"
  }

  set {
    name  = "adminPassword"
    value = "admin"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.size"
    value = "10Gi"
  }
}