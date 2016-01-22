<%@ page import="ua.com.testes.manager.web.page.PageLoginError" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.util.Locale" %>
<%@ page import="ua.com.testes.manager.util.locale.UtilLocale" %>
<%@ page import="ua.com.testes.manager.web.servlet.LoginResultServlet" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Авторизация - Менджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            #loginhelp {display: none;}

        </style>
        <script type="text/javascript">

            function showLoginHelp() {
                document.getElementById("loginhelp").style.display = "block";
            }

            function focusLoginLogin() {
                if (document.getElementById("loginlogin")) {
                    document.getElementById("loginlogin").focus();
                }
            }    

        </script>
    </head>
    <body onload="focusLoginLogin()">
        <%
            final String login = request.getParameter("login");
            final String password = request.getParameter("password");
            final PageLoginError error = (PageLoginError) request.getAttribute("error");
            EntityUser user = null;
            if (session.getAttribute("userId") != null) {
                user = EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));
            }
        %>
        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="center" align="center">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <% if (user != null) { %>
                                <td>
                                    Вы уже авторизированы под пользователем
                                    <a href="mailto:<%= user.getEmail() %>"><%= user.getFio() %></a>,<br>
                                    перейдите на страницу <a href="/security/main.jsp">работы</a>
                                </td>
                            <% } else { %>
                                <td valign="top">
                                    <form action="/loginresult" method="post">
                                        <%
                                            String originalUrl = (String) request.getAttribute("originalUrl");
                                            if (originalUrl == null) {
                                                originalUrl = "/security/main.jsp";
                                            }
                                        %>
                                        <input type="hidden" name="originalUrl" value="<%= originalUrl %>">
                                        <% if (PageLoginError.NOT_CURRENT.equals(error)) { %>
                                            <p><b>Пожайлуста введите правильный логин или пароль!</b></p>
                                        <% } %>
                                        <% if (PageLoginError.BLOCK.equals(error)) { %>
                                            <p><b>Ваш пользователь заблокирован, наверно вы неверно набрали несколько<br>
                                            раз пароль, подождите некоторое время пока он будет разблокирован!</b></p>
                                        <% } %>
                                        Ваш логин (например: admin)<br>
                                        <input type="text" style="width: 200px" id="loginlogin" name="login" value="<%= login != null ? login : "" %>">
                                        <p>Пароль<br><input style="width: 200px" type="password" name="password" value="<%= password != null ? password : "" %>"></p>
                                        <p><input type="submit" value="Войти">
                                    </form>
                                    <%--<% if (FilterLoginNtlm.isUse()) { %>--%>
                                        <%--<p>Попробовать <a href="/security/main.jsp">автоматически</a></p>--%>
                                    <%--<% } %>--%>
                                    <% if (LoginResultServlet.getAnonymousUserId() != null) { %>
                                        <% final EntityUser anonymousUser = EntityManager.find(EntityUser.class, LoginResultServlet.getAnonymousUserId()); %>
                                        <% if (anonymousUser != null) { %>
                                            <p>Анонимный <a href="/security/main.jsp?login=<%= anonymousUser.getLogin() %>&password=<%= anonymousUser.getPassword() %>">вход</a></p>
                                        <% } %>
                                    <% } %>
                                    <p>Что это такое? Позвать <a href="javascript:showLoginHelp()">на помощь</a>!</p>
                                    <form action="/localesessionresult.jsp" method="post">
                                        <p>
                                            Предпочитаемый язык<br>
                                            <select name="localesession" style="width: 200px">
                                                <% for (final Locale locale : UtilLocale.getAvaibles()) { %>
                                                    <option <%= locale.equals(request.getLocale()) ? "selected" : "" %> value="<%= UtilLocale.toString(locale) %>"><%= locale.getDisplayName() %></option>
                                                <% } %>
                                            </select>
                                        </p>
                                        <input type="submit" value="Выбрать">
                                    </form>
                                </td>
                                <td id="loginhelp" valign="top" width="60%" style="padding-left: 20px">
                                    <div style="background-color: #D5F3D6; padding: 5px">
                                        <p style="margin-top: 0">
                                            Это не страшно, с этой страницы Вы можете зайти в программу,
                                            если Вы знаете свой логин или пароль введите его в нужные поля и
                                            нажмите "Войти".
                                        </p>
                                        <p>
                                            Если Вы знаете что можно не вводит нажимайте "автоматически",
                                            однако знайте в случаи безуспешной попытки нужно закрыть это
                                            окно и окрыть его снова.
                                        </p>
                                        <p>
                                            <b>Внимание!</b> При <%= LoginResultServlet.BLOCK_COUNT %> попытках
                                            неверно введения пароля система запретит Вам входить в течение
                                            ближайших <%= LoginResultServlet.BLOCK_DELAY / 1000 / 60 %> минут, если
                                            это страшно обратитесь к своему администратору.
                                        </p>
                                        <p>
                                            <b>Если же это первое</b> использование программы перейдите на
                                            эту <a href="/start.jsp">страницу</a>
                                        </p>
                                        <p style="margin-bottom: 0">Успеха.</p>
                                    </div>
                                </td>
                            <% } %>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>