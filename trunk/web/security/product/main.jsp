<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityCategory" %>
<%@ page import="ua.com.testes.manager.view.product.ViewCategory" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityProduct" %>
<%@ page import="ua.com.testes.manager.view.product.ViewProduct" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.IOException" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityProductPrice" %>
<%@ page import="ua.com.testes.manager.view.product.ViewProductPrice" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page language='java' %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%!

    private static final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy hh:mm");

    private static void writeCategorys(
            final List<EntityCategory> categorys, final JspWriter writer) throws IOException {
        if (!categorys.isEmpty()) {
            writer.write("<ul>");
            for (final EntityCategory category : categorys) {
                writer.write("<li>");
                writer.write("<a href=\"/security/product/categorydelete.jsp?categoryId=" + category.id + "\"><img ");
                writer.write("style=\"vertical-align: middle;\" src=\"/image/delete.gif\" alt=\"Удалить\" width=\"15\" height=\"15\" border=\"0\"></a>");
                writer.write("<a href=\"/security/product/main.jsp?categoryId=" + category.id + "\">" + category.name + "</a>");
                writer.write("</li>");
                final List<EntityCategory> childCategorys = ViewCategory.getChild(category.id);
                writeCategorys(childCategorys, writer);
            }
            writer.write("</ul>");
        }
    }

%>
<%
    final ua.com.testes.manager.entity.user.EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    final List<EntityCategory> categorys = ViewCategory.getRoot();
    EntityCategory selectCategory;
    List<EntityProduct> products;
    try {
        selectCategory = ViewCategory.getById(Integer.parseInt(request.getParameter("categoryId")));
    } catch (NumberFormatException exception) {
        if (categorys.isEmpty()) {
            selectCategory = null;
        } else {
            selectCategory = categorys.get(0);
        }
    }
    if (selectCategory == null) {
        products = new ArrayList<EntityProduct>();
    } else {
        products = ViewProduct.getByCategoryId(selectCategory.id);
    }
%>
<html>
    <head>
        <title>Начало - Продукция - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            .productInfo {font-size: 12px; padding-left: 40px}

        </style>
    </head>
    <body>
        <jsp:include page="/security/util/mail/list.jsp" flush="true"/>
        <p>
            К <a href="<login:link value="/security/main.jsp"/>">главной</a> к
            <a href="<login:link value="/security/product/currency/main.jsp"/>">валютам</a>
        </p>
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top">
                    Добавить <a href="<login:link value="/security/product/categoryadd.jsp"/>">категорию</a>
                    <% writeCategorys(categorys, out); %>
                </td>
                <td valign="top" style="padding-left: 20px">
                    <% if (selectCategory == null) { %>
                        Нет ни одной категории.
                    <% } else { %>
                        <p>
                            <b><%= selectCategory.name %></b>, добавить
                            <a href="<login:link value="<%= "/security/product/productadd.jsp?categoryId=" + selectCategory.id %>"/>">продукт</a>,
                            или добавить <a href="<login:link value="<%= "/security/product/categoryadd.jsp?parentcategoryid=" + selectCategory.id %>"/>">подкатегорию</a>
                        </p>
                        <% if (products.isEmpty()) { %>
                            В этой категории к сожалению нет продуктов. Но можно
                            <a href="<login:link value="<%= "/security/product/productadd.jsp?categoryId=" + selectCategory.id %>"/>">добавить</a>
                        <% } else { %>
                            <% for (final EntityProduct product : products) { %>
                                <a href="<login:link value="<%= "/security/product/productdelete.jsp?productId=" + product.id %>"/>"><img
                                        style="vertical-align: middle;" src="/image/delete.gif" alt="Удалить"
                                        width="15" height="15" border="0"></a>
                                <%= product.name %>
                                <div class="productInfo">
                                    <a href="<login:link value="<%= "/security/product/productedit.jsp?productid=" + product.id %>"/>">редактировать</a>
                                    , добавить <a href="<login:link value="<%= "/security/product/productpriceadd.jsp?productid=" + product.id %>"/>">цену</a><br>
                                    <% final EntityProductPrice lastProductPrice = ViewProductPrice.getLastByProductId(product.id); %>
                                    <% if (lastProductPrice != null) { %>
                                        последняя цена от <%= format.format(lastProductPrice.create) %>
                                        <%= lastProductPrice.value %> <%= lastProductPrice.currency.label %>
                                    <% } %>
                                </div>
                            <% } %>
                        <% } %>
                    <% } %>
                </td>
            </tr>
        </table>
    </body>
</html>