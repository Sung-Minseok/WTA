provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "example" {
  ami     = "ami-035233c9da2fabf52"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}
