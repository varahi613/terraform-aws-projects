resource "local_file" "tf_example1" {
  filename = "${path.module}/example-${count.index}.txt"
  content = "i am good learner"
  count = 3
}
