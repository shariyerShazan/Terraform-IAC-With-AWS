# resource is a block
resource "local_file" "my_file" {
  filename = "automate.txt"
  content = "first automate content for devops"
}