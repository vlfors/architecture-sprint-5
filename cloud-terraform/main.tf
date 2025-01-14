terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "y0__wgBEMy79BEYwd0TIL3hvYESpUtVAwoEYjICS41WR_CLRwCCr6w"       # OAuth-токен
  cloud_id  = "b1gqiqglm4ufhfk1qv4r"      # Cloud ID
  folder_id = "b1gtehka9t6eckfpqsfl"      # ID
  zone      = "ru-central1-a"             # Указание региона провайдера
  }

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "testvm" {
  name     = "test-vm-disk"
  type     = "network-ssd"
  zone     = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size     = 15
}

resource "yandex_compute_instance" "testvm" {
  name = "test-vm"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    disk_id = yandex_compute_disk.testvm.id
  }

  network_interface {
    subnet_id = "e9bnmlpj09m6d859r3i1"
    nat       = true
  }

  metadata = {
	 user-data = "${file("./meta.yml")}"
  }
}