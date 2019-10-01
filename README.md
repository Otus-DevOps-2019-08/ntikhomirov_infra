##### Содержание 
[Домашня работа №2](#HW2)    
[Домашня работа №3](#HW3)    



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
