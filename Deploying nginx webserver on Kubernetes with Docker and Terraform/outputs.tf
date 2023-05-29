output "webserver" {
  value = module.webserver.webserver.public_ip
}

output "webserver2" {
  value = module.webserver.webserver2.public_ip
 }