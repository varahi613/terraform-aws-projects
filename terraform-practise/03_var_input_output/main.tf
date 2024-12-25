
resource "local_file" "example1" {
  content  = "example1!"
  filename = "${path.module}/${var.filename_1}.txt"
  count = var.count_num
}

resource "local_file" "example2" {
  content  = "example2!"
  filename = "${path.module}/${var.filename_2}.txt"
}
resource "local_file" "example3" {
  content  = "example3!"
  filename = "${path.module}/${var.filename_3}.txt"
}
