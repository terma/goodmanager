<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.logic.style.LogicStyle" %>
<%@ page import="ua.com.testes.manager.logic.style.LogicStyleException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    try {
        LogicStyle.create(
                request.getParameter("stylename"), request.getParameter("styledescription"),
                request.getParameter("stylebold") != null, request.getParameter("styleitaly") != null,
                request.getParameter("styleunderline") != null, request.getParameter("stylestrikeout") != null,
                Integer.parseInt(request.getParameter("stylecolor")), user.getId());
        response.sendRedirect("/security/style/list.jsp");
    } catch (LogicStyleException exception) {
        request.setAttribute("exception", exception);
        request.getRequestDispatcher("/security/style/add.jsp").forward(request, response);
    }
%>