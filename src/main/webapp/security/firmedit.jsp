<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageDetailError" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Редактирование фирмы - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="/security/main.jsp">разделам</a>
        <p>
        <form action="/security/firmeditresult" method="post">
            <login:input/>
            <%
                EntityFirm editFirm = (EntityFirm) request.getAttribute("firm");
                if (editFirm == null) {
                    EntityFirm firm = EntityManager.find(EntityFirm.class, Integer.parseInt(request.getParameter("firmId")));
                    editFirm = new EntityFirm();
                    editFirm.setName(firm.getName());
                    editFirm.setId(firm.getId());
                    editFirm.setDescription(firm.getDescription());
                    editFirm.setTelephon(firm.getTelephon());
                    editFirm.setAddress(firm.getAddress());
                    editFirm.setFax(firm.getFax());
                    editFirm.setUser(firm.getUser());
                    editFirm.setEmail(firm.getEmail());
                    editFirm.setSite(firm.getSite());
                    editFirm.setSection(firm.getSection());
                }
                final List<PageDetailError> errors = (List<PageDetailError>) request.getAttribute("errors");
            %>
            <input type="hidden" name="firmid" value="<%= editFirm.getId() %>">
            Раздел в котором фирма <a href="/security/list.jsp?sectionId=<%= editFirm.getSection().getId() %>"><%= editFirm.getSection().getName() %></a>
            можно сбросить <a href="#">измененния</a><br>
            <p>
                <b>Реквизиты фирмы</b>
                <p>
                Название компании (например: ООО Фирмах)<br>
                <% if (errors != null && errors.contains(PageDetailError.FIRM_NAME_EMPTY)) { %>
                    <b>Введите пожайлусто название компании.</b>
                <% } %>
                <% if (errors != null && errors.contains(PageDetailError.FIRM_NAME_NOT_UNIQUE)) { %>
                    <b>Введите пожайлусто уникальное название компании.</b>
                <% } %>
                <input type="text" name="firmname" value="<%= editFirm.getName() %>" style="width: 80%"><br>
                Телефон<br>
                <input type="text" name="firmtelephon" value="<%= editFirm.getTelephon() %>" style="width: 80%"><br>
                Факс<br>
                <input type="text" name="firmfax" value="<%= editFirm.getFax() %>" style="width: 80%"><br>
                Электропочта<br>
                <input type="text" name="firmemail" value="<%= editFirm.getEmail() %>" style="width: 80%"><br>
                Сайт<br>
                <input type="text" name="firmsite" value="<%= editFirm.getSite() %>" style="width: 80%"><br>
                Адрес<br>
                <input type="text" name="firmaddress" value="<%= editFirm.getAddress() %>" style="width: 80%"><br>
                Заметки<br>
                <textarea rows="5" name="firmdescription" cols="" style="width: 80%"><%= editFirm.getDescription() %></textarea>
            </p>
        </p>
            <input type="submit" name="" value="Сохранить">
        </form>
    </body>
</html>