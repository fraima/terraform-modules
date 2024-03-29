
locals {

  ssl = {
    global-args = {
      root-ca-args = {
        mount = {
          default_lease_ttl_seconds        = 321408000
          max_lease_ttl_seconds            = 321408000
          mount_type                       = "pki"
          description                      = "default description"
          allowed_managed_keys             = []
          audit_non_hmac_request_keys      = []
          audit_non_hmac_response_keys     = []
          options                          = {}
          external_entropy_access          = false
          seal_wrap                        = false
          local                            = false
        }
        ttl                                = 321408000
        key_bits                           = 4096
        max_path_length                    = -1
        description                        = "default description"
        ou                                 = ""
        organization                       = ""
        country                            = ""
        locality                           = "" 
        province                           = ""
        street_address                     = ""
        postal_code                        = ""
        permitted_dns_domains              = ""
        alt_names                          = []
        ip_sans                            = []
        uri_sans                           = []
        other_sans                         = []
        add_basic_constraints              = false
        exclude_cn_from_sans               = false
        type                               = "internal"
        format                             = "pem"
        private_key_format                 = "der"
        key_type                           = "rsa"

      }
      intermediate-ca-args = {
        mount = {
          default_lease_ttl_seconds        = 321408000
          max_lease_ttl_seconds            = 321408000
          mount_type                       = "pki"
          description                      = "default description"
          allowed_managed_keys             = []
          audit_non_hmac_request_keys      = []
          audit_non_hmac_response_keys     = []
          options                          = {}
          external_entropy_access          = false
          seal_wrap                        = false
          local                            = false
        }
        sign = {
          revoke                           = false
        }
        description                        = "default description"
        ou                                 = ""
        organization                       = ""
        country                            = ""
        locality                           = "" 
        province                           = ""
        street_address                     = ""
        postal_code                        = ""
        alt_names                          = []
        ip_sans                            = []
        uri_sans                           = []
        other_sans                         = []
        add_basic_constraints              = false
        exclude_cn_from_sans               = false
        type                               = "internal"
        format                             = "pem"
        private_key_format                 = "der"
        key_type                           = "rsa"
        key_bits                           = 4096
        
      }
      issuer-args = {
        allow_any_name                     = false
        allow_bare_domains                 = false
        allow_glob_domains                 = false
        allow_subdomains                   = false
        allowed_domains_template           = false
        basic_constraints_valid_for_non_ca = false
        code_signing_flag                  = false
        email_protection_flag              = false
        enforce_hostnames                  = false
        generate_lease                     = false
        allow_ip_sans                      = false
        allow_localhost                    = false
        client_flag                        = false
        server_flag                        = false
        no_store                           = false
        require_cn                         = false
        use_csr_common_name                = false
        ttl                                = 31540000
        key_bits                           = 4096
        key_type                           = "rsa"
        key_usage                          = []
        organization                       = []
        country                            = []
        locality                           = []
        ou                                 = []
        postal_code                        = []
        province                           = []
        street_address                     = []
        allowed_domains                    = []
        allowed_other_sans                 = []
        allowed_serial_numbers             = []
        allowed_uri_sans                   = []
        ext_key_usage                      = []
      }
      key-keeper-args = {
        spec = {
          subject = {
            commonName         = ""
            country            = ""
            localite           = ""
            organization       = ""
            organizationalUnit = ""
            province           = ""
            postalCode         = ""
            streetAddress      = ""
            serialNumber       = ""
          }
          privateKey = {
            algorithm = "RSA"
            encoding  = "PKCS1"
            size      = 4096
          }
          ttl         = "10m"
          ipAddresses = {}
          hostnames   = []
          usages      = []
        }
        renewBefore = "7m"
        trigger     = []
        withUpdate  = true

      }
    },
    intermediate = {
      kubernetes-ca = {
        labels = {
          instance-master = true
          instance-worker = true
          static-pod-kube-apiserver-args = {
            client-ca-file = "cert-public-arg"
          }
          static-pod-kube-controller-manager-args = {
            client-ca-file            = "cert-public-arg"
            root-ca-file              = "cert-public-arg"
            cluster-signing-cert-file = "cert-public-arg"
          }
        }
        default = {
          common_name               = "Kubernetes Intermediate CA",
          description               = "Kubernetes Intermediate CA"
          path                      = "${local.global_path.base_vault_path_pki}/kubernetes"
          root_path                 = "${local.global_path.root_vault_path_pki}"
          host_path                 = "${local.global_path.base_local_path_certs}/ca"
          organization              = "Kubernetes"
          sign = {
            revoke                  = true
          }
          key-keeper-args = {
            spec = {
              exportedKey           = false
              generate              = false
            }
          }
        }

        issuers = {
          cilium = {
            labels = {
              instance-master = true
              instance-worker = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ClientAuth",
                "ServerAuth"
              ]
              allowed_domains = [
                "*.cluster-2.hubble-grpc.cilium.io",
                "*.hubble-relay.cilium.io",
                "clustermesh-apiserver.cilium.io",
                "*.mesh.cilium.io",
                "remote",
                "root"
              ]
              client_flag         = true
              server_flag         = true
              allow_ip_sans       = true
              allow_localhost     = true
              allow_bare_domains  = true
              use_csr_common_name = true
              
            }
            certificates = {
              hubble-server-certs = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "*.cluster-2.hubble-grpc.cilium.io"
                    }
                    hostnames = [
                      "*.cluster-2.hubble-grpc.cilium.io",
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                    }
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/cilium"
                }
              },
              hubble-relay-client-certs = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "*.hubble-relay.cilium.io"
                    }
                    hostnames = [
                      "*.hubble-relay.cilium.io",
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                    }
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/cilium"
                }
              },
              clustermesh-apiserver-server-cert = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "clustermesh-apiserver.cilium.io"
                    }
                    hostnames = [
                      "clustermesh-apiserver.cilium.io",
                      "*.mesh.cilium.io",
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                    }
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/cilium"
                }
              }
              clustermesh-apiserver-remote-cert = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "remote"
                    }
                    hostnames = [
                      "remote",
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                    }
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/cilium"
                }
              }
              clustermesh-apiserver-admin-cert = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "root"
                    }
                    hostnames = [
                      "root",
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                    }
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/cilium"
                }
              }
            }
          },
          bootstrappers-client = {
            labels = {
              instance-worker = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ClientAuth"
              ]
              allowed_domains = [
                "custom:bootstrappers:*"
              ]
              organization = [
                "system:bootstrappers"
              ]
              client_flag         = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              bootstrappers-client = {
                labels = {
                  instance-worker = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonNamePrefix = "custom:bootstrappers"
                      organization = [
                        "system:bootstrappers"
                      ]
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kubelet"
                }
              }
            }
          },
          kube-controller-manager-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ClientAuth"
              ]
              allowed_domains = [
                "system:kube-controller-manager"
              ]
              client_flag         = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              kube-controller-manager-client = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "system:kube-controller-manager"
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kube-controller-manager"
                }
              }

            }
          },
          kube-controller-manager-server = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ServerAuth"
              ]
              allowed_domains = [
                "localhost",
                "kube-controller-manager.default",
                "kube-controller-manager.default.svc",
                "kube-controller-manager.default.svc.cluster",
                "kube-controller-manager.default.svc.cluster.local",
                "custom:kube-controller-manager"
              ]
              server_flag         = true
              allow_ip_sans       = true
              allow_localhost     = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              kube-controller-manager-server = {
                labels = {
                  instance-master = true
                  static-pod-kube-controller-manager-args = {
                    tls-cert-file        = "cert-public-arg"
                    tls-private-key-file = "cert-private-arg"
                  }
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "custom:kube-controller-manager"
                    }
                    usages = [
                      "server auth",
                    ]
                    hostnames = [
                      "localhost",
                      "kube-controller-manager.default",
                      "kube-controller-manager.default.svc",
                      "kube-controller-manager.default.svc.cluster",
                      "kube-controller-manager.default.svc.cluster.local",
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                    }
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kube-controller-manager"
                }
              }

            }
          },
          kube-apiserver-kubelet-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ClientAuth"
              ]
              allowed_domains = [
                "custom:kube-apiserver-kubelet-client",
              ]
              organization = [
                "system:masters"
              ]
              client_flag         = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              kube-apiserver-kubelet-client = {
                labels = {
                  instance-master = true
                  static-pod-kube-apiserver-args = {
                    kubelet-client-certificate = "cert-public-arg"
                    kubelet-client-key         = "cert-private-arg"
                  }
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "custom:kube-apiserver-kubelet-client",
                      organizationalUnit = [
                        "system:masters"
                      ]
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kube-apiserver"
                }
              }
            }
          },
          kubeadm-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ClientAuth"
              ]
              allowed_domains = [
                "custom:kubeadm-client",
              ]
              organization = [
                "system:masters"
              ]

              client_flag         = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              kubeadm-client = {
                labels = {
                  instance-master = true
                  # static-pod-kube-apiserver-args = {
                  #   kubelet-client-certificate   = "cert-public-arg"
                  #   kubelet-client-key           = "cert-private-arg"
                  # }
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "custom:kubeadm-client",
                      organizationalUnit = [
                        "system:masters"
                      ]
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kube-apiserver"
                }
              }
            }
          },
          kube-apiserver-cluster-admin-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ClientAuth"
              ]
              allowed_domains = [
                "custom:terraform-kubeconfig",
              ]
              organization = [
                "system:masters"
              ]
              client_flag         = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              # kube-apiserver-cluster-admin-client = {
              #   labels = {
              #     instance-master = true
              #     # static-pod-kube-apiserver-args = {
              #     #   kubelet-client-certificate   = "cert-public-arg"
              #     #   kubelet-client-key           = "cert-private-arg"
              #     # }
              #   }
              #   key-keeper-args = {
              #     spec = {
              #       subject = {
              #         commonName = "custom:terraform-kubeconfig",
              #         organizationalUnit = [
              #           "system:masters"
              #           ]
              #       }
              #       usages = [
              #         "client auth"
              #       ]
              #     }
              #     host_path = "${local.global_path.base_local_path_certs}/certs/kube-apiserver"
              #   }
              # }
            }
          },
          kube-apiserver = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ServerAuth"
              ]
              allowed_domains = [
                "localhost",
                "kubernetes",
                "kubernetes.default",
                "kubernetes.default.svc",
                "kubernetes.default.svc.cluster",
                "kubernetes.default.svc.cluster.local",
                "custom:kube-apiserver",
                local.k8s-addresses.kube_apiserver_lb_fqdn,
                local.k8s-addresses.kube_apiserver_lb_fqdn_local
              ]
              server_flag         = true
              allow_ip_sans       = true
              allow_localhost     = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              kube-apiserver = {
                labels = {
                  instance-master = true
                  static-pod-kube-apiserver-args = {
                    tls-cert-file        = "cert-public-arg"
                    tls-private-key-file = "cert-private-arg"
                  }
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "custom:kube-apiserver"
                    }
                    usages = [
                      "server auth",
                    ]
                    hostnames = [
                      "localhost",
                      "kubernetes",
                      "kubernetes.default",
                      "kubernetes.default.svc",
                      "kubernetes.default.svc.cluster",
                      "kubernetes.default.svc.cluster.local",
                      local.k8s-addresses.kube_apiserver_lb_fqdn,
                      local.k8s-addresses.kube_apiserver_lb_fqdn_local
                    ]
                    ipAddresses = {
                      static = [
                        local.k8s-addresses.local_api_address
                      ]
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                      dnsLookup = [
                        "${local.k8s-addresses.kube_apiserver_lb_fqdn}"
                      ]
                    }
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kube-apiserver"
                }
              }
            }
          },
          kube-scheduler-server = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ServerAuth"
              ]
              allowed_domains = [
                "localhost",
                "kube-scheduler.default",
                "kube-scheduler.default.svc",
                "kube-scheduler.default.svc.cluster",
                "kube-scheduler.default.svc.cluster.local",
                "custom:kube-scheduler"
              ]
              server_flag         = true
              allow_ip_sans       = true
              allow_localhost     = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              kube-scheduler-server = {
                labels = {
                  instance-master = true
                  static-pod-kube-scheduler-args = {
                    tls-cert-file        = "cert-public-arg"
                    tls-private-key-file = "cert-private-arg"
                  }
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "custom:kube-scheduler"
                    }
                    usages = [
                      "server auth",
                    ]
                    hostnames = [
                      "localhost",
                      "kube-scheduler.default",
                      "kube-scheduler.default.svc",
                      "kube-scheduler.default.svc.cluster",
                      "kube-scheduler.default.svc.cluster.local",
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                    }
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kube-scheduler"
                }
              }
            }
          },
          kube-scheduler-client = {
            labels = {
              instance-master = true
            }
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ClientAuth"
              ]
              allowed_domains = [
                "system:kube-scheduler"
              ]
              client_flag         = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              kube-scheduler-client = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "system:kube-scheduler"
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kube-scheduler"
                }
              }
            }
          },
          kubelet-peer-k8s-certmanager = {
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ServerAuth",
                "ClientAuth"
              ]
              key_bits = 0
              key_type = "any"
              allowed_domains = [
                "localhost",
                "*.${local.cluster_metadata.cluster_name}.${local.cluster_metadata.base_domain}",
                "system:node:*",
                "worker-*",
                "master-${local.k8s-addresses.extra_cluster_name}-1",
                "master-${local.k8s-addresses.extra_cluster_name}-2",
                "master-${local.k8s-addresses.extra_cluster_name}-3",
                "*"
              ]
              organization = [
                "system:nodes",
              ]
              server_flag         = true
              client_flag         = true
              allow_ip_sans       = true
              allow_localhost     = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {}
          }
          kubelet-server = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ServerAuth"
              ]
              allowed_domains = [
                "localhost",
                local.k8s-addresses.wildcard_base_cluster_fqdn,
                "system:node:*",
                "master-${local.k8s-addresses.extra_cluster_name}-1",
                "master-${local.k8s-addresses.extra_cluster_name}-2",
                "master-${local.k8s-addresses.extra_cluster_name}-3",
                "worker-*" # КОСТЫЛЬ
              ]
              organization = [
                "system:nodes",
                "system:authenticated"
              ]
              allow_glob_domains  = true
              allow_bare_domains  = true
              server_flag         = true
              allow_ip_sans       = true
              allow_localhost     = true
              use_csr_common_name = true
            }
            certificates = {
              kubelet-server = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonNamePrefix = "system:node"
                      organizations = [
                        "system:nodes"
                      ]
                    }
                    usages = [
                      "server auth",
                    ]
                    hostnames = [
                      "localhost",
                      "$HOSTNAME"
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                      dnsLookup = []
                    }
                    # ttl = "200h"
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kubelet"
                  # renewBefore   = "100h"
                }
              }
            }
          }
          kubelet-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ClientAuth"
              ]
              allowed_domains = [
                "system:node:*",
              ]
              organization = [
                "system:nodes",
              ]
              client_flag         = true
              allow_glob_domains  = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              kubelet-client = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonNamePrefix = "system:node"
                      organization = [
                        "system:nodes"
                      ]
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kubelet"
                }
              }
            }
          },
        }
      }
      etcd-ca = {
        labels = {
          instance-master = true
          static-pod-etcd-args = {
            peer-trusted-ca-file = "cert-public-arg"
            trusted-ca-file      = "cert-public-arg"
          }
          static-pod-kube-apiserver-args = {
            etcd-cafile = "cert-public-arg"
          }
        }
        default = {
          common_name               = "ETCD Intermediate CA",
          description               = "ETCD Intermediate CA"
          path                      = "${local.global_path.base_vault_path_pki}/etcd"
          root_path                 = "${local.global_path.root_vault_path_pki}"
          host_path                 = "${local.global_path.base_local_path_certs}/ca"
          organization              = "Kubernetes"

          sign = {
            revoke                  = true
          }
          key-keeper-args = {
            spec = {
              exportedKey           = false
              generate              = false
            }
          }
        }


        issuers = {
          etcd-server = {
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ServerAuth"
              ]
              allowed_domains = [
                "system:etcd-server",
                "localhost",
                "*.${local.cluster_metadata.cluster_name}.${local.cluster_metadata.base_domain}",
                "custom:etcd-server"
              ]
              server_flag         = true
              allow_ip_sans       = true
              allow_localhost     = true
              allow_glob_domains  = true
              allow_bare_domains  = true
              use_csr_common_name = true

            }
            certificates = {
            }
          },
          etcd-peer = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ServerAuth",
                "ClientAuth"
              ]
              allowed_domains = [
                "system:etcd-peer",
                "system:etcd-server",
                "localhost",
                "custom:etcd-peer",
                "custom:etcd-server",
                local.k8s-addresses.wildcard_base_cluster_fqdn,
                "master-${local.k8s-addresses.extra_cluster_name}-1",
                "master-${local.k8s-addresses.extra_cluster_name}-2",
                "master-${local.k8s-addresses.extra_cluster_name}-3"
              ]
              client_flag         = true
              server_flag         = true
              allow_ip_sans       = true
              allow_localhost     = true
              allow_glob_domains  = true
              allow_bare_domains  = true
            }
            certificates = {
              etcd-server = {
                labels = {
                  instance-master = true
                  static-pod-etcd-args = {
                    cert-file = "cert-public-arg"
                    key-file  = "cert-private-arg"
                  }
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "system:etcd-server"
                    }
                    usages = [
                      "server auth",
                      "client auth"
                    ]
                    hostnames = [
                      "localhost",
                      "$HOSTNAME"
                    ]
                    ipAddresses = {
                      static = [
                        "127.0.1.1"
                      ]
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                      dnsLookup = []
                    }
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/etcd"
                }
              }
              etcd-peer = {
                labels = {
                  instance-master = true
                  static-pod-etcd-args = {
                    peer-cert-file = "cert-public-arg"
                    peer-key-file  = "cert-private-arg"
                  }
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "system:etcd-peer"
                    }
                    usages = [
                      "server auth",
                      "client auth"
                    ]
                    hostnames = [
                      "localhost",
                      "$HOSTNAME"
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                      dnsLookup = []
                    }
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/etcd"
                }
              }
            }
          },
          etcd-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ClientAuth"
              ]
              allowed_domains = [
                "system:kube-apiserver-etcd-client",
                "system:etcd-healthcheck-client",
                "custom:etcd-client"
              ]
              client_flag         = true
              allow_glob_domains  = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              kube-apiserver-etcd-client = {
                labels = {
                  instance-master = true
                  static-pod-kube-apiserver-args = {
                    etcd-certfile = "cert-public-arg"
                    etcd-keyfile  = "cert-private-arg"
                  }
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "system:kube-apiserver-etcd-client"
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kube-apiserver"
                }
              }
            }
          },
        }
      }
      front-proxy-ca = {
        labels = {
          instance-master = true
          static-pod-kube-apiserver-args = {
            requestheader-client-ca-file = "cert-public-arg"
          }
          static-pod-kube-controller-manager-args = {
            requestheader-client-ca-file = "cert-public-arg"
          }
        }

        default = {
          common_name               = "Front-proxy Intermediate CA",
          description               = "Front-proxy Intermediate CA"
          path                      = "${local.global_path.base_vault_path_pki}/front-proxy"
          root_path                 = "${local.global_path.root_vault_path_pki}"
          host_path                 = "${local.global_path.base_local_path_certs}/ca"
          organization              = "Kubernetes"

          sign = {
            revoke                  = true
          }
          key-keeper-args = {
            spec = {
              exportedKey           = false
              generate              = false
            }
          }
        }

        issuers = {
          front-proxy-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              key_usage = [
                "DigitalSignature",
                "KeyAgreement",
                "KeyEncipherment",
                "ClientAuth"
              ]
              allowed_domains = [
                "system:kube-apiserver-front-proxy-client",
                "custom:kube-apiserver-front-proxy-client"
              ]
              client_flag         = true
              allow_bare_domains  = true
              use_csr_common_name = true
            }
            certificates = {
              front-proxy-client = {
                labels = {
                  instance-master = true
                  static-pod-kube-apiserver-args = {
                    proxy-client-cert-file = "cert-public-arg"
                    proxy-client-key-file  = "cert-private-arg"
                  }
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "custom:kube-apiserver-front-proxy-client"
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.global_path.base_local_path_certs}/certs/kube-apiserver"
                }
              }
            }
          },
        }
      }
    }
    root_ca = {
      # root = {
      #   CN          = "root",
      #   description = "root-ca"
      #   path        = "${local.global_path.root_vault_path_pki}"
      #   root_path   = "${local.global_path.root_vault_path_pki}"
      #   common_name = "Kubernetes Root CA"
      #   type        = "internal"
      #   default_lease_ttl_seconds = 321408000
      #   max_lease_ttl_seconds     = 321408000
      # }
    }
    external_intermediate = {
      oidc-ca = {
        labels = {
          instance-master = true
        }

        default = {
          description = "OIDC CA"
          path        = "pki-root"

          sign = {
            revoke                  = true
          }
          key-keeper-args = {
            spec = {
              exportedKey           = false
              generate              = false
            }
          }
          host_path   = "${local.global_path.base_local_path_certs}/ca"

        }

      }
    }
  }

  secrets = {
    kube-apiserver-sa = {
      labels = {
        instance-master = true
        static-pod-kube-controller-manager-args = {
          service-account-private-key-file = "cert-private-arg"
        }
      }
      path = local.global_path.base_vault_path_kv
      keys = {
        public = {
          host_path = "${local.global_path.base_local_path_certs}/certs/kube-apiserver/kube-apiserver-sa.pub"
        }
        private = {
          host_path = "${local.global_path.base_local_path_certs}/certs/kube-apiserver/kube-apiserver-sa.pem"
        }
      }
    }
  }
}
