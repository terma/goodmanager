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
                    int contactId = Integer.parseInt(request.getParameter("contactId"));
                    EntityContact contact = EntityManager.find(EntityContact.class, contactId);
                    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
                %>
                <td valign="center" align="center">
                    <a href="/security/detail.jsp?firmId=<%= contact.getPipol().getFirm().getId() %>">Назад</a>
                    <p>
                        <% if (user.getId() == contact.getUser().getId()) {  %>
                            <% if (contact.getPipol().getContacts().size() > 1) { %>
                                <form action="contactdelete.jsp">
                                    <login:input/>
                                    <p>
                                        Вы действительно хотите удалить беседу с <%= contact.getPipol().getFio() %>
                                        из <%= contact.getPipol().getFirm().getName() %> от <%= format.format(contact.getCreate()) %>,
                                        беседа о <p><%= contact.getDescription() %></p>
                                    </p>
                                    <input type="hidden" name="contactId" value="<%= contact.getId() %>">
                                    <input type="submit" value="Удалить">
                                </form>
                            <% } else { %>
                                К сожалению нельзя удалить последний контакт
                                из <%= contact.getPipol().getFirm().getName() %>, создайте <a href="/security/contactadd.jsp?firmId=<%= contact.getPipol().getFirm().getId() %>">новый</a>, или вообще
                                удалите всю <a href="/security/firmdeleteconfirm.jsp?firmId=<%= contact.getPipol().getFirm().getId() %>">фирму</a>
                            <% } %>
                        <% } else { %>
                            К сожалению Вы не можете удалять беседу другого
                            сотрудника (<%= contact.getUser().getFio() %>) с <%= contact.getPipol().getFio() %> от
                            <%= format.format(contact.getCreate()) %>
                        <% } %>
                    </p>
                </td>
            </tr>
        </table>
    </body>
</html>