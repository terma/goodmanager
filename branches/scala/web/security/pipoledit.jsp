<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageDetailError" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Редактирование сотрудника - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="<login:link value="/security/main.jsp"/>">разделам</a>
        <p>
        <form action="/security/pipoleditresult.jsp" method="post">
            <login:input/>
            <%
                EntityPipol editPipol = (EntityPipol) request.getAttribute("pipol");
                if (editPipol == null) {
                    EntityPipol pipol = EntityManager.find(EntityPipol.class, Integer.parseInt(request.getParameter("pipolId")));
                    editPipol = new EntityPipol();
                    editPipol.setFio(pipol.getFio());
                    editPipol.setId(pipol.getId());
                    editPipol.setDescription(pipol.getDescription());
                    editPipol.setTelephon(pipol.getTelephon());
                    editPipol.setUser(pipol.getUser());
                    editPipol.setEmail(pipol.getEmail());
                    editPipol.setFirm(pipol.getFirm());
                }
                final List<PageDetailError> errors = (List<PageDetailError>) request.getAttribute("errors");
            %>
            <input type="hidden" name="pipolid" value="<%= editPipol.getId() %>">
            Сотрудник из <a href="<login:link value="<%= "/security/detail.jsp?firmId=" + editPipol.getFirm().getId() %>"/>"><%= editPipol.getFirm().getName() %></a>
            раздел <a href="<login:link value="<%= "/security/list.jsp?sectionId=" + editPipol.getFirm().getSection().getId() %>"/>"><%= editPipol.getFirm().getSection().getName() %></a>
            можно сбросить <a href="#">измененния</a><br>
            <p>
                <b>Реквизиты сотрудника</b>
                <p>
                ФИО (например: Пушкин Александр Сергеевич)<br>
                <% if (errors != null && errors.contains(PageDetailError.PIPOL_FIO_EMPTY)) { %>
                    <b>Введите пожайлусто ФИО сотрудника.</b>
                <% } %>
                <% if (errors != null && errors.contains(PageDetailError.PIPOL_FIO_NOT_UNIQUE)) { %>
                    <b>Введите пожайлусто уникальное ФИО сотрудника.</b>
                <% } %>
                <input type="text" name="pipolfio" value="<%= editPipol.getFio() %>" style="width: 80%"><br>
                Телефон<br>
                <input type="text" name="pipoltelephon" value="<%= editPipol.getTelephon() %>" style="width: 80%"><br>
                Электропочта<br>
                <input type="text" name="pipolemail" value="<%= editPipol.getEmail() %>" style="width: 80%"><br>
                Должность<br>
                <input type="text" name="pipolrank" value="<%= editPipol.getRang() %>" style="width: 80%"><br>
                Заметки<br>
                <textarea rows="5" name="pipoldescription" cols="" style="width: 80%"><%= editPipol.getDescription() %></textarea>
            </p>
        </p>
            <input type="submit" name="" value="Сохранить">
        </form>
    </body>
</html>