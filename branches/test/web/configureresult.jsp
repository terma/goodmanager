<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="ua.com.testes.manager.web.page.PageRuleError" %>
<%@ page import="ua.com.testes.manager.entity.EntityGroup" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Выбираем всех пользователей которые администраторы
    final List<EntityUser> adminUsers = EntityManager.list(
            "select user from ua.com.testes.manager.entity.user.EntityUser as user where group.id = 2");
    if (adminUsers.isEmpty()) {
        final EntityGroup adminGroup = new EntityGroup();
        final EntityGroup userGroup = new EntityGroup();
        final EntityUser newAdminUser = new EntityUser();
        adminGroup.users.add(newAdminUser);
        newAdminUser.setGroup(adminGroup);

        newAdminUser.setFio(request.getParameter("adminfio").trim());
        newAdminUser.setEmail(request.getParameter("adminemail").trim());
        newAdminUser.setPassword(request.getParameter("adminpassword").trim());
        newAdminUser.setLogin(request.getParameter("adminlogin").trim().toLowerCase());
        adminGroup.name = request.getParameter("admingroupname").trim();
        userGroup.name = request.getParameter("usergroupname").trim();
        final String confirmPassword = request.getParameter("adminconfirmpassword").trim();

        final Set<PageRuleError> errors = new HashSet<PageRuleError>();
        if (!confirmPassword.equals(newAdminUser.getPassword())) {
            errors.add(PageRuleError.USER_PASSWORD_NOT_EQUAL);
        }
        if (newAdminUser.getLogin().length() == 0) {
            errors.add(PageRuleError.USER_LOGIN_EMPTY);
        }
        if (newAdminUser.getPassword().length() == 0) {
            errors.add(PageRuleError.USER_PASSWORD_EMPTY);
        }
        if (adminGroup.name.length() == 0) {
            errors.add(PageRuleError.GROUP_NAME_EMPTY);
        }
        if (userGroup.name.length() == 0 || userGroup.name.equals(adminGroup.name)) {
            errors.add(PageRuleError.GROUP_NAME_NOT_UNIQUE);
        }

        if (!errors.isEmpty()) {
            request.setAttribute("admingroup", adminGroup);
            request.setAttribute("usergroup", userGroup);
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/start.jsp").forward(request, response);
            return;
        }

        EntityManager.execute(new EntityTransaction<Void>() {

            public Void execute(javax.persistence.EntityManager manager) {
                manager.persist(userGroup);
                manager.persist(adminGroup);
                return null;
            }

        });
    }
    response.sendRedirect("/login.jsp");
%>