/*  --- Блок конфигурации --- */
def image = [:]
image['nginx'] = 'ubuntu-nginx-ntikhomirov'
image['app'] = 'ubuntu-puma-ntikhomirov'
image['mongodb'] = 'ubuntu-mongodb-ntikhomirov'
def config = [:]
config['varfile'] = "/opt/secret/value.json"
config['nginx'] = "nginx.json"
config['mongodb'] = "db.json"
config['app'] = "app.json"


/*  --- Блок конфигурации --- */
/* Созданный для универсальности создания образов пакера (Nikolay Tikhomirov)

/*  --- Магия деплоя (функции) --- */
//Уничтожение образа
def deleteImage(image_name){

  echo 'Удаления образа - ' + image_name
  try {
    sh script: "gcloud compute images delete " + image_name + " --quiet"
  }catch(Exception e){
        echo 'Образ ' + image_name + " отсутствует в системе"
  }

}

//Создание образа
def createImage(config, image_name){
    echo "Создаем образ"
    sh script: "cd ${WORKSPACE}/packer/ \n /opt/packer/packer build --var-file=" + config['varfile'] + " " + config[image_name]
}

//Выкачиваем репозитория
def downloadRepo(){
git(
   url: 'https://github.com/Otus-DevOps-2019-08/ntikhomirov_infra.git',
   branch: env.branch
)
}

/*  --- Магия деплоя (функции) --- */


/*  --- Деплой --- */

stage('Подготовка'){
  //Добавляем
    node('master'){
      downloadRepo()
    }

  //Удаление образа
  if(env.DELETE.toBoolean() || env.CREATE.toBoolean()){
     node('master'){
      deleteImage(image[env.IMAGE])
     }
  }
}

stage('Создание'){
  if(env.CREATE.toBoolean()){
    node('master'){
      createImage(config,env.IMAGE)
    }
  }
}


/*  --- деплой --- */
