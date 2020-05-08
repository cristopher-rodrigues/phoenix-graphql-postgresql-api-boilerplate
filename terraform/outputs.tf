output "boilerplate_postgresql_string_connection" {
  value = "${module.boilerplate_postgresql_rds.this_db_instance_username}:${module.boilerplate_postgresql_rds.this_db_instance_password}@${module.boilerplate_postgresql_rds.this_db_instance_endpoint}/${var.environment}_${var.stage}"
  sensitive = true
}
