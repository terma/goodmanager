<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServer" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServerType" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityServer server = new EntityServer();
    server.type = EntityServerType.OUTBOX;
    if ("inbox".equals(request.getParameter("type"))) {
        server.type = EntityServerType.INBOX;
    }
    server.login = request.getParameter("login");
    server.password = request.getParameter("password");
    server.url = request.getParameter("url");
    EntityManager.execute(new EntityTransaction() {

        public Object execute(javax.persistence.EntityManager manager) {
            manager.persist(server);
            return null;
        }

    });
    response.sendRedirect("/security/mail/server/list.jsp");
%>
