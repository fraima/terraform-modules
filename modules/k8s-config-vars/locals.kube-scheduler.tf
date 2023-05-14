locals {
  default_kube_scheduler_flags = {
    secure-port = "${ local.kubernetes-ports.kube-scheduler-port }"
  }
}

data "utils_deep_merge_yaml" "kube_scheduler_flags" {
  input = [
    yamlencode(local.default_kube_scheduler_flags),
    file("default/kube-controller-manager.yaml"),
    yamlencode(try(var.extra_args.kube_scheduler_flags, {}))
  ]
}

