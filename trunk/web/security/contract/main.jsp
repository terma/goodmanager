<%@ page import="ua.com.testes.manager.entity.EntityContract" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityContractVersion" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityVersionResolution" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!

    private static final class PageContractComparator implements Comparator<EntityContract> {

        public int compare(EntityContract o1, EntityContract o2) {
            return o2.id - o1.id;
        }

    }

%>
<%
    final String contractType = request.getParameter("contractType");
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy hh:mm", request.getLocale());
    List<EntityContract> contracts = EntityManager.list("select contract from ua.com.testes.manager.entity.EntityContract as contract");
    if ("unknown".equalsIgnoreCase(contractType)) {
        final Iterator<EntityContract> contractIterator = contracts.iterator();
        while (contractIterator.hasNext()) {
            if (contractIterator.next().getLastVersion().resolution != null) {
                contractIterator.remove();
            }
        }
    } else if ("allow".equalsIgnoreCase(contractType)) {
        final Iterator<EntityContract> contractIterator = contracts.iterator();
        while (contractIterator.hasNext()) {
            final EntityVersionResolution resolution = contractIterator.next().getLastVersion().resolution;
            if (resolution == null || !resolution.ok) {
                contractIterator.remove();
            }
        }
    } else if ("denied".equalsIgnoreCase(contractType)) {
        final Iterator<EntityContract> contractIterator = contracts.iterator();
        while (contractIterator.hasNext()) {
            final EntityVersionResolution resolution = contractIterator.next().getLastVersion().resolution;
            if (resolution == null || resolution.ok) {
                contractIterator.remove();
            }
        }
    } 
    Collections.sort(contracts, new PageContractComparator());
%>
<html>
    <head>
        <title>Договора - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            .resolutionOk {color: #12871A; font-weight: bold;}
            .resolutionError {color: #9D2424; font-weight: bold;}

        </style>
    </head>
    <body>
        <a href="/security/main.jsp">Назад</a> смотреть
        <a href="/security/contract/main.jsp?contractType=unknown">непроверенные</a>,
        <a href="/security/contract/main.jsp?contractType=allow">проверенные</a>,
        <a href="/security/contract/main.jsp?contractType=denied">отбракованные</a> договора или
        <a href="/security/contract/main.jsp">все</a>
        <a href="/security/contract/contractadd.jsp">новый</a>
        <p>
            <form action="/security/contract/searchresult.jsp" method="post">
                <input type="text" name="text" value="" style="width: 80%; vertical-align: top;">
                <input type="submit" value="Поиск">
            </form>
        </p>
        <table border="0" cellpadding="0" cellspacing="10" width="100%">            
            <% for (final EntityContract contract : contracts) { %>
                <tr>
                    <td>№<%= contract.id %></td>
                    <td>
                        <a href="/security/contract/detail.jsp?contractId=<%= contract.id %>"><%= contract.name %></a><br>
                        от <a href="mailto:<%= contract.user.getEmail() %>"><%= contract.user.getFio() %></a>
                    </td>
                    <td>Версий <%= contract.versions.size() %></td>
                    <td>
                        <% final EntityContractVersion lastVersion = contract.getLastVersion(); %>
                        Последняя версия от <%= format.format(lastVersion.create) %>
                        <% if (lastVersion.resolution != null) { %>
                            <% if (!lastVersion.resolution.ok) { %>
                                <br><span class="resolutionError">отбракованно</span> <a href="mailto:<%= lastVersion.resolution.user.getEmail() %>"><%= lastVersion.resolution.user.getFio() %></a>,
                                от <%= format.format(lastVersion.resolution.create) %>
                            <% } else { %>
                                <br><span class="resolutionOk">проверенна</span> <a href="mailto:<%= lastVersion.resolution.user.getEmail() %>"><%= lastVersion.resolution.user.getFio() %></a>,
                                от <%= format.format(lastVersion.resolution.create) %>
                            <% } %>
                        <% } else { %>
                            <br><b>не проверенна</b>
                        <% } %>
                    </td>
                </tr>
            <% } %>
        </table>
    </body>
</html>