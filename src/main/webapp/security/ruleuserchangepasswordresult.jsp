<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.web.page.PageRuleError" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id == 2) {
        final int changePasswordId = Integer.parseInt(request.getParameter("userId"));
        final Set<PageRuleError> errors = new HashSet<PageRuleError>();
        final String password = request.getParameter("password");
        final String passwordConfirm = request.getParameter("passwordConfirm");
        if (password == null || passwordConfirm == null) {
            errors.add(PageRuleError.USER_PASSWORD_EMPTY);
        } else {
            if (!passwordConfirm.equals(password)) {
                errors.add(PageRuleError.USER_PASSWORD_NOT_EQUAL);
            }
        }
        if (errors.isEmpty()) {
            final EntityUser changePasswordUser = EntityManager.find(EntityUser.class, changePasswordId);
            EntityManager.execute(new EntityTransaction() {

                public Object execute(javax.persistence.EntityManager manager) {
                    changePasswordUser.setPassword(password);
                    manager.persist(changePasswordUser);
                    return null;
                }

            });
            response.sendRedirect("/security/rule.jsp");
        } else {
            request.setAttribute("password", password);
            request.setAttribute("errors", errors);
            request.getRequestDispatcher(
                    "/security/ruleuserchangepassword.jsp?userId=" + changePasswordId).forward(request, response);
        }
    } else {
        response.sendRedirect("/security/main.jsp");
    }

%>