<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!

    private static final class VersionComparator implements Comparator<EntityContractVersion> {

        public int compare(EntityContractVersion o1, EntityContractVersion o2) {
            return o2.id - o1.id;
        }

    }

%>
<%
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy hh:mm", request.getLocale());
    final ua.com.testes.manager.entity.user.EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final EntityContract contract = EntityManager.find(
            EntityContract.class, Integer.parseInt(request.getParameter("contractId")));
%>
<html>
    <head>
        <title>Договор - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            .fileInfo {font-size: 12px; padding-left: 10px}
            .resolutionOk {color: #12871A; font-weight: bold;}
            .resolutionError {color: #9D2424; font-weight: bold;}

        </style>
    </head>
    <body>
        <a href="/security/contract/main.jsp">К договорам</a>                
        <p>
            Документ <%= contract.name %> от <a href="mailto:<%= contract.user.getEmail() %>"><%= contract.user.getFio() %></a>
            <p>
                <b>
                    <% final EntityContractVersion lastVersion = contract.getLastVersion(); %>
                    <% if (lastVersion != null) { %>
                        <% if (lastVersion.resolution != null) { %>
                            <% if (lastVersion.resolution.ok) { %>
                                <span class="resolutionOk">Последняя версия проверенна успешно</span> <%= lastVersion.resolution.user.getFio() %> от
                                <%= format.format(lastVersion.resolution.create) %>
                                <% if (lastVersion.resolution.description.length() > 0) { %>
                                    <br>с заметками <%= lastVersion.resolution.description %>
                                <% } %>
                            <% } else { %>
                                <span class="resolutionError">Последняя версия проверенна отрицательно</span>
                                <%= lastVersion.resolution.user.getFio() %> от
                                <%= format.format(lastVersion.resolution.create) %>
                                <% if (lastVersion.resolution.description.length() > 0) { %>
                                    <br>с заметками <%= lastVersion.resolution.description %>
                                <% } %>
                            <% } %>
                        <% } else { %>
                            еще не проверен                            
                        <% } %>
                    <% } %>
                </b>
            </p>
            <p>
                Версии
                <ul style="list-style: none">
                    <% final List<EntityContractVersion> versions = new ArrayList<EntityContractVersion>(contract.versions); %>
                    <% Collections.sort(versions, new VersionComparator()); %>
                    <% for (final EntityContractVersion version : versions) { %>
                        <li>
                            От <%= format.format(version.create) %> создатель
                            <a href="mailto:<%= version.user.getEmail() %>"><%= version.user.getFio() %></a>
                            <p>
                                <% if (version.resolution == null) { %>
                                    <b>не проверенно</b>
                                    <% if (user.getGroup().allowContractAccept(contract.user)) { %>
                                        <a href="/security/contract/versionaccept.jsp?versionId=<%= version.id %>">проверить</a>
                                    <% } %>
                                <% } else if (version.resolution.ok) { %>
                                    <span class="resolutionOk">успешно проверенно</span>
                                    <a href="mailto:<%= version.resolution.user.getEmail() %>"><%= version.resolution.user.getFio() %></a>
                                    от <%= format.format(version.resolution.create) %>
                                    <% if (version.resolution.description.length() > 0) { %>
                                        <br>с заметками <%= version.resolution.description %>
                                    <% } %>
                                <% } else { %>
                                    <span class="resolutionError">забракованно</span> 
                                    <a href="mailto:<%= version.resolution.user.getEmail() %>"><%= version.resolution.user.getFio() %></a>
                                    от <%= format.format(version.resolution.create) %>
                                    <% if (version.resolution.description.length() > 0) { %>
                                        <br>с заметками <%= version.resolution.description %>
                                    <% } %>
                                <% } %>
                            </p>
                            <p>
                                Файлы
                                <ul style="list-style: none">
                                    <% for (final EntityVersionFile file : version.files) { %>
                                        <li>
                                            Файл <a href="/security/contract/fileget?fileId=<%= file.id %>"><%= file.name %></a>
                                            <a href="/security/contract/fileedit.jsp?fileId=<%= file.id %>">редактировать</a>
                                            <div class="fileInfo">
                                                путь <a href="<%= file.path %>"><%= file.path %></a>
                                                размер <%= file.data.length %> байт (<%= file.data.length / 1024 %> Кбайт)
                                            </div>
                                        </li>    
                                    <% } %>
                                </ul>
                            </p>
                        </li>
                    <% } %>
                </ul>
            </p>
            <%--<% if (contract.description.length() > 0) { %>--%>
                <%--<br><%= contract.description %>--%>
            <%--<% } %>--%>
        </p>
    </body>
</html>