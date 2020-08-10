provider "aws" {
  region = var.region
}

resource "aws_instance" "jenkins" {
  ami               = var.amazon_linux
  instance_type     = var.instance_type_free
  availability_zone = var.availability_zone
  key_name          = "admin-key-oregon"
  vpc_security_group_ids = [aws_security_group.webserver.id]
 
  root_block_device {
    volume_size = "10"
}

  tags = {
    Name  = "Jenkins_linux by Terraform"
    Owner = "Oleh Kuryshko"
  }
}
resource "null_resource" jenkins {
  depends_on = ["aws_instance.jenkins"]
  connection {
    host        = "${aws_instance.jenkins.public_ip}"
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("./admin-key-oregon.pem")}"
  }
    provisioner "file" {
    source      = "./groovy/basic-security.groovy"
    destination = "/tmp/basic-security.groovy"
  }
    provisioner "file" {
    source      = "./.ssh/script.sh"
    destination = "/tmp/script.sh"
  }
 provisioner "remote-exec" {
    inline = [
      "chmod a+x /tmp/script.sh",
      "bash /tmp/script.sh"
    ]
  }
}

