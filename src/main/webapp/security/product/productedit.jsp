<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="ua.com.testes.manager.logic.product.LogicProductError" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityProduct" %>
<%@ page import="ua.com.testes.manager.view.product.ViewProduct" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityProduct product = ViewProduct.getById(Integer.parseInt(request.getParameter("productid")));
%>
<html>
    <head>
        <title>Редактирование продукта - Продукция - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <script type="text/javascript" src="../../fckeditor/fckeditor.js"></script>
        <script type="text/javascript">

            window.onload = function() {
                var fckEditor = new FCKeditor("productdescription");
                fckEditor.BasePath = "../../fckeditor/";
                fckEditor.Height = 350;
                fckEditor.ReplaceTextarea();
            }

        </script>
    </head>
    <body>
        К <a href="/security/product/main.jsp"/>">продукции</a>,
        редактирование продукта <%= product.name %> в категори
        <a href="<%= "/security/product/main.jsp?categoryId=" + product.category.id %>"/>"><%= product.category.name %></a>
        <%
            Set<LogicProductError> errors = (Set<LogicProductError>) request.getAttribute("errors");
            if (errors == null) errors = new HashSet<LogicProductError>();
            final String productName = (String) request.getAttribute("productname");
            final String productDescription = (String) request.getAttribute("productdescription");
        %>
        <p>
        <form action="/security/product/producteditresult.jsp" method="post">
            <login:input/>
            <input type="hidden" name="productid" value="<%= product.id %>">
            <p><b>Реквизиты продукции</b></p>
            <p>
                Название<br>
                <% if (errors.contains(LogicProductError.NAME_EMPTY)) { %>
                    <b>Введите пожайлусто название продукта.</b><br>
                <% } %>
                <% if (errors.contains(LogicProductError.NAME_NOT_UNIQUE)) { %>
                    <b>Введите пожайлусто уникальное название продукта.</b><br>
                <% } %>
                <input type="text" name="productname" value="<%= productName == null ? product.name : productName %>" style="width: 80%"><br>
                Описание<br>
                <textarea rows="5" cols="1" name="productdescription" style="width: 80%"><%= productDescription == null ? product.description : productDescription %></textarea>
            </p>
            <input type="submit" name="" value="Сохранить">
        </form>
    </body>
</html>