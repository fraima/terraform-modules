#### LB ######
##-->
resource "yandex_lb_target_group" "master-tg" {
  name        = local.yandex_lb_target_group_master
  region_id   = "ru-central1"

  dynamic "target" {
    for_each = var.k8s_global_vars.master_vars.master_instance_list_map

    content {
      subnet_id = yandex_vpc_subnet.master-subnets[
      "${try(
        var.k8s_global_vars.master_vars.master_group.resources_override[target.key].network_interface.subnet, 
        var.k8s_global_vars.master_vars.master_group.default_subnet 
      )}:${try(
        var.k8s_global_vars.master_vars.master_group.resources_override[target.key].network_interface.zone, 
        var.k8s_global_vars.master_vars.master_group.default_zone 
      )}"
      ].id
      address   = yandex_compute_instance.master[target.key].network_interface.0.ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "api-external" {
  name = local.kube_apiserver_lb_name
  type = "external"
  region_id  = "ru-central1"

  listener {
    name        = local.kube_apiserver_listener_name
    port        = local.kube_apiserver_port_lb
    target_port = local.kube_apiserver_port
    
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.master-tg.id

    healthcheck {
      name = "tcp"
      tcp_options {
        port = local.kube_apiserver_port
      }
    }
  }
}
