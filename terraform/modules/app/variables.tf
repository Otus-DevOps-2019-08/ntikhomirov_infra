#Наименования образа для разворачивания
variable image_name {
  description = "Name image"
}

#Регион
variable region{
  description = "Name Region"
}

#Указать путь до публичного ключа
variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

#Колличество установлемых инстантов
variable count_puma {
  description = "Колличество устанавливаемых инстантов"
  default = 1
}

#принадлежность к среде развертывания
variable stand {
 description = "Принадлежность к среде исполнения"
 default = "test"
}
