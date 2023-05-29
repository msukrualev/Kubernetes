output "webserver" {
    value = aws_instance.control
}

output "webserver2" {
    value = aws_instance.worker
}