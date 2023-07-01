
# Поиск id сети и после ее запись в переменную data.openstack_networking_network_v2.network.id
data "openstack_networking_network_v2" "network" {
  name                    = "Default Network #14114"
}

# Поиск id плавающего ip и после ее запись в переменную data.openstack_networking_floatingip_v2.floatingip_1.id
data "openstack_networking_floatingip_v2" "floatingip_1" {
  address                 = var.external_ip
}

# Создание порта и привязка к созданой подсети
resource "openstack_networking_port_v2" "port_1" {
  name                    = "port_1"
  network_id              = data.openstack_networking_network_v2.network.id
  
  fixed_ip {
    subnet_id             = "d3983844-ee11-4b40-88f1-a947aad5d314"
    ip_address            = "192.168.2.22"
  }
}

# Импортирование существующего локального публичного ключа 
resource "openstack_compute_keypair_v2" "my-keypair" {
  name                    = "my-keypair"
  public_key              = var.public_key
}

# Создание инстанса с загрузочным диском
resource "openstack_compute_instance_v2" "instance_1" {
  name                    = "instance_1"
  flavor_name             = "ext_4096_p2_50gb"
  availability_zone       = "nova"
  admin_pass              = var.admin_pass
  key_pair                = "my-keypair"
  security_groups         = ["default"]

# Создание диска с которого будет загружаться инстанс и в качестве uuid мы указываем идентификатор image.id
  block_device {
    uuid                  = "f94da791-8a11-48df-8bd8-f39143db5877"
    source_type           = "image"
    volume_size           = 50
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true # если выставить параметр true, после удаления инстанса будет удален и диск.
  }
  
  network {
    port                  = "${openstack_networking_port_v2.port_1.id}"
  }
# Провижинг на Ansible который устанавливает опенстек клиент на сервере.  
  provisioner "local-exec" {
    command = "ansible-playbook playbook_run_docker.yml --ssh-common-args='-o StrictHostKeyChecking=no'"
  }

# Эта часть --ssh-common-args='-o StrictHostKeyChecking=no' дает возможность игнорировать
# Are you sure you want to continue connecting (yes/no/[fingerprint])?


}

# Создание форвардинга
resource "openstack_networking_portforwarding_v2" "portforwarding" {
  floatingip_id           = data.openstack_networking_floatingip_v2.floatingip_1.id
  internal_ip_address     = "192.168.2.22"
  external_port           = "51100"       # нестандартный порт ssh
  internal_port           = "22"          # стандартный порт ssh
  internal_port_id        = "${openstack_networking_port_v2.port_1.id}"
  protocol                = "tcp"
}

# Данные подключения к серверу по ssh ssh root@var.external_ip -p 51100


resource "openstack_networking_portforwarding_v2" "portforwarding2" {
  floatingip_id           = data.openstack_networking_floatingip_v2.floatingip_1.id
  internal_ip_address     = "192.168.2.22"
  external_port           = "5000"      
  internal_port           = "5000"    # Открываем порт для приложения Flask
  internal_port_id        = "${openstack_networking_port_v2.port_1.id}"
  protocol                = "tcp"
}


full_deploy.tf
