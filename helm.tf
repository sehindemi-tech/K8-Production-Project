resource "helm_release" "nginx" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  create_namespace = true
  namespace        = "nginx-ingress"
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  create_namespace = true
  namespace        = "cert-manager"

  # set {
  #   name  = "wait-for"
  #   value = module.cert_manager_irsa_role.iam_role_arn
  # }
  set {
    name  = "installCRDs"
    value = "true"
  }

  values = [
    "${file("helm-values/cert-manager.yml")}"
  ]
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "external-dns"

  create_namespace = true
  namespace        = "external-dns"

  set {
    name  = "wait-for"
    value = module.cert_manager_irsa_role.iam_role_arn
  }
  values = [
    "${file("helm-values/external-dns.yml")}"
  ]
}

resource "helm_release" "argocd_deploy" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.19.15"
  timeout    = "600"

  namespace        = "argo-cd"
  create_namespace = true

  values = [
    "${file("helm-values/argo-cd.yml")}"
  ]
}