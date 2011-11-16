<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageDetailError" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Добавление контакта - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="/security/main.jsp">разделам</a>
        <%
            int firmId;
            try {
                firmId = Integer.parseInt(request.getParameter("firmId"));
            } catch (NumberFormatException exception) {
                response.sendRedirect("/security/main.jsp");
                return;
            }
            Integer pipolId;
            try {
                pipolId = Integer.parseInt(request.getParameter("pipolId"));
            } catch (NumberFormatException exception) {
                pipolId = null;
            }
            Integer statusId;
            try {
                statusId = Integer.parseInt(request.getParameter("statusId"));
            } catch (NumberFormatException exception) {
                statusId = null;
            }
            final List<PageDetailError> errors =
                    (List<PageDetailError>) request.getAttribute("errors");
            EntityContact contact = (EntityContact) request.getAttribute("contact");
            if (contact == null) {
                contact = new EntityContact();
            }
        %>
        или к <a href="/security/detail.jsp?firmId=<%= firmId %>">фирме</a>
        <p>
        <form action="/security/contactaddresult.jsp" method="post">
            <login:input/>
            Сотрудник для беседы<br>
            <select name="pipolId" style="vertical-align: middle; width: 80%">
                <%
                    final int tempFirmId = firmId;
                    final List<EntityPipol> pipolList = EntityManager.list(
                        "select pipol from ua.com.testes.manager.entity.EntityPipol as pipol where id_parent = " +
                        tempFirmId + " order by fio");
                %>
                <% for (final EntityPipol pipol : pipolList) { %>
                <option value="<%= pipol.getId() %>" <%= pipol.getId().equals(pipolId) ? "selected" : "" %>>
                    <%= pipol.getFio() %>
                </option>
                <% } %>
            </select><p>
            <input type="hidden" name="firmId" value="<%= firmId %>">
            <p><b>Реквизиты первого контакта</b>
            <p>
                Статус<br>
                <select name="statusId" style="vertical-align: middle; width: 80%">
                    <%
                        final List<EntityStatus> statuses = EntityManager.list(
                            "select status from ua.com.testes.manager.entity.EntityStatus as status");
                     %>
                    <% for (final EntityStatus status : statuses) { %>
                    <option <%= status.id.equals(statusId) ? "selected" : "" %>
                            value="<%= status.id %>"><%= status.name %>
                    </option>
                    <% } %>
                </select>
            <p>
                Беседа<br>
                <% if (errors != null && errors.contains(PageDetailError.CONTACT_DESCRIPTION_EMPTY)) { %>
                <b>Введите пожайлусто текст беседы с сотрудником.</b>
                <% }
        String result = contact.description;
    %>
                <textarea rows="8" name="contactdescription" cols="" style="width: 80%"><%= result %></textarea><p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>