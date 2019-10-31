##### Содержание
[Домашня работа №2](#HW2)    
[Домашня работа №3](#HW3)    
[Домашня работа №4](#HW4)   
[Домашня работа №5](#HW5)   
[Домашня работа №6](#HW6)        
[Домашня работа №7](#HW7)  
[Домашня работа №8](#HW8)
[Домашня работа №9](#HW9)  
<a name="HW2"></a>
## Примечание к ДЗ№2
1. Travis
    - При установке дополнительно требуются пакеты: gcc, make, ruby-dev (Description: Ubuntu 18.04.3 LTS)
    - Не путать глобальный токен и токен для интеграции
2. Ошибки
    - Не присоеденился к репозиторию компании
    - Пытался использовать основной канал slack вместо тестового
3. Проверил математические операции в тестах
4. Изучал разметку - Markdown Syntax.

<a name="HW3"></a>
## Примечание к ДЗ№3

1. Виртуальные машины
   - google переносы в ключе (pub) воспринимает, как начало нового ключа
2. ssh (Домашнее задание)
   - Для коннекта к host bastion командой вида ssh bastion
     1. нужно создать(если еще не создан) файл конфига клиетна ssh (~/.ssh/config)
     2. добавить секцию конфигурации хоста  
        ```
        Host {ALIAS NAME}
	    HostName {IP}
	    User {USER}
	    IdentityFile ~/.ssh/{KEY}
        ```
   - Для конекта к машине через bstion хост используем следующую строку   
     `ssh -i ~/.ssh/{KEY} -t -A {USER}@{IP} ssh {USER}@{ip}`
   - Конфигурируем  доступ через ALIAS
     1. добваить секцию конфигурации хоста
        ```
	    Host {ALIAS NAME}
		HostName IP
		User {USER}
		IdentityFile ~/.ssh/{KEY}
		RequestTTY force
		RemoteCommand ssh {ip}
		ForwardAgent yes
        ```
3. Продолжаем изучать git
   - Удаление удаленной ветки репозитория
     `git push origin :cloud-bastion`

4. Данные серверов
```
VPN_URL = https://vpn-otus.nt33.ru/
bastion_URL = vpn-otus.nt33.ru

bastion_IP = 34.90.19.140

someinternalhost_IP = 10.164.0.4

```
5. Добавил конфигурационные файлы в git для памяти (nginx, pritunl, config_ssh)

<a name="HW4"></a>
## Примечание к ДЗ№4
1. Создание/Удаление VM в gcloud (Пример скриптов: CreateVM-startup.sh,DeleteVM.sh,create_firewall_rules.sh)
2. Написан starrup-script.sh(добавил nginx для проксирования запросов с 80 порта на 9292)
3. Порт 9292 тоже открыт, но ....
```
testapp_IP = 34.90.19.140
testapp_port = 80
```

<a name="HW5"></a>
## Примечание к ДЗ№5
Создан образ с помощью packer.
В него вошли следующие пакеты: Nginx(реверспрокси), ruby, puma.
###Было исправлено из предыдущего задания:
- unit для puma server
- добавлен по умолчанию ssl сертификат для https
### Было изучено работа
- packer (создания образа для виртуалок)
- практика по работе c gcloud
- написание shell скриптов
###Проверка
```
PUMA_URL = https://otus.nt33.ru
PUMA_IP = 34.90.19.140
PUMA_PORT = 8080 (Оставил на всякий пожарный, можно убрать tag c виртуалки)
```
<a name="HW6"></a>
## План ДЗ№6
 - Делаем образы для packer (3h)
 1. БД (mongodb)
 2. Puma-server
 3. Nginx (Проксирование и ssl)
 4. Мониторинг *
 - Разворачиваем образы руками для проверки взаимодействия всех компонентов (1h)
 - Пишем сценарии разворачивания для terraform (8h)
 - Производим подготовку окружения для сдачи ДЗ№6.

### Что сделано:
 - Сделал балансировку нагрузки через nginx - otus.nt33.ru
 - Сделал балансировку нагрузки через балансировщик гугла - 35.201.95.126
 - Сделал два скрипта на python один для мониторинга ресурсов - https://otus.nt33.ru/monitor/cgi-bin/monitor.py  (пинги до ресов, в нижней части доступ по порту к хосту. Пример скрипта - terraform/files/monitor.py). Автоматичская генерация части nginx (upstream) - terraform/files/nginx.py
 - Делать unit для puma не стал, он остался из предыдущего задания - terraform/files/puma.servece
 - Сейчас создается 6 машин: nginx(1),puma-x(4),mongo(1)

 - Проблемы, которые я должен был встретить по методичке, меня обошли стороной.


### Примечание к ДЗ№6
Как получить доступ через бастион хост
```
  connection {
      type         = "ssh"
      user         = "ntikhomirov"
      agent        = true
      host         = "puma"
      port         = 22
      bastion_host = "otus.nt33.ru"
      bastion_user = "ntikhomirov"
      bastion_port = 22
      private_key = "${file(var.private_key_path)}"
  }
```
<a name="HW7"></a>
## План ДЗ№7
Развернул jenkins по адресу - https://otus.nt33.ru/jenkins (надоело выполнять команды руками и так меньше привязан к рабочему месту)

сделал 4 jobs (3 - Packer, 1 - terraform)

2 ЗАДАНИЕ СО * не особо понял, сделал как "додумал" сам.

connection {
type = "ssh"
user = "tihomirovnv"
agent = false
host = "puma-${var.stand}-${count.index}"
private_key = "${file(var.private_key_path)}"
}

provisioner "remote-exec" {
inline = [
"sudo /bin/sed -i 's/mongo-db/mongo-${var.stand}/g' /home/tihomirovnv/app/reddit/app.rb",
"sudo systemctl restart otus"
]
}
}

Так как имя хоста за ранее известно (mongo-${var.stand}), то зачем его где-то в переменную закидывать?
Возможно во втором задание подразумевалось использования бастион хоста, так как jenkins находится в той же системе, то его значение отваливается. (пример использования оставлял в прошлом задании)

Встретил веселую проблему, нехватку квот на CPU (когда машин больше 12)

"Чудный" скрипт мониторинга оставил
https://otus.nt33.ru:4443/monitor/cgi-bin/monitor.py (остановил одну ноду, для проверки скрипта - puma-test-0 is down!)
https://otus.nt33.ru/monitor/cgi-bin/monitor.py

Формирования nginx части конфига происходит modulem terraform - nginx.
Скриптом - terraform\modules\nginx\files\nginx.py
передается префикс среды и количество нод app.
на выходе файл - upstream.conf

tihomirovnv@nginx-prod:~$ cat /etc/nginx/conf.d/upstream.conf
upstream puma_application {
server puma-prod-0:8080 max_fails=1 fail_timeout=10s;
}

Поправил юнит (добавил пользователя и группу) - packer\file\otus.service

<a name="HW8"></a>
## Примечание к ДЗ№8
- Привел в порядок jobs jenkins  (https://otus.nt33.ru/jenkins), перевел предыдыщие jobs на pipeline:groovy (ознакомиться можно тут ./jenkins/*)
- Развернул окружение ansible на хосте jenkins в облаке (все подготовил для дальнейшей работы, большой плюс - НЕТ торчащих хостов наружу!)
- Потренировался с запуском absible-playbook
- Создал несколько файлов инвентори (в том числе динамический для динамического создание - ./inventory.py)
- Создал простейший playbook: ping.yaml (ох уэ эта разметка yaml)
- Продолжаем изучать packer,terraform, ansible, python

<a name="HW9"></a>  
## Примечание к ДЗ№9  
