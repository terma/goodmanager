<%@ page import="ua.com.testes.manager.web.page.PageDetailError" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.util.UtilCalendar" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Добавление фирмы - <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <script type="text/javascript">

            function contactRepeateChange() {
                document.getElementById("contactrepeatneed").checked = true;
            }

        </script>
    </head>
    <body>
        К <a href="<login:link value="/security/main.jsp"/>">разделам</a>
        <%
            Integer firmId;
            try {
                firmId = Integer.parseInt(request.getParameter("firmId"));
            } catch (NumberFormatException exception) {
                firmId = null;
            }
            final List<PageDetailError> errors =
                (List<PageDetailError>) request.getAttribute("errors");
            EntityPipol pipol = (EntityPipol) request.getAttribute("pipol");
            EntityContact contact;
            if (pipol == null) {
                pipol = new EntityPipol();
                contact = new EntityContact();
                pipol.getContacts().add(contact);
            } else {
                contact = pipol.getContacts().get(0);
            }
        %>
        <% if(firmId != null) { %>
            или к <a href="<login:link value='<%= "detail.jsp?firmId=" + firmId %>'/>">фирме</a>
        <% } %>
        <p>
        <form action="/security/pipoladdresult.jsp" method="post">
            <login:input/>
            Раздел в который добавить фирму<br>
            <select name="firmId" style="vertical-align: middle; width: 80%">
                <%
                    final List<EntityFirm> firms = EntityManager.list(
                        "select firm from ua.com.testes.manager.entity.EntityFirm as firm where firm.delete = null order by name");
                %>
                <% for (final EntityFirm firm : firms) { %>
                    <option value="<%= firm.getId() %>" <%= firm.getId().equals(firmId) ? "selected" : "" %>>
                        <%= firm.getName() %> из <%= firm.getSection().getName() %>
                    </option>
                <% } %>
            </select>
            <p><b>Реквизиты сотрудника</b><p>
            ФИО (например: Пушкин Сергей Александрович)<br>
            <% if (errors != null && errors.contains(PageDetailError.PIPOL_FIO_EMPTY)) { %>
                <b>Введите пожайлусто ФИО сотрудника.</b><br>
            <% } %>
            <% if (errors != null && errors.contains(PageDetailError.PIPOL_FIO_NOT_UNIQUE)) { %>
                <b>Введите пожайлусто уникальное ФИО сотрудника.</b><br>
            <% } %>
            <input type="text" name="pipolfio" value="<%= pipol.getFio() %>" style="width: 80%"><br>
            Телефон<br>
            <input type="text" name="pipoltelephon" value="<%= pipol.getTelephon() %>" style="width: 80%"><br>
            Электропочта<br>
            <input type="text" name="pipolemail" value="<%= pipol.getEmail() %>" style="width: 80%"><br>
            Должность<br>
            <input type="text" name="pipolrank" value="<%= pipol.getRang() %>" style="width: 80%"><br>
            Заметки<br>
            <textarea rows="5" name="pipoldescription" cols="" style="width: 80%"><%= pipol.getDescription() %></textarea>
            <p><b>Реквизиты первого контакта</b><p>
            Статус<br>
            <select name="statusId" style="vertical-align: middle; width: 80%">
                <%
                    final List<EntityStatus> statuses = EntityManager.list(
                        "select status from ua.com.testes.manager.entity.EntityStatus as status");
                %>
                <% for (final EntityStatus status : statuses) { %>
                    <option value="<%= status.id %>"><%= status.name %></option>
                <% } %>
            </select><p>
            <p>
                <%
                    GregorianCalendar repeatCalendar = null;
                    if (contact.getRepeat() != null) {
                        repeatCalendar = new GregorianCalendar();
                        repeatCalendar.setTime(contact.getRepeat());
                    }
                %>
                Нужно ли перезвонить <input type="checkbox" <%= contact.getRepeat() != null ? "checked" : "" %> name="contactrepeatneed" style="vertical-align: middle;">
                и когда, скажем
                <% if (errors != null && errors.contains(PageDetailError.CONTACT_REPEATE_DATE_INCORRENT)) { %>
                    <br><b>Введите пожайлусто правильно дату, так чтобы она была больше чем сегодня.</b>
                <% } %>
                <ul style="list-style: none">
                    <li>
                        <input onchange="contactRepeateChange()" type="radio" style="vertical-align: middle;" value="delta" name="contactrepeattype"> через
                        <select onchange="contactRepeateChange()" name="contactrepeatdeltamonth" style="vertical-align: middle;">
                            <option selected value="0">Нисколько месяцев</option>
                            <option value="1">1 месяц</option>
                            <option value="2">2 месяца</option>
                            <option value="3">3 месяца</option>
                            <option value="4">4 месяца</option>
                            <option value="5">5 месяца</option>
                            <option value="6">6 месяца</option>
                            <option value="7">7 месяца</option>
                        </select> и
                        <select onchange="contactRepeateChange()" name="contactrepeatdeltaday" style="vertical-align: middle;">
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
                        <input checked type="radio" value="date" onchange="contactRepeateChange()" style="vertical-align: middle;" name="contactrepeattype">
                        или именно этого числа
                        <%
                            int repeatYear = 0;
                            if (repeatCalendar != null) {
                                repeatYear = repeatCalendar.get(Calendar.YEAR);
                            }
                        %>
                        <select onchange="contactRepeateChange()" style="vertical-align: middle;" name="contactrepeatdateyear">
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
                                repeatMonth = repeatCalendar.get(Calendar.MONTH);
                            }
                        %>
                        <select onchange="contactRepeateChange()" style="vertical-align: middle;" name="contactrepeatdatemonth">
                            <% final List<UtilCalendar.Month> months = UtilCalendar.getDisplayMonths(request.getLocale()); %>
                            <% for (UtilCalendar.Month month : months) { %>
                                <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %> (<%= month.getDisplayOrder() %>)</option>
                            <% } %>
                        </select>,
                        <%
                            int repeatDay = calendar.get(Calendar.DAY_OF_MONTH);
                            if (repeatCalendar != null) {
                                repeatDay = repeatCalendar.get(Calendar.DAY_OF_MONTH);
                            }
                        %>
                        <select onchange="contactRepeateChange()" name="contactrepeatdateday" style="vertical-align: middle;">
                            <% for (int i = 1; i < 32; i++) { %>
                                <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                            <% } %>
                        </select>
                    </li>
                </ul>
            </p>
            Беседа<br>
            <% if (errors != null && errors.contains(PageDetailError.CONTACT_DESCRIPTION_EMPTY)) { %>
                <b>Введите пожайлусто текст беседы с сотрудником.</b>
            <% } %>
            <textarea rows="8" name="contactdescription" cols="" style="width: 80%"><%= contact.getDescription() %></textarea><p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>