<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.rule.EntityServerRuleAll" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.rule.EntityServerRule" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityServerRule serverRule = new EntityServerRuleAll();
    serverRule.user = EntityManager.find(EntityUser.class, Integer.parseInt(request.getParameter("userId")));
    serverRule.server = EntityManager.find(EntityServer.class, Integer.parseInt(request.getParameter("serverId")));
    EntityManager.execute(new EntityTransaction() {

        public Object execute(javax.persistence.EntityManager manager) {
            manager.persist(serverRule);
            return null;
        }

    });
    response.sendRedirect("/security/mail/server/list.jsp");
%>
