locals {
  default_kube_apiserver_flags = {
    secure-port                         = "${local.kubernetes-ports.kube-apiserver-port}"
    event-ttl                           = "1h0m0s"
    kubernetes-service-node-port        = "0"
    master-service-namespace            = "default"
    max-connection-bytes-per-sec        = "0"
    max-requests-inflight               = "400"
    min-request-timeout                 = "1800"
    profiling                           = "false"
    feature-gates                       = "RotateKubeletServerCertificate=true"
    anonymous-auth                      = "true"
    audit-log-maxage                    = "30"
    audit-log-maxbackup                 = "10"
    audit-log-maxsize                   = "1000"
    audit-log-mode                      = "batch"
    enable-admission-plugins            = "NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota,AlwaysPullImages,NodeRestriction,PodSecurity"
    enable-bootstrap-token-auth         = "true"
    runtime-config                      = "api/all=true"
    enable-aggregator-routing           = "true"
    api-audiences                       = "konnectivity-server"
    requestheader-allowed-names         = "front-proxy-client"
    requestheader-extra-headers-prefix  = "X-Remote-Extra-"
    requestheader-group-headers         = "X-Remote-Group"
    requestheader-username-headers      = "X-Remote-User"
    allow-privileged                    = "true"
    authorization-mode                  = "Node,RBAC"
    service-account-issuer              = "https://kubernetes.default.svc.cluster.local"
    kubelet-preferred-address-types     = "InternalIP,ExternalIP,Hostname"
    kubelet-timeout                     = "5s"
    v                                   = "4"
    cloud-provider                      = "external"
    # oidc-client-id                      = "kubernetes-clusters"
    oidc-username-claim                 = "sub"
    oidc-groups-claim                   = "groups"
    oidc-username-prefix                = "-"
    # oidc-issuer-url                     = "https://auth.dobry-kot.ru/auth/realms/master"
  }
}