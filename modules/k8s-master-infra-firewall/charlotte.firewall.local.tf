locals {

    charlotte_payload  = [
        # { 
        #     # Уникальное имя Security Group (обязательное поле)
        #     name = "example"
        #     # Список подсетей, которые присутствуют в Security Group (необязательное поле)
        #     # Если список пустой или не указан вовсе, SG не будет создана (требуется создать ее отдельно вместе с нетворками)
        #     # Обычно это требуется если сети не определены статикой а будут созданы позже.
        #     # ERROR:> The "for_each" map includes keys derived from resource attributes that cannot be determined until apply, 
        #     # and so Terraform cannot determine the full set of keys │ that will identify the instances of this resource.
        #     cidrs = [
        #         "193.32.219.121/32",
        #     ]
        #     # Список правил для SG (необязательное поле)
        #     rules = [
        #         # Массив всегда имеет ключ sg_to, он не должен дублироваться, 
        #         # все правила до одной SG прописываем в рамках одного массива.
        #         {
        #             # Уникальное имя Security Group (обязательное поле)
        #             # Название SG куда (ДО) открываем доступ
        #             sg_to  = "example"
        #             # Список портов ОТ -> ДО | Протокол
        #             access = {
        #                 tcp = [
        #                     {
        #                         # Короткое описание для чего данный доступ
        #                         description = "access from example to example"
        #                         # Открываем доступ ОТ портов
        #                         ports_from    = [
        #                             8000,
        #                         ]
        #                         # Открываем доступ ДО портов
        #                         ports_to    = [
        #                             80,
        #                             443,
        #                         ]
        #                     }
        #                 ]
        #                 udp = []

        #         },
        #     ]
        # },
        {
            name = "kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}/masters"
            rules = [
                {
                    sg_to  = "kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}/masters"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}"
                                
                                ports_to    = [
                                    var.k8s_global_vars.kubernetes-ports.etcd-server-port,
                                    var.k8s_global_vars.kubernetes-ports.etcd-peer-port,
                                    var.k8s_global_vars.kubernetes-ports.etcd-metrics-port,
                                    var.k8s_global_vars.kubernetes-ports.kubelet-server-port,
                                    var.k8s_global_vars.kubernetes-ports.kube-apiserver-port,
                                    var.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb,
                                    var.k8s_global_vars.kubernetes-ports.yandex-controller-manager,
                                ]
                            },
                        ]
                    }
                },
                {
                    sg_to  = "infra/hbf-server"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to hbf-server"
                                ports_to    = [
                                    9000,   # TO HBF-SERVER
                                    9200,   # TO VAULT
                                    443,    # TO OIDP
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "infra/dns"
                    access = {
                        udp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to infra/dns"
                                ports_to    = [
                                    53, # TO DNS-SERVERS
                                ]
                            }               
                        ]
                    }
                },
                {
                    sg_to  = "world/dl.k8s.io"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to world/dl.k8s.io"
                                ports_to    = [
                                    443,    # TO REGISTRY BIN
                                ]
                            },
                        ]
                    }
                },
                {
                    sg_to  = "world/k8s.gcr.io"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to world/k8s.gcr.io"
                                ports_to    = [
                                    443,    # TO REGISTRY DOCKER
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "world/storage.googleapis.com"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to world/storage.googleapis.com"
                                ports_to    = [
                                    443,    # TO REGISTRY DOCKER
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "world/github.com"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to world/github.com"
                                ports_to    = [
                                    443,    # TO GITHUB REPOSITORY
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "world/objects.githubusercontent.com"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to world/objects.githubusercontent.com"
                                ports_to    = [
                                    443,    # TO GITHUB REPOSITORY
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "yandex/iam"
                    access = {
                        tcp = [
                        {
                            description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to yandex/iam"
                            ports_to    = [
                                80,    # TO REGISTRY BIN
                                443,
                            ]
                        }
                        ]
                    }
                },
                {
                    sg_to  = "yandex/api"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to yandex/api"
                                ports_to    = [
                                    443,    # TO API
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "deckhouse/registry"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to deckhouse/registry"
                                ports_to    = [
                                    443,    # to deckhouse/registry
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}/api"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}/api"
                                ports_to    = [
                                    443,    # to deckhouse/registry
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "redhat/quay.io"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to redhat/quay.io"
                                ports_to    = [
                                    443,    # to deckhouse/registry
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "redhat/cdn01.quay.io"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to redhat/cdn01.quay.io"
                                ports_to    = [
                                    443,    # to deckhouse/registry
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "redhat/cdn02.quay.io"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to redhat/cdn02.quay.io"
                                ports_to    = [
                                    443,    # to deckhouse/registry
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "cloudflare/cdn03.quay.io.cdn.cloudflare.net"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to cloudflare/cdn03.quay.io.cdn.cloudflare.net"
                                ports_to    = [
                                    443,    # to deckhouse/registry
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "docker/registry-1.docker.io"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to docker/registry-1.docker.io"
                                ports_to    = [
                                    443,    # to deckhouse/registry
                                ]
                            }
                        ]
                    }
                },
                {
                    sg_to  = "cloudflare/production.cloudflare.docker.com"
                    access = {
                        tcp = [
                            {
                                description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to cloudflare/production.cloudflare.docker.com"
                                ports_to    = [
                                    443,    # to deckhouse/registry
                                ]
                            }
                        ]
                    }
                },
            ]
        },
        # {
        #     name = "infra/hbf-server"
        #     cidrs = [
        #         "193.32.219.99/32",
        #     ]
        #     rules = []
        # },
        {
            name = "infra/dns"
            cidrs = [
                "10.100.0.2/32",
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
                "172.217.174.176/32",
                "142.250.153.82/32",
                "142.250.186.48/32",
                "142.250.180.240/32",
                "142.250.186.80/32",
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
                "64.233.161.82/32",
                "64.233.165.82/32",
                "173.194.73.82/32",
                "64.233.164.82/32",
                "108.177.14.82/32",
                "74.125.205.82/32",
                "108.177.119.82/32",
                "64.233.163.82/32",
                "173.194.220.82/32"
            ]
            rules = []
        },
        {
            name = "redhat/quay.io" # Хранилище бинарей
            cidrs = [
                "34.196.205.78/32",
                "54.175.192.12/32",
                "34.239.202.225/32",
                "54.85.89.0/32",
                "3.228.127.23/32",
                "18.233.104.15/32",
                "34.235.95.169/32",
                "3.214.105.117/32",
                "52.3.168.193/32",
            ]
            rules = []
        },
        {
            name = "redhat/cdn01.quay.io" # Хранилище бинарей
            cidrs = [
                "13.33.243.21/32",
                "13.33.243.6/32",
                "13.33.243.66/32",
                "13.33.243.108/32",
            ]
            rules = []
        },
        {
            name = "redhat/cdn02.quay.io" # Хранилище бинарей
            cidrs = [
                "52.85.49.51/32",
                "52.85.49.120/32",
                "52.85.49.31/32",
                "52.85.49.101/32",
            ]
            rules = []
        },
        {
            name = "cloudflare/cdn03.quay.io.cdn.cloudflare.net" # Хранилище бинарей
            cidrs = [
                "172.64.150.58/32",
                "104.18.37.198/32",
            ]
            rules = []
        },
        {
            name = "cloudflare/production.cloudflare.docker.com" # Хранилище бинарей
            cidrs = [
                "104.18.121.25/32",
                "104.18.124.25/32",
                "104.18.123.25/32",
                "104.18.122.25/32",
                "104.18.125.25/32",
            ]
            rules = []
        },
        {
            name = "docker/registry-1.docker.io" # Хранилище бинарей
            cidrs = [
                "34.194.164.123/32",
                "18.215.138.58/32",
                "52.1.184.176/32",

            ]
            rules = []
        },
        {
            name = "world/github.com"
            cidrs = [
                "140.82.121.3/32",
                "140.82.121.4/32",
            ]
            rules = []
        },
        {
            name = "world/objects.githubusercontent.com"
            cidrs = [
                "185.199.109.133/32",
                "185.199.108.133/32",
                "185.199.111.133/32",
                "185.199.110.133/32",
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
            name = "deckhouse/registry"
            cidrs = [
                "77.223.120.232/32",
                "46.148.230.218/32",
                "46.4.145.194/32"
            ]
            rules = []
        },
        {
            name = "yandex/api"
            cidrs = [
                "217.28.237.103/32",
                "213.180.204.240/32",
                "213.180.193.8/32",
                "213.180.193.243/32",
                "84.201.181.26/32",
                "84.201.181.184/32",
                "84.201.168.69/32",
                "84.201.168.170/32",
                "84.201.151.137/32",
                "84.201.148.148/32",
                "84.201.144.177/32",
                "51.250.33.235/32",
            ]
            rules = []
        },
        {
            name = "world"
            cidrs = [
                "176.0.0.0/8",
                "198.0.0.0/8",
            ]
            rules = [
                {
                    sg_to  = "kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}/masters"
                    access = {
                        tcp = [
                            {
                                description = "access from world to kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} by ssh"
                                ports_to    = [
                                    22,
                                    6443,
                                ]
                            },
                            # {
                            #     description = "access from world to kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} by ssh"
                            #     ports_from = [
                            #         5050
                            #     ]
                            #     ports_to    = [
                            #         8080,
                            #     ]
                            # },
                            # {
                            #     description = "access from world to kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} by ssh"
                            #     ports_from = [
                            #         5051
                            #     ]
                            #     ports_to    = [
                            #         6443,
                            #     ]
                            # },
                        ]
                    }
                },
            ]
        }
    ]
}
