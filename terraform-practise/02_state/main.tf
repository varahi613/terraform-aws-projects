
resource "local_file" "example1" {
  content  = "example1!"
  filename = "${path.module}/example1.txt"
}

resource "local_file" "example2" {
  content  = "example2!"
  filename = "${path.module}/example2.txt"
}