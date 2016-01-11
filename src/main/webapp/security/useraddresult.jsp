<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.web.page.PageRuleError" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    request.setCharacterEncoding("utf-8");
    final EntityUser newUser = new EntityUser();
    final Set<PageRuleError> errors = new HashSet<PageRuleError>();
    newUser.setLogin(request.getParameter("userlogin"));
    newUser.setPassword(request.getParameter("userpassword"));
    newUser.setEmail(request.getParameter("useremail"));
    newUser.setFio(request.getParameter("userfio"));
    newUser.setDescription(request.getParameter("userdescription"));

    if (newUser.getLogin() == null || newUser.getLogin().trim().length() == 0) {
        errors.add(PageRuleError.USER_LOGIN_EMPTY);
    } else {
        newUser.setLogin(newUser.getLogin().trim());
    }

    if (newUser.getEmail() == null) {
        newUser.setEmail("");
    } else {
        newUser.setEmail(newUser.getEmail().trim());
    }

    if (newUser.getDescription() == null) {
        newUser.setDescription("");
    } else {
        newUser.setDescription(newUser.getDescription().trim());
    }

    if (newUser.getFio() == null) {
        newUser.setFio("");
    } else {
        newUser.setFio(newUser.getFio().trim());
    }
    if (newUser.getFio().length() == 0) {
        errors.add(PageRuleError.USER_NAME_EMPTY);
    }

    final String passwordConfirm = request.getParameter("userpasswordconfirm");
    if (newUser.getPassword() == null) {
        newUser.setPassword("");
    }

    if (passwordConfirm != null) {
        if (!newUser.getPassword().equals(passwordConfirm)) {
            errors.add(PageRuleError.USER_PASSWORD_NOT_EQUAL);
        }
    }

    if (errors.isEmpty()) {
        List<EntityUser> users = EntityManager.list(
                "select user from ua.com.testes.manager.entity.user.EntityUser as user where user.login = :p0", newUser.getLogin());
        if (!users.isEmpty()) {
            errors.add(PageRuleError.USER_LOGIN_NOT_UNIQUE);
        }
    }

    newUser.setGroup(EntityManager.find(EntityGroup.class, Integer.parseInt(request.getParameter("usergroup"))));

    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.setAttribute("user", newUser);
        request.getRequestDispatcher("/security/useradd.jsp").forward(request, response);
    } else {
        EntityManager.execute(new EntityTransaction<Object>() {

            public Object execute(final javax.persistence.EntityManager manager) {
                manager.persist(newUser);
                return null;
            }

        });
        response.sendRedirect("/security/rule.jsp");
    }
%>