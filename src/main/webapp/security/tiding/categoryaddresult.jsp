<%@ page import="ua.com.testes.manager.logic.tiding.LogicTidingCategory" %>
<%@ page import="ua.com.testes.manager.logic.tiding.LogicTidingCategoryException" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    try {
        LogicTidingCategory.add(request.getParameter("tidingcategoryname"));
    } catch (LogicTidingCategoryException exception) {
        request.setAttribute("errors", exception.getErrors());
        request.setAttribute("category", exception.getTidingCategory());
        request.getRequestDispatcher("/security/tiding/categoryadd.jsp").forward(request, response);
        return;
    }
    response.sendRedirect("/security/tiding/main.jsp");
%>