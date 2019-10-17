variable project_id {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
variable private_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable user {
}

variable count_puma {
}

variable image_name {
}
