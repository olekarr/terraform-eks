output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "EKS API server endpoint"
}

output "cluster_ca_base64" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "Base64 encoded CA data"
}

output "cluster_arn" {
  value       = aws_eks_cluster.this.arn
  description = "Cluster ARN"
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.this.arn
  description = "OIDC provider ARN for IRSA"
}