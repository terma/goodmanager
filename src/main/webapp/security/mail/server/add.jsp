<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Добавление сервера - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <%--<%--%>
<!--//            final List<PageDetailError> errors =-->
<!--//                    (List<PageDetailError>) request.getAttribute("errors");-->
<!--//            EntityContact contact = (EntityContact) request.getAttribute("contact");-->
<!--//            if (contact == null) {-->
<!--//                contact = new EntityContact();-->
<!--//            }-->
        <%--%>--%>
        <form action="/security/mail/server/addresult.jsp" method="post">
            <login:input/>
            <p>
                <b>Сервер</b>
            </p>
            <p>
                Адрес сервера:<br>
                <input type="text" name="url" style="width: 80%">
            </p>
            <p>
                Логин на сервере:<br>
                <input type="text" name="login" style="width: 80%">
            </p>
            <p>
                Пароль на сервере:<br>
                <input type="password" name="password" style="width: 80%">
            </p>
            <p>
                Тип сервера:<br>
                <select name="type" style="vertical-align: middle; width: 80%">
                    <option value="inbox">Входящий (POP3 или IMAP4)</option>
                    <option value="outbox">Исходящий (SMTP)</option>
                </select>
            </p>
            <p>
                <input type="submit" name="" value="Создать">
            </p>
        </form>
    </body>
</html>