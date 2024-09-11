provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  tags = {
    Name = "test-appstream-vpc"
  }
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "web" {
  name = "test-appstream-web"
  description = "Allows HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "appstream" {
  ami = "ami-0bde1eb2c18cb2abe"
  instance_type = "t3.medium"
  key_name = "test-appstream"
  security_groups = [aws_security_group.web.id]
  subnet_id = aws_subnet.my_subnet.id
}

resource "aws_appstream_fleet" "test_fleet" {
  name = "appstream_test_fleet"
  compute_capacity {
    desired_instances = 1
  }
  fleet_type                         = "ON_DEMAND"
  instance_type = "stream.standard.medium"
  image_name = "AppStream-WinServer2019-10-05-2022"
  idle_disconnect_timeout_in_seconds = 600
  max_user_duration_in_seconds       = 900
}

resource "aws_appstream_stack" "default" {
  name = "test-appstream-stack"
  storage_connectors {
    connector_type = "HOMEFOLDERS"
  }

  user_settings {
    action     = "CLIPBOARD_COPY_FROM_LOCAL_DEVICE"
    permission = "ENABLED"
  }
  user_settings {
    action     = "CLIPBOARD_COPY_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }
  user_settings {
    action     = "DOMAIN_PASSWORD_SIGNIN"
    permission = "ENABLED"
  }
  user_settings {
    action     = "DOMAIN_SMART_CARD_SIGNIN"
    permission = "DISABLED"
  }
  user_settings {
    action     = "FILE_DOWNLOAD"
    permission = "ENABLED"
  }
  user_settings {
    action     = "FILE_UPLOAD"
    permission = "ENABLED"
  }
  user_settings {
    action     = "PRINTING_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  application_settings {
    enabled        = true
    settings_group = "SettingsGroup"
  }
}

resource "aws_appstream_fleet_stack_association" "example" {
  fleet_name = aws_appstream_fleet.test_fleet.name
  stack_name = aws_appstream_stack.default.name
}

resource "aws_appstream_user" "default" {
  authentication_type = "USERPOOL"
  user_name           = "iniemem@clessence.com"
  first_name          = "Ehmee"
  last_name           = "Joseph"
}

resource "aws_appstream_user_stack_association" "test" {
  authentication_type = aws_appstream_user.default.authentication_type
  stack_name          = aws_appstream_stack.default.name
  user_name           = aws_appstream_user.default.user_name
}

resource "aws_appstream_image_builder" "test_builder" {
  name                           = "builder"
  image_name                     = "AppStream-WinServer2019-10-05-2022"
  instance_type                  = "stream.standard.medium"
}
