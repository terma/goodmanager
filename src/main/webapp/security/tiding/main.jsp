<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="ua.com.testes.manager.view.tiding.ViewTidingCategory" %>
<%@ page import="ua.com.testes.manager.entity.tiding.EntityTidingCategory" %>
<%@ page import="ua.com.testes.manager.entity.tiding.EntityTiding" %>
<%@ page import="ua.com.testes.manager.view.tiding.ViewTiding" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page language='java' %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
    final ua.com.testes.manager.entity.user.EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    final List<EntityTidingCategory> tidingCategorys = ViewTidingCategory.getAll();
    EntityTidingCategory selectTidingCategory;
    List<EntityTiding> tidings;
    try {
        selectTidingCategory = ViewTidingCategory.getById(Integer.parseInt(request.getParameter("tidingCategoryId")));
    } catch (NumberFormatException exception) {
        if (tidingCategorys.isEmpty()) {
            selectTidingCategory = null;
        } else {
            selectTidingCategory = tidingCategorys.get(0);
        }
    }
    if (selectTidingCategory == null) {
        tidings = new ArrayList<EntityTiding>();
    } else {
        tidings = ViewTiding.getByCategoryId(selectTidingCategory.id);
    }
%>
<html>
    <head>
        <title>Начало - Новости - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="/security/util/mail/list.jsp" flush="true"/>
        <p>
            К <a href="/security/main.jsp"/>">главной</a>
        </p>
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top">
                    Добавить <a href="/security/tiding/categoryadd.jsp"/>">категорию</a>
                    <ul>
                        <% for (final EntityTidingCategory category : tidingCategorys) { %>
                            <li>
                                <% String link1 = "/security/tiding/main.jsp?tidingCategoryId=" + category.id; %>
                                <a href="<%= link1 %>"/>"><%= category.name %></a>
                            </li>
                        <% } %>
                    </ul>
                </td>
                <td valign="top" style="padding-left: 20px">
                    <% if (selectTidingCategory == null) { %>
                        Нет ни одной категории новостей.
                    <% } else { %>
                        <p>
                            <b><%= selectTidingCategory.name %></b>, добавить
                            <% String link2 = "/security/tiding/tidingadd.jsp?tidingcategoryid=" + selectTidingCategory.id; %>
                            <a href="<%= link2 %>"/>">новость</a>
                        </p>
                        <% if (tidings.isEmpty()) { %>
                            В этой категории к сожалению нет новостей. Но можно
                            <% String link3 = "/security/tiding/tidingadd.jsp?tidingCategoryId=" + selectTidingCategory.id; %>
                            <a href="<%= link3 %>"/>">добавить</a>
                        <% } else { %>
                            <% for (final EntityTiding tiding : tidings) { %>
                                <%= tiding.name %><br>
                            <% } %>
                        <% } %>
                    <% } %>
                </td>
            </tr>
        </table>
    </body>
</html>