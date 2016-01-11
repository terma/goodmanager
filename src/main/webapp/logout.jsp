<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session.invalidate();
//    session.setAttribute("user", null);
    response.sendRedirect("/login.jsp");
%>