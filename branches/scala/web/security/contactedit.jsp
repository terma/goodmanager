<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageDetailError" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.util.UtilCalendar" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Редактирование контакта - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <script type="text/javascript">

            function contactRepeateChange() {
                document.getElementById("contactrepeatneed").checked = true;
            }

        </script>
    </head>
    <body>
        К <a href="/security/main.jsp">разделам</a>
        <p>
        <form action="/security/contacteditresult.jsp" method="post">
            <%
                EntityContact editContact = (EntityContact) request.getAttribute("contact");
                if (editContact == null) {
                    EntityContact contact = EntityManager.find(EntityContact.class, Integer.parseInt(request.getParameter("contactId")));
                    editContact = new EntityContact();
                    editContact.id = contact.id;
                    editContact.description = contact.description;
                    editContact.repeat = contact.repeat;
                    editContact.user = contact.user;
                    editContact.status = contact.status;
                    editContact.pipol = contact.pipol;
                }
                final List<PageDetailError> errors = (List<PageDetailError>) request.getAttribute("errors");
            %>
            <input type="hidden" name="contactid" value="<%= editContact.id %>">
            Контакт с сотрудником <a href="mailto:<%= editContact.pipol.getEmail() %>"><%= editContact.pipol.getFio() %></a> из
            <a href="<%= "/security/detail.jsp?firmId=" + editContact.pipol.getFirm().getId() %>"><%= editContact.pipol.getFirm().getName() %></a>
            раздел <a href="<%= "/security/list.jsp?sectionId=" + editContact.pipol.getFirm().getSection().getId() %>"><%= editContact.pipol.getFirm().getSection().getName() %></a><br>
            <p>
                <b>Реквизиты контакта</b>
                <p>
                    <label for="status">Статус</label><br>
                    <select id="status" name="statusId" style="vertical-align: middle; width: 80%">
                        <%
                            final List<EntityStatus> statuses = EntityManager.list(
                                "select status from ua.com.testes.manager.entity.EntityStatus as status");
                        %>
                        <% for (final EntityStatus status : statuses) { %>
                            <option <%= status == editContact.status ? "selected" : "" %> value="<%= status.id %>">
                                <%= status.name %>
                            </option>
                        <% } %>
                    </select><br>

                    <%
                        GregorianCalendar repeatCalendar = null;
                        if (editContact.repeat != null) {
                            repeatCalendar = new GregorianCalendar();
                            repeatCalendar.setTime(editContact.repeat);
                        }
                        Date result2 = editContact.repeat;
                    %>
                    Нужно ли перезвонить <input type="checkbox" <%= result2 != null ? "checked" : "" %> name="contactrepeatneed"
                        id="contactrepeatneed" style="vertical-align: middle;"> и когда, скажем
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
                            <%
                                int repeatYear = 0;
                                if (repeatCalendar != null) {
                                    repeatYear = repeatCalendar.get(Calendar.YEAR);
                                }
                            %>
                            <select style="vertical-align: middle;" name="contactrepeatdateyear" onchange="contactRepeateChange()">
                                <%
                                    final GregorianCalendar calendar = new GregorianCalendar();
                                    final int year = calendar.get(Calendar.YEAR);
                                %>
                                <% for (int i = year; i < year + 2; i++) { %>
                                    <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                <% } %>
                            </select> ,
                            <%
                                int repeatMonth = calendar.get(Calendar.MONTH);
                                if (repeatCalendar != null) {
                                    repeatMonth = repeatCalendar.get(Calendar.MONTH) + 1;
                                }
                            %>
                            <select style="vertical-align: middle;" name="contactrepeatdatemonth" onchange="contactRepeateChange()">
                                <% final List<UtilCalendar.Month> months = UtilCalendar.getDisplayMonths(request.getLocale()); %>
                                <% for (UtilCalendar.Month month : months) { %>
                                    <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                        (<%= month.getDisplayOrder() %>)
                                    </option>
                                <% } %>
                            </select>,
                            <%
                                int repeatDay = calendar.get(Calendar.DAY_OF_MONTH);
                                if (repeatCalendar != null) {
                                    repeatDay = repeatCalendar.get(Calendar.DAY_OF_MONTH);
                                }
                            %>
                            <select name="contactrepeatdateday" style="vertical-align: middle;" onchange="contactRepeateChange()">
                                <% for (int i = 1; i < 32; i++) { %>
                                    <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                <% } %>
                            </select>
                        </li>
                    </ul>

                    Беседа<br>
                    <% if (errors != null && errors.contains(PageDetailError.CONTACT_DESCRIPTION_EMPTY)) { %>
                        <b>Введите пожайлусто текст беседы с сотрудником.</b>
                    <% } %>
                    <textarea rows="8" name="contactdescription" cols="" style="width: 80%"><%= editContact.description %></textarea>
                </p>
            </p>
            <input type="submit" name="" value="Сохранить">
        </form>
    </body>
</html>