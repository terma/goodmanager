<%@ page import="ua.com.testes.manager.logic.product.LogicProductPrice" %>
<%@ page import="ua.com.testes.manager.logic.product.LogicProductPriceException" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityProduct" %>
<%@ page import="ua.com.testes.manager.view.product.ViewProduct" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final int currencyId = Integer.parseInt(request.getParameter("currencyid"));
    final EntityProduct product = ViewProduct.getById(Integer.parseInt(request.getParameter("productid")));
    try {
        LogicProductPrice.add(product.id, currencyId, Float.parseFloat(request.getParameter("productpricevalue")));
    } catch (LogicProductPriceException exception) {
        request.setAttribute("errors", exception.getErrors());
        request.setAttribute("productprice", exception.getProductPrice());
        request.getRequestDispatcher("/security/product/productpriceadd.jsp").forward(request, response);
        return;
    }
    response.sendRedirect("/security/product/main.jsp?categoryId=" + product.category.id);
%>