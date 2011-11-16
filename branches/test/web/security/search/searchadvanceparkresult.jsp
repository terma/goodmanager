<%@ page import="ua.com.testes.manager.logic.search.LogicSearch" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    LogicSearch.park(Integer.parseInt(request.getParameter("searchId")));
    response.sendRedirect("/security/search/searchadvance.jsp");
%>