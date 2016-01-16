<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.web.page.PageRuleError" %>
<%@ page import="java.util.Set" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Смена пароля - Менеджер 1.0</title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
            <tr>
                <%
                    final ua.com.testes.manager.entity.user.EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
                    final Set<PageRuleError> errors = (Set<PageRuleError>) request.getAttribute("errors");
                    final String password = (String) request.getAttribute("password");
                %>
                <td valign="center" align="center">
                    <a href="/security/rule.jsp">Назад</a>
                    <p>
                        <% if (user.getGroup().id == 2) { %>
                            <form action="/security/ruleuserchangepasswordresult.jsp" method="post">
                                <p>
                                    <% if (errors != null && errors.contains(PageRuleError.USER_PASSWORD_NOT_EQUAL)) { %>
                                        <p><b>Подтверждение пароля и пароль не совпадают.</b></p>
                                    <% } %>
                                    Укажите новый пароль<br>
                                    <input type="password" name="password" value="<%= password != null ? password : "" %>"><br>
                                    Подтверждение пароля<br>
                                    <input type="password" name="passwordConfirm" value="">
                                </p>
                                <input type="hidden" name="userId" value="<%= request.getParameter("userId") %>">
                                <input type="submit" value="Сменить">
                            </form>
                        <% } else { %>
                            Вы не можете менять пароль, на <a href="/security/main.jsp">главную</a>
                        <% } %>
                    </p>
                </td>
            </tr>
        </table>
    </body>
</html>