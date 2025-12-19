resource "aws_instance" "poc_instance" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}