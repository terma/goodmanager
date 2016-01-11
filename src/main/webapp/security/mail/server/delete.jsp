<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final int serverId = Integer.parseInt(request.getParameter("serverId"));
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final EntityServer server = EntityManager.find(EntityServer.class, serverId);
    if (user.getGroup().id == 2) {
        EntityManager.execute(new EntityTransaction() {

            public Object execute(javax.persistence.EntityManager manager) {
                manager.remove(server);
                return null;
            }

        });
    }
    response.sendRedirect("/security/mail/server/list.jsp");
%>