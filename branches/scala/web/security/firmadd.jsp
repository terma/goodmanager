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
        <title>Добавление фирмы - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <script type="text/javascript" src="../dwr/engine.js"></script>
        <script type="text/javascript" src="../dwr/interface/FirmNamesService.js"></script>
        <script type="text/javascript">

            function contactRepeateChange() {
                document.getElementById("contactrepeatneed").checked = true;
            }

            function findLikeForFirmName() {
                document.getElementById("firmlikenames").innerHTML =
                "Сейчас поищем фирмы с похожим названием...";
                var firmName = document.getElementById("firmName").value;
                FirmNamesService.findLike(firmName, function (firmNamesResponse) {
                    document.getElementById("firmlikenames").innerHTML = firmNamesResponse;    
                });
            }

        </script>
    </head>
    <body>
        К <a href="<login:link value="main.jsp"/>">разделам</a>
        <p>
        <form action="firmaddresult.jsp" method="post">
            <login:input/>
        <%
            Integer sectionId;
            try {
                sectionId = Integer.parseInt(request.getParameter("sectionId"));
            } catch (NumberFormatException exception) {
                sectionId = null;
            }
        %>
        Раздел в котором фирм<br>
        <select name="sectionId" style="vertical-align: middle; width: 80%">
            <%
                List<EntitySection> sections = EntityManager.list(
                    "select section from ua.com.testes.manager.entity.EntitySection as section");
            %>
            <% for (final EntitySection section : sections) { %>
                <option value="<%= section.getId() %>" <%= section.getId().equals(sectionId) ? "selected" : "" %>><%= section.getName() %></option>
            <% } %>
        </select>
        <p>
            <%
                final List<PageDetailError> errors =
                    (List<PageDetailError>) request.getAttribute("errors");
                EntityFirm firm = (EntityFirm) request.getAttribute("firm");
                EntityPipol pipol;
                EntityContact contact;
                if (firm == null) {
                    firm = new EntityFirm();
                    pipol = new EntityPipol();
                    firm.getPipols().add(pipol);
                    contact = new EntityContact();
                    pipol.getContacts().add(contact);
                } else {
                    pipol = firm.getPipols().get(0);
                    contact = pipol.getContacts().get(0);
                }
            %>
    <b>Реквизиты фирмы</b><p>
    Название компании (например: ООО Фирмах)<br>
    <% if (errors != null && errors.contains(PageDetailError.FIRM_NAME_EMPTY)) { %>
    <b>Введите пожайлусто название компании.</b>
    <% } %>
    <% if (errors != null && errors.contains(PageDetailError.FIRM_NAME_NOT_UNIQUE)) { %>
    <b>Введите пожайлусто уникальное название компании.</b>
    <% } %>
    <input type="text" onkeyup="findLikeForFirmName()" name="firmname" value="<%= firm.getName() %>" style="width: 80%" id="firmName"><br>
    <div id="firmlikenames"></div>
    Телефон<br>
    <input type="text" name="firmtelephon" value="<%= firm.getTelephon() %>" style="width: 80%"><br>
    Факс<br>
    <input type="text" name="firmfax" value="<%= firm.getFax() %>" style="width: 80%"><br>
    Электропочта<br>
    <input type="text" name="firmemail" value="<%= firm.getEmail() %>" style="width: 80%"><br>
    Сайт<br>
    <input type="text" name="firmsite" value="<%= firm.getSite() %>" style="width: 80%"><br>
    Адрес<br>
    <input type="text" name="firmaddress" value="<%= firm.getAddress() %>" style="width: 80%"><br>
    Заметки<br>
    <textarea rows="5" name="firmdescription" cols="" style="width: 80%"><%= firm.getDescription() %>
    </textarea>
<p><b>Реквизиты первого сотрудника</b><p>
    ФИО (например: Пушкин Сергей Александрович)<br>
    <% if (errors != null && errors.contains(PageDetailError.PIPOL_FIO_EMPTY)) { %>
    <b>Введите пожайлусто ФИО сотрудника.</b>
    <% } %>
    <input type="text" name="pipolfio" value="<%= pipol.getFio() %>" style="width: 80%"><br>
    Телефон<br>
    <input type="text" name="pipoltelephon" value="<%= pipol.getTelephon() %>" style="width: 80%"><br>
    Электропочта<br>
    <input type="text" name="pipolemail" value="<%= pipol.getEmail() %>" style="width: 80%"><br>
    Должность<br>
    <input type="text" name="pipolrank" value="<%= pipol.getRang() %>" style="width: 80%"><br>
    Заметки<br>
    <textarea rows="5" name="pipoldescription" cols="" style="width: 80%"><%= pipol.getDescription() %>
    </textarea>
<p><b>Реквизиты первого контакта</b>
        <p>
            Статус<br>
            <select name="statusId" style="vertical-align: middle; width: 80%">
                <%final List<EntityStatus> statuses = EntityManager.list(
                        "select status from ua.com.testes.manager.entity.EntityStatus as status");
                %>
                <% for (final EntityStatus status : statuses) { %>
                    <option value="<%= status.id %>"><%= status.name %></option>
                <% } %>
            </select>
        </p>
        <p>
    <%
        GregorianCalendar repeatCalendar = null;
        if (contact.repeat != null) {
            repeatCalendar = new GregorianCalendar();
            repeatCalendar.setTime(contact.repeat);
        }
    Date result1 = contact.repeat;
    %>
    Нужно ли перезвонить <input type="checkbox" <%= result1 != null ? "checked" : "" %> name="contactrepeatneed"
                                style="vertical-align: middle;">
    и когда, скажем
    <% if (errors != null && errors.contains(PageDetailError.CONTACT_REPEATE_DATE_INCORRENT)) { %>
    <br><b>Введите пожайлусто правильно дату, так чтобы она была больше чем сегодня.</b>
    <% } %>
    <ul>
        <li>
            <input type="radio" style="vertical-align: middle;" value="delta" name="contactrepeattype"> через
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
            <input onchange="contactRepeateChange()" checked type="radio" value="date" style="vertical-align: middle;" name="contactrepeattype">
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
            <select style="vertical-align: middle;" onchange="contactRepeateChange()" name="contactrepeatdatemonth">
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
            <select name="contactrepeatdateday" onchange="contactRepeateChange()" style="vertical-align: middle;">
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
<% }
    String result = contact.description;
%>
<textarea rows="8" name="contactdescription" cols="" style="width: 80%"><%= result %>
</textarea><p>
    <input type="submit" name="" value="Создать">
</form>
</body>
</html>