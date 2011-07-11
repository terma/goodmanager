<%@ page import="ua.com.testes.manager.entity.product.EntityCategory" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityProduct" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer selectCategoryId = null;
    try {
        selectCategoryId = Integer.parseInt(request.getParameter("categoryid"));
    } catch (NumberFormatException exception) {
    }
    EntityCategory selectCategory = null;
    if (selectCategoryId != null) {
        selectCategory = EntityManager.get().find(EntityCategory.class, selectCategoryId);
    }
%>
<html>
    <head>
        <title>НПО ТехЭлектроСервис - Решения по экологии <%= selectCategory != null ? " - " + selectCategory.name : "" %></title>
        <link type="text/css" href="styles/header.css" rel="stylesheet"/>
        <link type="text/css" href="styles/footer.css" rel="stylesheet"/>
        <link type="text/css" href="styles/tree.css" rel="stylesheet"/>
        <link type="text/css" href="styles/products.css" rel="stylesheet"/>
        <style type="text/css">

            body, div, td {
                color: white;
                font-size: 14pt;
            }

        </style>
    </head>
    <body>
        <img id="headerBackground" src="image/header.png" alt="" style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src=image/header.png); width:expression(1); height:expression(1)">
        <jsp:include page="header.jsp" flush="true"/>
        <jsp:include page="tree.jsp" flush="true"/>
        <div id="products">
            <% if (selectCategory != null) { %>
                <% for (EntityProduct product : selectCategory.products) { %>
                    <div class="product">
                        <div class="productName"><a href="#" class="productNameLink"><%= product.name %></a></div>
                        <div class="productDescription"><%= product.description %></div>
                    </div>
                <% } %>
            <% } %>
        </div>
        <jsp:include page="footer.jsp" flush="true"/>
    </body>
</html>