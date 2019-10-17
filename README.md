##### Содержание
[Домашня работа №2](#HW2)    
[Домашня работа №3](#HW3)    
[Домашня работа №4](#HW4)   
[Домашня работа №5](#HW5)   
[Домашня работа №6](#HW6)        

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
testapp_port = 9292
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
