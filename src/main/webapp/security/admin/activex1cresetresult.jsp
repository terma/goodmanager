<%@ page import="ua.com.testes.manager.util.activex1c.UtilActiveX1c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    UtilActiveX1c.shutdown();
    response.sendRedirect("/security/admin/main.jsp");
%>