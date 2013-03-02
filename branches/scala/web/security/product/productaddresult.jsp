<%@ page import="ua.com.testes.manager.logic.product.LogicProduct" %>
<%@ page import="ua.com.testes.manager.logic.product.LogicProductException" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final int categoryId = Integer.parseInt(request.getParameter("categoryid"));
    try {
        LogicProduct.add(
                request.getParameter("productname"), 0,
                categoryId, request.getParameter("productdescription"));
    } catch (LogicProductException exception) {
        request.setAttribute("errors", exception.getErrors());
        request.setAttribute("product", exception.getProduct());
        request.getRequestDispatcher("/security/product/productadd.jsp").forward(request, response);
        return;
    }
    response.sendRedirect("/security/product/main.jsp?categoryId=" + categoryId);
%>