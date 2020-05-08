output "kops_iam_user_name" {
  description = "The user's name"
  value       = module.iam_user.this_iam_user_name
}

output "kops_iam_user_unique_id" {
  description = "The unique ID assigned by AWS"
  value       = module.iam_user.this_iam_user_unique_id
}

output "kops_iam_access_key_secret" {
  description = "The access key secret"
  value       = module.iam_user.this_iam_access_key_secret
}

output "kops_iam_access_key_id" {
  description = "The access key ID"
  value       = module.iam_user.this_iam_access_key_id
}
