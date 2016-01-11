<%@ page import="ua.com.testes.manager.entity.EntityFirm" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<% final List<EntityFirm> firms = (List<EntityFirm>) request.getAttribute("firms"); %>
<% if (!firms.isEmpty()) { %>
Фирмы с похожими именами, всего (<%= firms.size() %>):
<ul>
    <% for (EntityFirm firm : firms) { %>
    <li>
        <% String link = "detail.jsp?firmId=" + firm.getId(); %>
        <a href="<%= link %>"/>">
            <%= firm.getName() %>
        </a>
    </li>
    <% } %>
</ul>
<% } else { %>
    <span style="color: #1c811c">Фирмы с таким именем еще нет.</span>
<% } %>