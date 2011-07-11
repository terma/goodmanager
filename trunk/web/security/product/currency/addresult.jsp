<%@ page import="ua.com.testes.manager.logic.product.LogicCurrency" %>
<%@ page import="ua.com.testes.manager.logic.product.LogicCurrencyException" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    try {
        LogicCurrency.add(request.getParameter("currencyname"), request.getParameter("currencylabel"));
    } catch (LogicCurrencyException exception) {
        request.setAttribute("errors", exception.getErrors());
        request.setAttribute("currency", exception.getCurrency());
        request.getRequestDispatcher("/security/product/currency/main.jsp").forward(request, response);
        return;
    }
    response.sendRedirect("/security/product/currency/main.jsp");
%>