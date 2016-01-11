<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.tiding.EntityTiding" %>
<%@ page import="ua.com.testes.manager.view.tiding.ViewTidingCategory" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final int tidingCategoryId = Integer.parseInt(request.getParameter("tidingcategoryid"));

    final EntityTiding tiding = new EntityTiding();
    final Set<String> errors = new HashSet<String>();

    GregorianCalendar calendar = new GregorianCalendar();
    try {
        int year = Integer.parseInt(request.getParameter("tidingstartyear"));
        int month = Integer.parseInt(request.getParameter("tidingstartmonth"));
        int day = Integer.parseInt(request.getParameter("tidingstartday"));
        calendar.set(year, month, day, 0, 0, 0);
        tiding.start = calendar.getTime();
    } catch (Exception exception) {
        errors.add("parsestart");
    }

    try {
        int year = Integer.parseInt(request.getParameter("tidingfinishyear"));
        int month = Integer.parseInt(request.getParameter("tidingfinishmonth"));
        int day = Integer.parseInt(request.getParameter("tidingfinishday"));
        calendar.set(year, month, day, 0, 0, 0);
        tiding.finish = calendar.getTime();
    } catch (Exception exception) {
        errors.add("parsefinish");
    }

    if (errors.isEmpty()) {
        if (tiding.start.after(tiding.finish)) {
            errors.add("startbeforeafter");
        }
    }

    final String name = request.getParameter("tidingname");
    tiding.name = name.trim();
    if (tiding.name.isEmpty()) {
        errors.add("nameempty");
    }

    if (errors.size() > 0) {
        request.setAttribute("tiding", tiding);
        request.setAttribute("errors", errors);
        request.getRequestDispatcher(
                "/security/tiding/tidingadd.jsp?tidingcategoryid=" +
                        tidingCategoryId).forward(request, response);
        return;
    }

    tiding.description = request.getParameter("description");
    if (tiding.description == null) {
        tiding.description = "";
    }

    EntityManager.execute(new EntityTransaction<Void>() {

        public Void execute(javax.persistence.EntityManager manager) {
            tiding.category = ViewTidingCategory.getById(tidingCategoryId);
            tiding.category.tidings.add(tiding);
            EntityManager.get().persist(tiding);
            return null;
        }

    });

    response.sendRedirect("/security/tiding/main.jsp?tidingCategoryId=" + tidingCategoryId);
%>