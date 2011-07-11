<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id == 2) {
        final EntityUser blockUser = EntityManager.find(EntityUser.class, Integer.parseInt(request.getParameter("userId")));
        EntityManager.execute(new EntityTransaction<Object>() {

            public Object execute(final javax.persistence.EntityManager manager) {
                blockUser.setBlock(null);
                manager.persist(blockUser);
                return null;
            }

        });
        response.sendRedirect("/security/rule.jsp");
    } else {
        response.sendRedirect("/security/main.jsp");
    }
%>