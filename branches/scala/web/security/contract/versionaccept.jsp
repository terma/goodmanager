<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageDetailError" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageContractError" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityContractVersion version = EntityManager.find(
            EntityContractVersion.class, Integer.parseInt(request.getParameter("versionId")));
    if (version == null) {
        response.sendRedirect("/security/contract/main.jsp");
        return;
    }
    final EntityUser user = EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));
    if (!user.getGroup().allowContractAccept(version.contract.user)) {
        response.sendRedirect("/security/contract/detail.jsp?contractId=" + version.contract.id);
        return;
    }
%>
<html>
    <head>
        <title>Проверка договор - Менеджер 1.0</title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="/security/contract/main.jsp">договорам</a> или к
        <a href="/security/contract/detail.jsp?contractId=<%= version.contract.id %>">договору</a>
        <p>
            <%
                final Set<PageContractError> errors = (Set<PageContractError>) request.getAttribute("errors");
                EntityVersionResolution resolution = (EntityVersionResolution) request.getAttribute("resolution");
                if (resolution == null) {
                    resolution = new EntityVersionResolution();
                }
            %>
            <form action="/security/contract/versionacceptresult.jsp" method="post">
                <p><b>Реквизиты резолюции</b></p>
                <p><input type="checkbox" <%= resolution.ok ? "checked" : "" %> style="vertical-align: middle;" name="resolutionok"> документы верны</p>
                Заметки<br>
                <% if (errors != null && errors.contains(PageContractError.VERSION_RESOLUTION_TEXT_EMPTY) && !resolution.ok) { %>
                    <b>Введите не пустую заметку о поводе отказа</b><br>
                <% } %>
                <textarea rows="5" cols="1" style="width: 80%" name="resolutiondescription"><%= resolution.description %></textarea>
                <input type="hidden" name="versionId" value="<%= version.id %>">
                <p><input type="submit" name="" value="Сохранить"></p>
            </form>
        </p>        
    </body>
</html>