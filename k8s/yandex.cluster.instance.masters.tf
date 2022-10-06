
#### MASTERS ######
##-->
resource "yandex_compute_instance" "master" {

  for_each    = local.master_instance_list_map

  name        = "${each.key}-${var.cluster_name}"

  hostname    = format("%s.%s.%s", each.key ,var.cluster_name, var.base_domain)
  platform_id = "standard-v1"
  zone        = var.master-configs.zone
  labels      = {
    "node-role.kubernetes.io/master" = ""
  }
  resources {
    cores         = var.master_flavor.core
    memory        = var.master_flavor.memory
    core_fraction = var.master_flavor.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.base_os_image
      size = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.master-subnets.id
    nat = true
  }

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = templatefile("templates/cloud-init-master.tftpl", {

        ssh_key                           = file("~/.ssh/id_rsa.pub")
        base_local_path_certs             = local.base_local_path_certs
        ssl                               = local.ssl
        base_path                         = var.base_path
        kube_apiserver_lb_fqdn            = local.kube_apiserver_lb_fqdn
        kube-apiserver-port-lb            = var.kube-apiserver-port-lb
        hostname                          = "${each.key}-${var.cluster_name}"
        key_keeper_config                 = templatefile("templates/services/key-keeper/config.tftpl", {
          availability_zone               = each.key
          intermediates                   = local.ssl.intermediate
          base_local_path_vault           = local.base_local_path_vault
          base_vault_path_approle         = local.base_vault_path_approle
          base_certificate_atrs           = local.ssl.global-args.key-keeper-args
          secrets                         = local.secrets
          cluster_name                    = var.cluster_name
          base_domain                     = var.base_domain
          vault_config                    = var.vault_config
          vault_server                    = var.vault_server
          bootstrap_tokens_ca             = vault_token.kubernetes-ca-login
          bootstrap_tokens_sign           = vault_token.kubernetes-sign-login
          bootstrap_tokens_kv             = vault_token.kubernetes-kv-login
          availability_zone               = each.key
          full_instance_name              = format("%s.%s", each.key ,local.base_cluster_fqdn)
          external_instance_name          = "${each.key}-${var.cluster_name}"
        })
        kubelet-service-args              = templatefile("templates/services/kubelet/service-args.conf.tftpl", {
          full_instance_name              = format("%s.%s", each.key ,local.base_cluster_fqdn)
          instance_type                   = var.master-configs.group
          base_path                       = var.base_path
          base_domain                     = var.base_domain
        })
        etcd-manifest                     = templatefile("templates/manifests/etcd.yaml.tftpl", {
          etcd_initial_cluster            = local.etcd_initial_cluster
          base_local_path_certs           = local.base_local_path_certs
          ssl                             = local.ssl
          cluster_name                    = var.cluster_name
          base_domain                     = var.base_domain
          etcd-image                      = var.etcd-image.repository
          etcd-version                    = var.etcd-image.version
          full_instance_name              = format("%s.%s", each.key ,local.base_cluster_fqdn)
          etcd-peer-port                  = var.etcd-peer-port
          etcd-server-port                = var.etcd-server-port
          etcd-metrics-port               = var.etcd-metrics-port
          etcd-server-port-target-lb      = var.etcd-server-port-target-lb
        })

        kube-apiserver-manifest           = local.kube-apiserver-manifest
        kube-controller-manager-manifest  = local.kube-controller-manager-manifest 
        kube-scheduler-manifest           = local.kube-scheduler-manifest
        kubelet-service-d-fraima          = local.kubelet-service-d-fraima
        containerd-service                = local.containerd-service
        base-cni                          = local.base-cni
        sysctl-network                    = local.sysctl-network
        kubelet-config                    = local.kubelet-config
        kubelet-service                   = local.kubelet-service
        key-keeper-service                = local.key-keeper-service
        modules-load-k8s                  = local.modules-load-k8s
      })
  }
}

output "cloud_init" {
    value = "${yandex_compute_instance.master[*].master-1.network_interface[*].nat_ip_address}"
}
