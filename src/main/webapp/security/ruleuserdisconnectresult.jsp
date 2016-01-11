<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.web.filter.SessionListener" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id == 2) {
        SessionListener.disconnect(Integer.parseInt(request.getParameter("userId")));
        response.sendRedirect("/security/rule.jsp");
    } else {
        response.sendRedirect("/security/main.jsp");
    }
%>