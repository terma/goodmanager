<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.persistence.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    final EntityUser moveUser = EntityManager.find(
            EntityUser.class, Integer.parseInt(request.getParameter("userid")));
    final EntityGroup group = EntityManager.find(
            EntityGroup.class, Integer.parseInt(request.getParameter("usergroupid")));
    if (group != null && moveUser != null) {
        EntityManager.execute(new EntityTransaction() {

            public Object execute(final javax.persistence.EntityManager manager) {
                moveUser.getGroup().users.remove(moveUser);
                moveUser.setGroup(group);
                group.users.add(moveUser);
                manager.persist(moveUser);
                return null;
            }

        });
    }
    response.sendRedirect("/security/rule.jsp");
%>