<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.logic.activeX1c.product.category.LogicActiveX1cProductCategory" %>
<%@ page import="ua.com.testes.manager.logic.activeX1c.product.category.LogicActiveX1cProductCategoryManager" %>
<%@ page import="ua.com.testes.manager.logic.activeX1c.product.storage.LogicActiveX1cProductStorage" %>
<%@ page import="ua.com.testes.manager.logic.activeX1c.product.storage.LogicActiveX1cProductStorageManager" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.util.Collections" %>
<%@ page language='java' %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%!

    private static void writeCategorys(
            final List<LogicActiveX1cProductCategory> logicActiveX1cProductCategories,
            final JspWriter writer, final EntityUser user) throws IOException {
        if (!logicActiveX1cProductCategories.isEmpty()) {
            writer.write("<ul>");
            for (final LogicActiveX1cProductCategory logicActiveX1cProductCategory : logicActiveX1cProductCategories) {
                writer.write("<li>");
                writer.write(
                        "<a href=\"/security/product/storage/main.jsp?categoryid=" +
                                logicActiveX1cProductCategory.categoryId + "\">" +
                                logicActiveX1cProductCategory.categoryName + "</a>");
                writer.write("</li>");
                final List<LogicActiveX1cProductCategory> childCategorys =
                        LogicActiveX1cProductCategoryManager.getByCategory(
                                user, logicActiveX1cProductCategory.categoryId);
                writeCategorys(childCategorys, writer, user);
            }
            writer.write("</ul>");
        }
    }

    private static final Comparator<LogicActiveX1cProductStorage> productStorageByName = new Comparator<LogicActiveX1cProductStorage>() {

        public int compare(LogicActiveX1cProductStorage o1, LogicActiveX1cProductStorage o2) {
            return o1.productName.compareTo(o2.productName);
        }

    };

%>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final List<LogicActiveX1cProductCategory> logicActiveX1cProductCategories = LogicActiveX1cProductCategoryManager.getRoot(user);
    final String logicActiveX1cProductCategoryId = request.getParameter("categoryid");
    List<LogicActiveX1cProductStorage> logicActiveX1cProductStorages;

    if (logicActiveX1cProductCategoryId == null) {
        logicActiveX1cProductStorages = new ArrayList<LogicActiveX1cProductStorage>();
    } else {
        logicActiveX1cProductStorages =
                LogicActiveX1cProductStorageManager.getByCategory(user, logicActiveX1cProductCategoryId);
        Collections.sort(logicActiveX1cProductStorages, productStorageByName);
    }
%>
<html>
    <head>
        <title>Склад - Продукция - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            .productInfo {font-size: 12px; padding-left: 40px}
            .productCount {color: #12871A; font-weight: bold;}
            .productCountReserved {color: #9D2424; font-weight: bold;}
            .productCountZero {color: #9D2424; font-weight: bold;}

        </style>
    </head>
    <body>
        <jsp:include page="/security/util/mail/list.jsp" flush="true"/>
        <jsp:include page="/security/util/rate/list.jsp" flush="true"/>
        <p>
            К <a href="<login:link value="/security/main.jsp"/>">главной</a>
        </p>
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top">
                    <% writeCategorys(logicActiveX1cProductCategories, out, user); %>
                </td>
                <td valign="top" style="padding-left: 20px">
                    <% if (logicActiveX1cProductCategoryId == null) { %>
                        Нет ни одной категории.
                    <% } else { %>
                        <% if (logicActiveX1cProductStorages.isEmpty()) { %>
                            В этой категории к сожалению нет продуктов.
                        <% } else { %>
                            <form action="/security/product/storage/productorder.jsp" method="post">
                                <table border="0" cellspacing="0" cellpadding="5">
                                    <tbody>
                                        <% int i = 0; %>
                                        <% for (final LogicActiveX1cProductStorage logicActiveX1cProductStorage : logicActiveX1cProductStorages) { %>
                                            <tr bgcolor="<%= i++ % 2 == 0 ? "#F8F8F8" : "#ffffff" %>">
                                                <td><%= logicActiveX1cProductStorage.productName %></td>
                                                <td>шт.</td>
                                                <td>
                                                    <% if (logicActiveX1cProductStorage.productCount > 0) { %>
                                                        <span class="productCount">на складе <%= logicActiveX1cProductStorage.productCount %></span>
                                                    <% } else { %>
                                                        <span class="productCountZero">на складе нет</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <% if (logicActiveX1cProductStorage.productCountReserved > 0) { %>
                                                        <span class="productCountReserved">зарезервированные <%= logicActiveX1cProductStorage.productCountReserved %></span>
                                                    <% } else { %>
                                                        <span class="productCountZero">в резерве нет</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <% if (logicActiveX1cProductStorage.productCount > 0) { %>
                                                        <input type="text" name="productcount" style="width: 40px" value="0">
                                                    <% } else { %>
                                                        &nbsp;
                                                    <% } %>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                                <input type="submit" name="ok" value="Добавить в заказ">
                            </form>
                        <% } %>
                    <% } %>
                </td>
            </tr>
        </table>
    </body>
</html>