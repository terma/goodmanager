<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.logic.product.rate.LogicRate" %>
<%@ page import="ua.com.testes.manager.logic.product.rate.LogicRateItem" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy hh:mm", request.getLocale());
    final NumberFormat formatRate = DecimalFormat.getCurrencyInstance(new Locale("uk"));
    final ua.com.testes.manager.entity.user.EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user == null) return;
    if (!LogicRate.isUse(user)) return;
    if ("refresh".equalsIgnoreCase(request.getParameter("rate"))) {
        LogicRate.reset();
    }
    final List<LogicRateItem> items = LogicRate.get();
    // Создаем сылку на обновление
    String refreshUrl = request.getRequestURI();
    if (request.getQueryString() != null) {
        refreshUrl += "?" + request.getQueryString() + "&";
    } else {
        refreshUrl += "?";
    }
    refreshUrl += "rate=refresh";
%>
<style type="text/css">

    .rateInfo {
        font-size: 12px
    }

</style>
<div style="background-color: #FFFCD0; padding: 5px; margin-top: 5px">
    <% if (items != null) { %>
        Курсы валют <a href="<%= refreshUrl %>"/>">проверить</a> еще раз
        <%--<ul style="list-style: none; padding: 0 px; margin-top: 5px; margin-bottom: 5px;">--%>
            <% for (final LogicRateItem item : items) { %>
                    На <%= format.format(item.getDate()) %> <b><%= item.getCurrency() %> <%= formatRate.format(item.getValue()) %></b>
            <% } %>
        <!--</ul>-->
    <% } else { %>
        Извините за неудобство временно не удалось получить курсы
        <a href="<%= refreshUrl %>"/>">проверить</a> еще раз
    <% } %>
</div>

