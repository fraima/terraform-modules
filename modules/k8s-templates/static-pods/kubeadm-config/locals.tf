locals {
    manifest = flatten([
    for node_name, node_content in  var.instance_list_map:
        {"${node_name}" = templatefile("${path.module}/templates/kubeadm-config.yaml.tftpl", {
        
        etcd_list_servers               = var.etcd_list_servers
        secrets                         = var.k8s_global_vars.secrets
        service_cidr                    = var.k8s_global_vars.k8s_network.service_cidr
        ssl                             = var.k8s_global_vars.ssl
        component_versions              = var.k8s_global_vars.component_versions
        base_path                       = var.k8s_global_vars.global_path
        main_path                       = var.k8s_global_vars.main_path
        kube_apiserver_port             = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port
        kube_api_fqdn                   = var.k8s_global_vars.k8s-addresses.kube_apiserver_lb_fqdn
        cluster_name                    = var.k8s_global_vars.cluster_metadata.cluster_name
        pod_cidr                        = var.k8s_global_vars.k8s_network.pod_cidr
        node_cidr_mask                  = var.k8s_global_vars.k8s_network.node_cidr_mask
        kube_flags                      = var.k8s_global_vars.kube_flags
        # kubelet_config                  = module.kubelet.kubelet-config
    })}
    ])

    manifest-map = { for item in local.manifest :
      keys(item)[0] => values(item)[0]
    }
}
