## Установка сервера БД ##

  1. Скачайте сервер базы данных: http://sourceforge.net/projects/firebird/files/firebird-win32/1.5.6-Release/Firebird-1.5.6.5026-0-Win32.exe/download
  1. Запустите скаченный файл установки Firebird-1.5.6.5026-0-Win32.exe (Везде оставляте установки по умолчанию, в качестве пути инсталяции выберете папку c:/program files/firebird)

## Установка Java ##

  1. Скачайте Java http://www.oracle.com/technetwork/java/javase/downloads/jdk-6u26-download-400750.html

## Установка веб сервера ##

  1. Скачайте веб сервер: http://tomcat.apache.org/download-60.cgi, если Вы незнаете какой имеено ставить, просто скачайте http://apache.cp.if.ua/tomcat/tomcat-6/v6.0.32/bin/apache-tomcat-6.0.32.exe
  1. Запустите файл установки apache-tomcat-6.0.32.exe
    * на панели что устанавливать выберете Service Startup пункт в Tomcat
    * в качестве пути инсталяции выбирете c:/program files/tomcat

## Установка приложения ##

  1. Скачайте приложение: http://code.google.com/p/goodmanager/downloads/detail?name=goodmanager.zip&can=2
  1. Зайдите Пуск / Панель управления / Администрирование / Службы и остановите службу Tomcat
  1. Очистите папку c:/program files/tomcat/webapps
  1. Розархивируйте программу в папку c:/program files/tomcat/webapps/ROOT
  1. New! Скачайте начальную базу данных: http://code.google.com/p/goodmanager/downloads/detail?name=goodmanager-db.zip&can=2
  1. New! Разархивируйте ее в файл, например: c:/program files/tomcat/goodmanagerdb.gdb
  1. New! Укажите путь к базе данных в настройках приложения
    * Откройте в Блокноте файл: c:/program files/tomcat/webapps/ROOT/WEB-INF/web.xml
    * New! Найдите строку: databaseurl
    * New! Далее вместо примера пути: c:/artem/work/goodmanager/web/WEB-INF/manager.gdb укажите: c:/program files/tomcat/goodmanagerdb.gdb
  1. Зайдите Пуск / Панель управления / Администрирование / Службы и запустите службу Tomcat
  1. New! Откройте браузер, например Internet Explorer и введите http://localhost:8080
  1. New! Вы увидете окно логина программы, введите логин: admin, пароль: 1 (это администратор по умолчанию)
  1. New! Нажмите на окрывшейся странице ссылку "Права" и добавьте нужных пользователей!