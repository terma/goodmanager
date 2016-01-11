<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntitySection" %>
<%@ page import="ua.com.testes.manager.entity.EntityStyle" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntitySection section = EntityManager.find(EntitySection.class, Integer.parseInt(request.getParameter("sectionid")));
    final EntityStyle style = EntityManager.find(EntityStyle.class, Integer.parseInt(request.getParameter("styleid")));
    EntityManager.execute(new EntityTransaction<Void>() {

        public Void execute(javax.persistence.EntityManager manager) {
            section.setStyle(style);
            return null;
        }

    });
    response.sendRedirect("/security/main.jsp");
%>
