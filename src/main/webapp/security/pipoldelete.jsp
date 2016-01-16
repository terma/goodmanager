<%@ page import="java.util.Date" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%int pipolId = Integer.parseInt(request.getParameter("pipolId"));
    final EntityPipol pipol = EntityManager.find(EntityPipol.class, pipolId);
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getId() == pipol.getUser().getId()) {
        EntityManager.execute(new EntityTransaction() {

            public Object execute(javax.persistence.EntityManager manager) {
                pipol.setDelete(new Date());
                manager.persist(pipol);
                return null;
            }

        });
    }
    response.sendRedirect("detail.jsp?firmId=" + pipol.getFirm().getId());
%>