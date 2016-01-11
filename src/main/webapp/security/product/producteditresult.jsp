<%@ page import="ua.com.testes.manager.logic.product.LogicProduct" %>
<%@ page import="ua.com.testes.manager.logic.product.LogicProductException" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityProduct" %>
<%@ page import="ua.com.testes.manager.view.product.ViewProduct" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final EntityProduct product = ViewProduct.getById(Integer.parseInt(request.getParameter("productid")));
    try {
        LogicProduct.edit(
                request.getParameter("productname"),
                product.id, request.getParameter("productdescription"));
    } catch (LogicProductException exception) {
        request.setAttribute("errors", exception.getErrors());
        request.setAttribute("productname", exception.getProduct().name);
        request.setAttribute("productdescription", exception.getProduct().description);
        request.getRequestDispatcher("/security/product/productedit.jsp?productid=" + product.id).forward(request, response);
        return;
    }
    response.sendRedirect("/security/product/main.jsp?categoryid=" + product.category.id);
%>