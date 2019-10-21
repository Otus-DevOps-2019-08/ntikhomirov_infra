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

variable stand{
  description = "Вид создаваемой среды"
  default = "test"
}
