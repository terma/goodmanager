<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final int groupId = Integer.parseInt(request.getParameter("groupId"));
    final EntityGroup group = EntityManager.find(EntityGroup.class, groupId);
    final List<EntityFirm> firms = EntityManager.list(
            "select firm from ua.com.testes.manager.entity.EntityFirm " +
                    "as firm where firm.user.group.id = :p0", group.id);
    final List<EntityPipol> pipols = EntityManager.list(
            "select pipol from ua.com.testes.manager.entity.EntityPipol " +
                    "as pipol where pipol.user.group.id = :p0", group.id);
    final List<EntityContact> contacts = EntityManager.list(
            "select contact from ua.com.testes.manager.entity.EntityContact " +
                    "as contact where contact.user.group.id = :p0", group.id);
    if (user.getGroup().id == 2 && firms.isEmpty() && contacts.isEmpty() && pipols.isEmpty()) {
        EntityManager.execute(new EntityTransaction() {

            public Object execute(javax.persistence.EntityManager manager) {
                manager.remove(group);
                return null;
            }

        });
    }
    response.sendRedirect("rule.jsp");
%>