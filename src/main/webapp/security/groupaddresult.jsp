<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.web.page.PageRuleError" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final EntityGroup group = new EntityGroup();
    final Set<PageRuleError> errors = new HashSet<PageRuleError>();
    group.name = request.getParameter("groupname");
    if (group.name == null || group.name.trim().length() == 0) {
        errors.add(PageRuleError.GROUP_NAME_EMPTY);
    } else {
        group.name = group.name.trim();
    }

    if (errors.isEmpty()) {
        List<EntityGroup> groups = EntityManager.list(
                "select group from ua.com.testes.manager.entity.EntityGroup as group where group.name = :p0", group.name);
        if (!groups.isEmpty()) {
            errors.add(PageRuleError.GROUP_NAME_NOT_UNIQUE);    
        }
    }

    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.setAttribute("group", group);
        request.getRequestDispatcher("/security/groupadd.jsp?").forward(request, response);
    } else {
        EntityManager.execute(new EntityTransaction<Object>() {

            public Object execute(final javax.persistence.EntityManager manager) {
                manager.persist(group);
                return null;
            }

        });
        response.sendRedirect("/security/rule.jsp");
    }
%>