output "service_account" {
    value = kubernetes_service_account.tiller.metadata.0.name
}

output "namespace" {
    value = kubernetes_service_account.tiller.metadata.0.namespace
}