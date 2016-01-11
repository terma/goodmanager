<%@ page import="ua.com.testes.manager.entity.view.EntityFirmSort" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityView" %>
<%@ page import="ua.com.testes.manager.logic.view.LogicView" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    Integer sectionId = null;
    if (request.getParameter("sectionId") != null) {
        sectionId = Integer.parseInt(request.getParameter("sectionId"));
    }
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final EntityView view = LogicView.get(user);
    final int sortId = Integer.parseInt(request.getParameter("sortId"));
    EntityFirmSort previousSort = null;
    for (final EntityFirmSort sort : view.sort.firms) {
        if (sort.id == sortId) {
            if (previousSort != null) {
                previousSort.order++;
                sort.order--;
            }
            break;
        }
        previousSort = sort;
    }
    EntityManager.execute(new EntityTransaction() {

        public Object execute(javax.persistence.EntityManager manager) {
            user.setDefaultView(view);
            manager.persist(user);
            return null;
        }

    });
    response.sendRedirect("/security/views.jsp" + (sectionId == null ? "" : "?sectionId=" + sectionId));
%>
