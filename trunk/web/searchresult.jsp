<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityProduct" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    String text = request.getParameter("text");
    if (text == null) {
        text = "";
    }
    text = text.trim().toLowerCase();
    final List<EntityProduct> products = EntityManager.list("select product from products as product");
    final List<EntityProduct> resultProducts = new ArrayList<EntityProduct>();
    for (final EntityProduct product : products) {
        if (product.name.toLowerCase().contains(text) || product.description.toLowerCase().contains(text)) {
            resultProducts.add(product);
        }
    }
%>
<html>
    <head>
        <title>НПО ТехЭлектроСервис - Результат поиска </title>
        <link type="text/css" href="styles/header.css" rel="stylesheet"/>
        <link type="text/css" href="styles/footer.css" rel="stylesheet"/>
        <link type="text/css" href="styles/searchresults.css" rel="stylesheet"/>
    </head>
    <body>
        <img id="headerBackground" src="image/header.png" alt="" style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src=image/header.png); width:expression(1); height:expression(1)">
        <jsp:include page="header.jsp" flush="true"/>
        <div id="searchResults">
            <% for (final EntityProduct product : resultProducts) { %>
                <div class="searchResultsItem">
                    <div class="searchResultsName">
                        <a href="#"><%= product.name %></a> в
                        <a href="ecology.jsp?categoryid=<%= product.category.id %>"><%= product.category.name %></a>
                    </div>
                    <div class="searchResultsDescription"><%= product.description %></div>
                </div>
            <% } %>
        </div>
        <jsp:include page="footer.jsp" flush="true"/>
    </body>
</html>