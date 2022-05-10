resource "null_resource" "tiller" {
  count = var.deploy_tiller == "true" ? 1 : 0

  triggers = {
    helm_version = var.helm_version
    cluster_name = var.cluster_name
    cluster_certificate_authority = var.cluster_certificate_authority
    cluster_config = var.cluster_config
  }

  
  # helm init
  provisioner "local-exec" {
    command = "chmod 755 ${path.module}/scripts/init_tiller.sh && ${path.module}/scripts/init_tiller.sh"
    environment = {
      CLUSTER_NAME                  = var.cluster_name
      HELM_VERSION                  = var.helm_version
      CLUSTER_CERTIFICATE_AUTHORITY = base64decode(var.cluster_certificate_authority)
      CLUSTER_CONFIG                = base64decode(var.cluster_config)
      SCRIPTS_PATH                  = "${path.module}/scripts"
    }
  }

  
  # helm reset
  provisioner "local-exec" {
    command = "chmod 755 ${path.module}/scripts/reset_tiller.sh && ${path.module}/scripts/reset_tiller.sh"
    environment = {
      CLUSTER_NAME                  = self.triggers.cluster_name
      HELM_VERSION                  = self.triggers.helm_version
      CLUSTER_CERTIFICATE_AUTHORITY = base64decode(self.triggers.cluster_certificate_authority)
      CLUSTER_CONFIG                = base64decode(self.triggers.cluster_config)
      SCRIPTS_PATH                  = "${path.module}/scripts"
    }
    when = destroy
  }
}

