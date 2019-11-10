/*  --- Блок конфигурации --- */
def global = [:]
global['terraform'] = "/opt/terraform/terraform"
global['varfile'] = "/opt/secret/terraform.tfvars"
global['git-url'] = "https://github.com/Otus-DevOps-2019-08/ntikhomirov_infra.git"
global['branch'] = ""


/*  --- Блок конфигурации --- */

/* Созданный для универсальности создания окружения terraform (Nikolay Tikhomirov)

/*  --- Магия деплоя (функции) --- */
//Уничтожение структуры
def destroy(config, stand){
  echo 'Удаление окружения - ' + stand
  try {
    sh script: "cd ${WORKSPACE}/terraform/${stand}/ \n " + config['terraform'] + '  destroy -auto-approve -var-file=' + config['varfile']
  }catch(Exception e){
        echo "Окружение " + stand + " не может быть найдено или удалено!"
  }

}

//Запуск экземляра
def startVM(config, stand){
    echo "Создание и запуск экземляра"
    sh script: "cd ${WORKSPACE}/terraform/${stand}/ \n " + config['terraform'] + " init \n " +  config['terraform'] + " get -update \n " + config['terraform'] + " apply -auto-approve -var-file=" + config['varfile']
}

//Проверка экземляра
def validateVM(config, stand){
    echo "Проверка конфигурации экземляра"
    sh script: "cd ${WORKSPACE}/terraform/${stand}/ \n " + config['terraform'] + " init \n " + config['terraform'] +  " get -update \n " + config['terraform'] + " validate -var-file=" + config['varfile']
}

//Выкачиваем репозитория
def downloadRepo(config){
git(
   url: config['git-url'],
   branch: config['branch']
)
}

//Запуск конфигураци ansible
def start_ansible(stand){
  echo "Запуск конфигураци обновления mongo-db"
  sh script: "cd ${WORKSPACE}/ansible/ \n chmod +x ../ansible/environments/${stand}/inventory.py \n ansible-playbook playbooks/db.yml -i ../scripts/inventory.py"
  echo "Запуск конфигураци обновления Puma"
  sh script: "cd ${WORKSPACE}/ansible/ \n chmod +x ../ansible/environments/${stand}/inventory.py \n ansible-playbook playbooks/app.yml -i ../scripts/inventory.py"
  echo "Запуск конфигураци nginx"
  sh script: "cd ${WORKSPACE}/ansible/ \n chmod +x ../ansible/environments/${stand}/inventory.py \n ansible-playbook playbooks/proxy.yml -i ../scripts/inventory.py"
}

/*  --- Магия деплоя (функции) --- */


/*  --- Деплой --- */
global['branch'] = env.BRANCH

stage('Подготовка'){
  //Добавляем
    node('master'){
      downloadRepo(global)
      if(!env.DELETE.toBoolean()){
        validateVM(global, env.STAND)
      }

    }

  //Удаление удаление окружения
  if(env.DELETE.toBoolean() || env.CREATE.toBoolean()){
     node('master'){
       destroy(global, env.STAND)
     }
  }
}

stage('Создание и конфигурация'){
  if(env.CREATE.toBoolean()){
    node('master'){
      startVM(global,env.STAND)
      sleep(30)
      start_ansible(env.STAND)
    }
  }
}


/*  --- деплой --- */
