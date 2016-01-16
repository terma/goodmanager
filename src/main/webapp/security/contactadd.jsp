<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageDetailError" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="ua.com.testes.manager.util.UtilCalendar" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Добавление контакта - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <script type="text/javascript">

            function contactRepeateChange() {
                document.getElementById("contactrepeatneed").checked = true;
            }

        </script>
    </head>
    <body>
        К <a href="/security/main.jsp">разделам</a>
        <%
            int firmId;
            try {
                firmId = Integer.parseInt(request.getParameter("firmId"));
            } catch (NumberFormatException exception) {
                response.sendRedirect("/security/main.jsp");
                return;
            }
            Integer pipolId;
            try {
                pipolId = Integer.parseInt(request.getParameter("pipolId"));
            } catch (NumberFormatException exception) {
                pipolId = null;
            }
            Integer statusId;
            try {
                statusId = Integer.parseInt(request.getParameter("statusId"));
            } catch (NumberFormatException exception) {
                statusId = null;
            }
            final List<PageDetailError> errors =
                    (List<PageDetailError>) request.getAttribute("errors");
            EntityContact contact = (EntityContact) request.getAttribute("contact");
            if (contact == null) {
                contact = new EntityContact();
            }
        %>
        или к <a href="/security/detail.jsp?firmId=<%= firmId %>">фирме</a>
        <p>
        <form action="/security/contactaddresult.jsp" method="post">
            Сотрудник для беседы<br>
            <select name="pipolId" style="vertical-align: middle; width: 80%">
                <%
                    final int tempFirmId = firmId;
                    final List<EntityPipol> pipolList = EntityManager.list(
                        "select pipol from ua.com.testes.manager.entity.EntityPipol as pipol where id_parent = " +
                        tempFirmId + " order by fio");
                %>
                <% for (final EntityPipol pipol : pipolList) { %>
                <option value="<%= pipol.getId() %>" <%= pipol.getId().equals(pipolId) ? "selected" : "" %>>
                    <%= pipol.getFio() %>
                </option>
                <% } %>
            </select><p>
            <input type="hidden" name="firmId" value="<%= firmId %>">
            <p><b>Реквизиты первого контакта</b>
            <p>
                Статус<br>
                <select name="statusId" style="vertical-align: middle; width: 80%">
                    <%
                        final List<EntityStatus> statuses = EntityManager.list(
                            "select status from ua.com.testes.manager.entity.EntityStatus as status");
                     %>
                    <% for (final EntityStatus status : statuses) { %>
                    <option <%= status.id.equals(statusId) ? "selected" : "" %>
                            value="<%= status.id %>"><%= status.name %>
                    </option>
                    <% } %>
                </select>
            
            <p>
                <% final GregorianCalendar repeatCalendar = new GregorianCalendar(); %>

                Нужно ли перезвонить
                <input type="checkbox" name="contactrepeatneed" id="contactrepeatneed" style="vertical-align: middle;">
                и когда, скажем

                <% if (errors != null && errors.contains(PageDetailError.CONTACT_REPEATE_DATE_INCORRENT)) { %>
                    <br><b>Введите пожайлусто правильно дату, так чтобы она была больше чем сегодня.</b>
                <% } %>

                <ul style="list-style: none">
                    <li>
                        <input type="radio" style="vertical-align: middle;" value="delta" name="contactrepeattype"> через
                        <select name="contactrepeatdeltamonth" style="vertical-align: middle;" onchange="contactRepeateChange()">
                            <option selected value="0">Нисколько месяцев</option>
                            <option value="1">1 месяц</option>
                            <option value="2">2 месяца</option>
                            <option value="3">3 месяца</option>
                            <option value="4">4 месяца</option>
                            <option value="5">5 месяца</option>
                            <option value="6">6 месяца</option>
                            <option value="7">7 месяца</option>
                        </select> и
                        <select name="contactrepeatdeltaday" style="vertical-align: middle;" onchange="contactRepeateChange()">
                            <option selected value="0">Нисколько дней</option>
                            <option value="1">1 день</option>
                            <option value="2">2 дней</option>
                            <option value="3">3 дней</option>
                            <option value="4">4 дней</option>
                            <option value="5">5 дней</option>
                            <option value="6">6 дней</option>
                            <option value="7">7 дней</option>
                            <option value="10">10 дней</option>
                            <option value="20">20 дней</option>
                        </select>
                    </li>
                    <li>&nbsp;</li>
                    <li>
                        <input checked type="radio" value="date" style="vertical-align: middle;" name="contactrepeattype">
                        или именно этого числа
                        <% final int repeatYear = repeatCalendar.get(Calendar.YEAR); %>
                        <select style="vertical-align: middle;" name="contactrepeatdateyear" onchange="contactRepeateChange()">
                            <% final int year = repeatCalendar.get(Calendar.YEAR); %>
                            <% for (int i = year; i < year + 2; i++) { %>
                                <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                            <% } %>
                        </select> ,
                        <% final int repeatMonth = repeatCalendar.get(Calendar.MONTH) + 1; %>
                        <select style="vertical-align: middle;" name="contactrepeatdatemonth" onchange="contactRepeateChange()">
                            <% final List<UtilCalendar.Month> months = UtilCalendar.getDisplayMonths(request.getLocale()); %>
                            <% for (UtilCalendar.Month month : months) { %>
                                <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                    (<%= month.getDisplayOrder() %>)
                                </option>
                            <% } %>
                        </select>,
                        <% final int repeatDay = repeatCalendar.get(Calendar.DAY_OF_MONTH); %>
                        <select name="contactrepeatdateday" style="vertical-align: middle;" onchange="contactRepeateChange()">
                            <% for (int i = 1; i < 32; i++) { %>
                                <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                            <% } %>
                        </select>
                    </li>
                </ul>
            </p>
            
            <p>
                Беседа<br>
                <% if (errors != null && errors.contains(PageDetailError.CONTACT_DESCRIPTION_EMPTY)) { %>
                <b>Введите пожайлусто текст беседы с сотрудником.</b>
                <% }
        String result = contact.description;
    %>
                <textarea rows="8" name="contactdescription" cols="" style="width: 80%"><%= result %></textarea><p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>