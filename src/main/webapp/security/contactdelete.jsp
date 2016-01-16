<%@ page import="ua.com.testes.manager.entity.EntityContact" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="java.util.Date" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final int contactId = Integer.parseInt(request.getParameter("contactId"));
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final EntityContact contact = EntityManager.find(EntityContact.class, contactId);
    if (user.getId() == contact.user.getId()) {
        EntityManager.execute(new EntityTransaction() {

            public Object execute(javax.persistence.EntityManager manager) {
                contact.delete = new Date();
                manager.persist(contact);
                return null;
            }

        });
    }
    response.sendRedirect("detail.jsp?firmId=" + contact.pipol.getFirm().getId());
%>