terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.20.0"
    }
  }
}

provider "digitalocean" {
  token = var.do-token
}

resource "digitalocean_kubernetes_cluster" "k8s_iniciativa" {
  name  = var.k8s_name
  region = var.k8s_region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.22.8-do.1"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

variable "do-token" {}
variable "k8s_name" {}
variable "k8s_region" {}


#output "kube_endpoint" {
#  value = digitalocean_kubernetes_cluster.k8s_iniciativa.endpoint
#}

#output "kube_config" {
#  value = digitalocean_kubernetes_cluster.k8s_iniciativa.kube_config.0.raw_config
#}

resource "local_file" "kube_config" {
    content  = digitalocean_kubernetes_cluster.k8s_iniciativa.kube_config.0.raw_config
    #filename = "${path.module}/foo.bar"
    filename = "kube_config.yaml"
}