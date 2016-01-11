<%@ page import="ua.com.testes.manager.entity.product.EntityProduct" %>
<%@ page import="ua.com.testes.manager.view.product.ViewProduct" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityProduct product = ViewProduct.getById(Integer.parseInt(request.getParameter("productId")));
%>
<html>
    <head>
        <title>Удаление продукта - Продукция - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
            <tr>
                <td valign="center" style="padding-left: 10%; padding-right: 10%">
                    <p>
                        Вы действительно хотите удалить продукт <%= product.name %> из категори
                        <a href="<%= "/security/product/main.jsp?categoryId=" + product.category.id %>"/>"><%= product.category.name %></a>
                        или вернуться к <a href="/security/product/main.jsp"/>">продукции</a>?
                    </p>
                    <form action="/security/product/productdeleteresult.jsp" method="post">
                        <login:input/>
                        <input type="hidden" name="productid" value="<%= product.id %>">
                        <input type="submit" name="" value="Удалить">
                    </form>
                </td>
            </tr>
        </table>
    </body>
</html>