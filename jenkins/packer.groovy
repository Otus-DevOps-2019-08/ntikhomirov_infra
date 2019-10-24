/*  --- Блок конфигурации --- */
def image = [:]
image['nginx'] = 'ubuntu-nginx-ntikhomirov'
image['app'] = 'ubuntu-puma-ntikhomirov'
image['mongodb'] = 'ubuntu-mongodb-ntikhomirov'
def config = [:]
config['varfile'] = "/opt/secret/value.json"
config['nginx'] = "nginx.json"
config['mogodb'] = "db.json"
config['appфзз'] = "app.json"


/*  --- Блок конфигурации --- */
/* Созданный для универсальности создания образов пакера (Nikolay Tikhomirov)

/*  --- Магия деплоя (функции) --- */
//Уничтожение образа
def deleteImage(image_name){

  echo 'Удаления образа - ' + image_name
  try {
    sh script: "cd ./packer"
    sh script: "gcloud computer images delete " + image_name + " --quite"
  }catch(Exception e){
        echo 'Образ ' + image_name + " отсутствует в системе"
  }

}

//Создание образа
def createImage(config, image_name){
    echo "Создаем образ"
    sh script: "cd ./packer"
    sh script: "/opt/packer/packer build --var-file=" + config['varfile'] + " " + config[image_name]
}

/*  --- Магия деплоя (функции) --- */


/*  --- Деплой --- */

stage('Подготовка'){
  //Удаление образа
  if(env.DELETE.toBoolean() || env.CREATE.toBoolean()){
     deleteImage(image[env.IMAGE])
  }
}

stage('Создание'){
  if(env.CREATE.toBoolean()){
    createImage(config,env.IMAGE)
  }
}


/*  --- деплой --- */
