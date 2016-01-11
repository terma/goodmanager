<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.search.*" %>
<%@ page import="ua.com.testes.manager.logic.search.LogicSearch" %>
<%@ page import="java.io.Serializable" %>
<%@ page import="java.util.Map" %>
<%@ page import="ua.com.testes.manager.view.search.ViewSearch" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.util.Collections" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%!

    private static final Comparator<EntityFirm> firmComparator = new Comparator<EntityFirm>() {

        public int compare(EntityFirm o1, EntityFirm o2) {
            return o1.getName().compareTo(o2.getName());
        }

    };

%>
<%
    final EntitySearch search = ViewSearch.getById(Integer.parseInt(request.getParameter("searchId")));
    final Map<EntitySearchSource, List<Serializable>> results = LogicSearch.execute(search);
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy", request.getLocale());
    EntitySearchSource sourceFirm = null;
    for (final EntitySearchSource source : results.keySet()) {
        if (source instanceof EntitySearchSourceFirm) {
            sourceFirm = source;
        }
    }
%>
<html>
    <head>
        <title>Результаты поиска - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <a href="/security/search/searchadvance.jsp"/>">Назад</a> к поиску<p>
        <%
            final List<EntityFirm> resultFirms = (List) results.get(sourceFirm);
            Collections.sort(resultFirms, firmComparator);
            final StringBuffer emailBuffer = new StringBuffer(resultFirms.size() * 36);
            boolean first = true;
            for (final EntityFirm firm : resultFirms) {
                if (firm.getEmail().length() > 0) {
                    if (first) {
                        first = false;
                    } else {
                        emailBuffer.append(";");
                    }
                    emailBuffer.append(firm.getEmail());
                }
            }
        %>
        <p>
            <b>Найдено фирм <%= resultFirms.size() %></b>,
            <% if (emailBuffer.length() > 0) { %>
                <a href="mailto:&bcc=<%= emailBuffer.toString() %>">написать</a> этим компаниям
            <% } %>
        </p>
        <% for (final EntityFirm firm : resultFirms) { %>
            №<%= firm.getId() %> <a href="/security/detail.jsp?firmId=<%= firm.getId() %>"><%= firm.getName() %></a>
            <div style="font-size: 12px; padding-left: 20px; padding-bottom: 20px">
                Менеджер <%= firm.getUser().getFio() %> от <%= format.format(firm.getCreate()) %><br>
                <% if (firm.getEmail().length() > 0) { %>
                    <a href="mailto:<%= firm.getEmail() %>"><%= firm.getEmail() %></a><br>
                <% } %>
                <% if (firm.getAddress().length() > 0) { %>
                    <%= firm.getAddress() %><br>
                <% } %>
                <% if (firm.getDescription().length() > 0) { %>
                    <%= firm.getDescription() %>
                <% } %>
            </div>
        <% } %>
    </body>
</html>