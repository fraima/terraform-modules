locals {
    
    security_groups  = [
        {
            name = "kubernetes/${local.cluster_name}"
            cidrs = flatten([
                for compute in yandex_compute_instance.master:
                    "${compute.network_interface[0].ip_address}/32"
            ])
            rules = [
                {
                    sg_to  = "kubernetes/${local.cluster_name}"
                    access = [
                        {
                            description = "access from kubernetes/${local.cluster_name} to kubernetes/${local.cluster_name}"
                            protocol    = "tcp"
                            ports_to    = [
                                10250, # :::10250   component: kubelet           purpose: server-port
                                6443,  # :::6443    component: kube-apiserver    purpose: server-port
                                2379,  # :::2379    component: etcd              purpose: server-port
                                2380,  # :::2380    component: etcd              purpose: peer-port
                                2381,  # :::2381    component: etcd              purpose: metrics-port
                                2382,  # :::2382    component: etcd              purpose: server-port-target-lb
                            ]
                        },
                    ]
                },
                {
                    sg_to  = "infra/hbf-server"
                    access = [
                        {
                            description = "access from kubernetes/${local.cluster_name} to hbf-server"
                            protocol    = "tcp"
                            ports_to    = [
                                9000,   # TO HBF-SERVER
                                9200,   # TO VAULT
                                443,    # TO OIDP
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "infra/dns"
                    access = [
                        {
                            description = "access from kubernetes/${local.cluster_name} to infra/dns"
                            protocol    = "udp"
                            ports_to    = [
                                53, # TO DNS-SERVERS
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "world/dl.k8s.io"
                    access = [
                        {
                            description = "access from kubernetes/${local.cluster_name} to world/dl.k8s.io"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO REGISTRY BIN
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "world/k8s.gcr.io"
                    access = [
                        {
                            description = "access from kubernetes/${local.cluster_name} to world/k8s.gcr.io"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO REGISTRY DOCKER
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "world/storage.googleapis.com"
                    access = [
                        {
                            description = "access from kubernetes/${local.cluster_name} to world/storage.googleapis.com"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO REGISTRY DOCKER
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "world/github.com"
                    access = [
                        {
                            description = "access from kubernetes/${local.cluster_name} to world/github.com"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO GITHUB REPOSITORY
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "yandex/storage.yandexcloud.net"
                    access = [
                        {
                            description = "access from kubernetes/${local.cluster_name} to yandex/storage.yandexcloud.net"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO REGISTRY BIN
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "yandex/iam"
                    access = [
                        {
                            description = "access from kubernetes/${local.cluster_name} to yandex/iam"
                            protocol    = "tcp"
                            ports_to    = [
                                80,    # TO REGISTRY BIN
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "yandex/api"
                    access = [
                        {
                            description = "access from kubernetes/${local.cluster_name} to yandex/api"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO API
                            ]
                        }
                    ]
                },
            ]
        },
        {
            name = "infra/hbf-server"
            cidrs = [
                "193.32.219.99/32",
            ]
            rules = []
        },
        {
            name = "infra/dns"
            cidrs = [
                "10.0.0.2/32",
            ]
            rules = []
        },
        {
            name = "world/dl.k8s.io" # Хранилище бинарей
            cidrs = [
                "34.107.204.206/32",
            ]
            rules = []
        },
        {
            name = "world/storage.googleapis.com" # Хранилище бинарей
            cidrs = [
                "173.194.222.128/32",
                "173.194.221.128/32",
                "173.194.220.128/32",
                "173.194.73.128/32",
                "64.233.161.128/32",
                "64.233.162.128/32",
                "64.233.164.128/32",
                "74.125.205.128/32",
            ]
            rules = []
        },
        {
            name = "world/k8s.gcr.io" # Хранилище бинарей
            cidrs = [
                "142.250.150.82/32",
                "209.85.233.82/32",
                "64.233.162.82/32",
                "142.251.1.82/32",
                "173.194.222.82/32",
                "64.233.161.82/32"
            ]
            rules = []
        },
        {
            name = "world/github.com"
            cidrs = [
                "140.82.121.3/32",
            ]
            rules = []
        },
        {
            name = "yandex/storage.yandexcloud.net"
            cidrs = [
                "213.180.193.243/32",
            ]
            rules = []
        },
        {
            name = "yandex/iam"
            cidrs = [
                "169.254.169.254/32",
            ]
            rules = []
        },
        {
            name = "yandex/api"
            cidrs = [
                "84.201.181.26/32",
            ]
            rules = []
        },
        {
            name = "world"
            cidrs = [
                "176.0.0.0/8",
                "198.0.0.0/8"
            ]
            rules = [
                {
                    sg_to  = "kubernetes/${local.cluster_name}"
                    access = [
                        {
                            description = "access from world to kubernetes/${local.cluster_name} by ssh"
                            protocol    = "tcp"
                            ports_to    = [
                                22,
                                6443,
                            ]
                        },
                    ]
                },
            ]
        }
    ]
}