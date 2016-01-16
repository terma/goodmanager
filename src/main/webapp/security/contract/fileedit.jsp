<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageContractError" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityVersionFile file = EntityManager.find(
            EntityVersionFile.class, Integer.parseInt(request.getParameter("fileId")));
    if (file == null) {
        response.sendRedirect("/security/contract/main.jsp");
        return;
    }
%>
<html>
    <head>
        <title>Редактирование файла - Менеджер 1.0</title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="/security/contract/main.jsp">договорам</a> или к
        <a href="/security/contract/detail.jsp?contractId=<%= file.version.contract.id %>">договору</a>
        <p>
            Замена файла <a href="/security/contract/fileget?fileId=<%= file.id %>"><%= file.name %></a>
            в документе <%= file.version.contract.name %>
        </p>
        <p>
            <% final Set<PageContractError> errors = (Set<PageContractError>) request.getAttribute("errors"); %>
            <form action="/security/contract/fileeditresult.jsp" method="post" enctype="multipart/form-data">
                <p><b>Реквизиты файла</b></p>
                <% if (errors != null && errors.contains(PageContractError.CONTRACT_FILE_EMTPY)) { %>
                    <b>Укажите файл</b><br>
                <% } %>
                Файл<br>
                <div id="contractfile1">
                    <input type="file" name="versionfile" value="" style="width: 80%">
                </div>
                <input type="hidden" name="fileid" value="<%= file.id %>">
                <p><input type="submit" name="" value="Заменить"></p>
            </form>
        </p>        
    </body>
</html>