<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityContact" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy", request.getLocale());
%>
<html>
    <head>
        <title>Удаление контакта - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
            <tr>
                <%
                    final int contactId = Integer.parseInt(request.getParameter("contactId"));
                    final EntityContact contact = EntityManager.find(EntityContact.class, contactId);
                    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
                %>
                <td valign="center" align="center">
                    <a href="/security/detail.jsp?firmId=<%= contact.pipol.getFirm().getId() %>">Назад</a>
                    <p>
                        <% if (user == contact.user) {  %>
                            <% if (contact.pipol.getContacts().size() > 1) { %>
                                <form action="contactdelete.jsp" method="post">
                                    <login:input/>
                                    <p>
                                        Вы действительно хотите удалить беседу с <%= contact.pipol.getFio() %>
                                        из <%= contact.pipol.getFirm().getName() %> от <%= format.format(contact.create) %>,
                                        беседа о <p><%= contact.description %></p>
                                    </p>
                                    <input type="hidden" name="contactId" value="<%= contact.id %>">
                                    <input type="submit" value="Удалить">
                                </form>
                            <% } else { %>
                                К сожалению нельзя удалить последний контакт
                                из <%= contact.pipol.getFirm().getName() %>, создайте <a href="/security/contactadd.jsp?firmId=<%= contact.pipol.getFirm().getId() %>">новый</a>, или вообще
                                удалите всю <a href="/security/firmdeleteconfirm.jsp?firmId=<%= contact.pipol.getFirm().getId() %>">фирму</a>
                            <% } %>
                        <% } else { %>
                            К сожалению Вы не можете удалять беседу другого
                            сотрудника (<%= contact.pipol.getFio() %>) с <%= contact.pipol.getFio() %> от
                            <%= format.format(contact.create) %>
                        <% } %>
                    </p>
                </td>
            </tr>
        </table>
    </body>
</html>