<%@ page import="ua.com.testes.manager.logic.product.LogicCategory" %>
<%@ page import="ua.com.testes.manager.logic.product.LogicCategoryException" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    Integer parentCategoryId = null;
    try {
        parentCategoryId = Integer.parseInt(request.getParameter("parentcategoryid"));
    } catch (NumberFormatException exception) {
    }
    try {
        if (parentCategoryId == null) {
            LogicCategory.add(request.getParameter("categoryname"));
        } else {
            LogicCategory.add(request.getParameter("categoryname"), parentCategoryId);
        }
    } catch (LogicCategoryException exception) {
        request.setAttribute("errors", exception.getErrors());
        request.setAttribute("category", exception.getCategory());
        if (parentCategoryId == null) {
            request.getRequestDispatcher("/security/product/categoryadd.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/security/product/categoryadd.jsp?parentcategoryid=" + parentCategoryId).forward(request, response);
        }
        return;
    }
    response.sendRedirect("/security/product/main.jsp");
%>