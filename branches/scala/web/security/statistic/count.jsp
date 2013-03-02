<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.web.page.PageStatistic" %>
<%@ page import="ua.com.testes.manager.logic.style.LogicStyle" %>
<%@ page import="ua.com.testes.manager.util.UtilCalendar" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Статистика - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <script type="text/javascript">

            function statisticSectionAllSelect() {
                var i = 0;
                var section = document.getElementById("statisticsection" + i);
                while (section) {
                    section.checked = true;
                    i++;
                    section = document.getElementById("statisticsection" + i);
                }
            }

            function statisticUserAllSelect() {
                var i = 0;
                var user = document.getElementById("statisticuser" + i);
                while (user) {
                    user.checked = true;
                    i++;
                    user = document.getElementById("statisticuser" + i);
                }
            }

            function statisticStatusAllSelect() {
                var i = 0;
                var status = document.getElementById("statisticstatus" + i);
                while (status) {
                    status.checked = true;
                    i++;
                    status = document.getElementById("statisticstatus" + i);
                }
            }

            function statisticPeriodChange() {
                document.getElementById("statisticperiod").checked = true;
            }

        </script>
    </head>
    <body>
        <%
            // Сеанс пользователя
            final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));

            // Выбираем если есть перечень ошибок
            final Set<PageStatistic.Error> errors = (Set<PageStatistic.Error>) request.getAttribute("errors");

            // Выбираем условия для статистики из сесии
            PageStatistic pageStatistic = (PageStatistic) session.getAttribute("pageStatistic");
            if (pageStatistic == null) pageStatistic = new PageStatistic();
        %>
        <p>Назад к <a href="/security/main.jsp">разделам</a></p>
        <form action="/security/statistic/countgraph.jsp" method="post">
        <login:input/>
        <table border="0" cellpadding="0" cellspacing="5" width="100%">
            <tr>
                <td valign="top">
                    <p>
                        Выберете менеджеров, можно <a href="javascript:statisticUserAllSelect()">всех</a>
                        <%
                            final List<ua.com.testes.manager.entity.user.EntityUser> users = EntityManager.list(
                                    "select user from ua.com.testes.manager.entity.user.EntityUser as user");
                        %>
                        <ul style="list-style: none">
                            <% int i = 0; %>
                            <% for (final EntityUser tempUser : user.getGroup().allowStatistic(users)) { %>
                                <li><input type="checkbox" id="statisticuser<%= i %>"
                                        <%= pageStatistic.userIds.contains(tempUser.getId()) ? "checked" : "" %>
                                        value="<%= tempUser.getId() %>" name="statisticuser"> <%= tempUser.getFio() %></li>
                                <% i++; %>
                            <% } %>
                        </ul>
                    </p>
                    <p>
                        А также статус, контактов, <a href="javascript:statisticStatusAllSelect()">всех</a>
                        <ul style="list-style: none">
                            <%
                                final List<EntityStatus> statuses = EntityManager.list(
                                        "select status from ua.com.testes.manager.entity.EntityStatus as status order by order desc");
                            %>
                            <% i = 0; %>
                            <% for (EntityStatus status : statuses) { %>
                                <li><input type="checkbox" id="statisticstatus<%= i %>"
                                        <%= pageStatistic.statusIds.contains(status.id) ? "checked" : "" %>
                                        name="statisticstatus" value="<%= status.id %>"> <%= status.name %></li>
                                <% i++; %>
                            <% } %>
                        </ul>
                    </p>
                    <p>
                        Учитывать контакты из периода
                        <input type="checkbox" <%= pageStatistic.period ? "checked" : "" %>
                                name="statisticperiod" id="statisticperiod" style="vertical-align: middle;">
                        <% if (errors != null && errors.contains(PageStatistic.Error.INCORRECT_DATE)) { %>
                            <p><b>Пожайлусто введите верную начальную и конечную дату!</b></p>
                        <% } %>
                        <% if (errors != null && errors.contains(PageStatistic.Error.START_AFTER_FINISH_DATE)) { %>
                            <p><b>Пожайлусто введите начальную дату до конечной!</b></p>
                        <% } %>
                        <ul style="list-style: none">
                            <li>
                                с <select size="1" style="vertical-align: middle;" name="statisticstartyear" onchange="statisticPeriodChange()">
                                    <%
                                        final GregorianCalendar startCalendar = new GregorianCalendar();
                                        final GregorianCalendar finishCalendar = new GregorianCalendar();
                                        startCalendar.setTime(pageStatistic.start);
                                        finishCalendar.setTime(pageStatistic.finish);
                                        final GregorianCalendar calendar = new GregorianCalendar();
                                        final int year = calendar.get(Calendar.YEAR);
                                        final List<UtilCalendar.Month> months =
                                                UtilCalendar.getDisplayMonths(request.getLocale());
                                    %>
                                    <% for (i = year - 5; i < year + 1; i++) { %>
                                        <option <%= startCalendar.get(Calendar.YEAR) == i ? "selected" : "" %>
                                                value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                                <select name="statisticstartmonth" size="1" style="vertical-align: middle;" onchange="statisticPeriodChange()">
                                    <% for (final UtilCalendar.Month month : months) { %>
                                        <option <%= startCalendar.get(Calendar.MONTH) == month.order ? "selected" : "" %>
                                                value="<%= month.order %>"><%= month.name %> (<%= month.getDisplayOrder() %>)</option>
                                    <% } %>
                                </select>
                                <select size="1" style="vertical-align: middle;" name="statisticstartday" onchange="statisticPeriodChange()">
                                    <% for (i = 1; i < 32; i++) { %>
                                        <option <%= startCalendar.get(Calendar.DATE) == i ? "selected" : "" %>
                                                value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                            </li>
                            <li>&nbsp;</li>
                            <li>
                                по <select name="statisticfinishyear" size="1" style="vertical-align: middle;" onchange="statisticPeriodChange()">
                                    <% for (i = year - 5; i < year + 1; i++) { %>
                                        <option <%= finishCalendar.get(Calendar.YEAR) == i ? "selected" : "" %>
                                                value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                                <select name="statisticfinishmonth" size="1" style="vertical-align: middle;" onchange="statisticPeriodChange()">
                                    <% for (final UtilCalendar.Month month : months) { %>
                                        <option <%= finishCalendar.get(Calendar.MONTH) == month.order ? "selected" : "" %>
                                                value="<%= month.order %>"><%= month.name %> (<%= month.getDisplayOrder() %>)</option>
                                    <% } %>
                                </select>
                                <select name="statisticfinishday" size="1" style="vertical-align: middle;" onchange="statisticPeriodChange()">
                                    <% for (i = 1; i < 32; i++) { %>
                                        <option <%= finishCalendar.get(Calendar.DATE) == i ? "selected" : "" %>
                                                value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                            </li>
                        </ul>    
                    </p>
                </td>
                <td valign="top">
                    Выберете разделы, можно <a href="javascript:statisticSectionAllSelect()">все</a>
                    <%
                        final List<EntitySection> sections = EntityManager.list(
                            "select section from ua.com.testes.manager.entity.EntitySection as section");
                    %>
                    <ul style="list-style: none">
                        <% i = 0; %>
                        <% for (EntitySection section : sections) { %>
                            <li><input id="statisticsection<%= i %>"
                                    <%= pageStatistic.sectionIds.contains(section.getId()) ? "checked" : "" %>
                                    name="statisticsection" value="<%= section.getId() %>" type="checkbox"> <%= LogicStyle.getHtml(section.getStyle(), section.getName()) %></li>
                            <% i++; %>
                        <% } %>
                    </ul>
                </td>
            </tr>
        </table>
            <p>
                <input type="submit" value="График">    
            </p>
        </form>
    </body>
</html>