<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityMail" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final String[] mailIdStrings = request.getParameterValues("mailId");
    EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    EntityManager.execute(new EntityTransaction() {

        public Object execute(javax.persistence.EntityManager manager) {
            for (final String mailIdString : mailIdStrings) {
                final EntityMail mail = manager.find(EntityMail.class, Integer.parseInt(mailIdString));
                manager.remove(mail);
                mail.user.getMails().remove(mail);
                mail.server.mails.remove(mail);
            }
            return null;
        }

    });
    response.sendRedirect("/security/mail/main.jsp");
%>