<%@ page import="java.util.Date" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final int firmId = Integer.parseInt(request.getParameter("firmId"));
    final EntityFirm firm = EntityManager.find(EntityFirm.class, firmId);
    if (user.getId() == firm.getUser().getId()) {
        EntityManager.execute(new EntityTransaction() {

            public Object execute(javax.persistence.EntityManager manager) {
                firm.setDelete(new Date());
                manager.persist(firm);
                return null;
            }

        });
    }
    response.sendRedirect("list.jsp?sectionId=" + firm.getSection().getId());
%>