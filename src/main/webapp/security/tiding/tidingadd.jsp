<%@ page import="ua.com.testes.manager.entity.tiding.EntityTidingCategory" %>
<%@ page import="ua.com.testes.manager.view.tiding.ViewTidingCategory" %>
<%@ page import="ua.com.testes.manager.entity.tiding.EntityTiding" %>
<%@ page import="ua.com.testes.manager.util.UtilCalendar" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityTidingCategory tidingCategory = ViewTidingCategory.getById(
            Integer.parseInt(request.getParameter("tidingcategoryid")));
%>
<html>
    <head>
        <title>Добавление новости - Новости - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="/security/tiding/main.jsp"/>">новости</a>,
        добавление новости в категорию
        <% String link1 = "/security/tiding/main.jsp?tidingCategoryId=" + tidingCategory.id; %>
        <a href="<%= link1 %>"/>"><%= tidingCategory.name %></a>
        <%
            Set<String> errors = (Set<String>) request.getAttribute("errors");
            if (errors == null) {
                errors = new HashSet<String>();
            }
            EntityTiding tiding = (EntityTiding) request.getAttribute("tiding");
            if (tiding == null) {
                tiding = new EntityTiding();
            }
        %>
        <p>
        <form action="/security/tiding/tidingaddresult.jsp" method="post">
            <login:input/>
            <input type="hidden" name="tidingcategoryid" value="<%= tidingCategory.id %>">
            <p><b>Реквизиты новости</b></p>
            <p>
                Название<br>
                <% if (errors.contains("nameempty")) { %>
                    <b>Введите пожайлусто название новости.</b><br>
                <% } %>
                <input type="text" name="tidingname" value="<%= tiding.name %>" style="width: 80%"><br>
                Собственно новость<br>
                <textarea rows="5" cols="1" style="width: 80%" name="tidingdescription"><%= tiding.description %></textarea>
                <%
                    GregorianCalendar startCalendar = null;
                    if (tiding.start != null) {
                        startCalendar = new GregorianCalendar();
                        startCalendar.setTime(tiding.start);
                    }
                %>
                <br>Дата запуска новости в работу<br>
                <select style="vertical-align: middle;" name="tidingstartyear">
                    <%
                        final GregorianCalendar calendar = new GregorianCalendar();
                        final int year = calendar.get(Calendar.YEAR);
                        int startYear = 0;
                        if (startCalendar != null) {
                            startYear = startCalendar.get(Calendar.YEAR);
                        }
                    %>
                    <% for (int i = year; i < year + 2; i++) { %>
                        <option <%= startYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                    <% } %>
                </select> ,
                <%
                    int repeatMonth = calendar.get(Calendar.MONTH);
                    if (startCalendar != null) {
                        repeatMonth = startCalendar.get(Calendar.MONTH);
                    }
                %>
                <select style="vertical-align: middle;" name="tidingstartmonth">
                    <% final List<UtilCalendar.Month> months = UtilCalendar.getDisplayMonths(request.getLocale()); %>
                    <% for (UtilCalendar.Month month : months) { %>
                    <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                        (<%= month.getDisplayOrder() %>)
                    </option>
                    <% } %>
                </select>,
                <%
                    int repeatDay = calendar.get(Calendar.DAY_OF_MONTH);
                    if (startCalendar != null) {
                        repeatDay = startCalendar.get(Calendar.DAY_OF_MONTH);
                    }
                %>
                <select name="tidingstartday" style="vertical-align: middle;">
                    <% for (int i = 1; i < 32; i++) { %>
                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                    <% } %>
                </select>
                <%
                    GregorianCalendar finishCalendar = null;
                    if (tiding.finish != null) {
                        finishCalendar = new GregorianCalendar();
                        finishCalendar.setTime(tiding.finish);
                    }
                %>
                <br>Дата завершения работы новости<br>
                <select style="vertical-align: middle;" name="tidingfinishyear">
                    <%
                        int finishYear = 0;
                        if (finishCalendar != null) {
                            finishYear = finishCalendar.get(Calendar.YEAR);
                        }
                    %>
                    <% for (int i = year; i < year + 2; i++) { %>
                        <option <%= finishYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                    <% } %>
                </select> ,
                <%
                    int finishMonth = calendar.get(Calendar.MONTH);
                    if (finishCalendar != null) {
                        finishMonth = finishCalendar.get(Calendar.MONTH);
                    }
                %>
                <select style="vertical-align: middle;" name="tidingfinishmonth">
                    <% for (UtilCalendar.Month month : months) { %>
                    <option <%= finishMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                        (<%= month.getDisplayOrder() %>)
                    </option>
                    <% } %>
                </select>,
                <%
                    int finishDay = calendar.get(Calendar.DAY_OF_MONTH);
                    if (finishCalendar != null) {
                        finishDay = finishCalendar.get(Calendar.DAY_OF_MONTH);
                    }
                %>
                <select name="tidingfinishday" style="vertical-align: middle;">
                    <% for (int i = 1; i < 32; i++) { %>
                        <option <%= finishDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                    <% } %>
                </select>
            </p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>