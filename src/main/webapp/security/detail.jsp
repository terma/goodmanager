<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityView" %>
<%@ page import="ua.com.testes.manager.logic.view.LogicView" %>
<%@ page import="ua.com.testes.manager.logic.style.LogicStyle" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%!

    private static class ContactComparator implements Comparator<EntityContact> {

        public int compare(EntityContact o1, EntityContact o2) {
            return o2.create.compareTo(o1.create);
        }

    }

    private static class FirmHistoryComparator implements Comparator<EntityFirmHistory> {

        public int compare(EntityFirmHistory o1, EntityFirmHistory o2) {
            return o2.id.update.compareTo(o1.id.update);
        }

    }

    private static class PipolHistoryComparator implements Comparator<EntityPipolHistory> {

        public int compare(EntityPipolHistory o1, EntityPipolHistory o2) {
            return o2.id.update.compareTo(o1.id.update);
        }

    }

    private static class ContactHistoryComparator implements Comparator<EntityContactHistory> {

        public int compare(EntityContactHistory o1, EntityContactHistory o2) {
            return o2.id.update.compareTo(o1.id.update);
        }

    }
%>
<html>
    <head>
        <%
            final int firmId = Integer.parseInt(request.getParameter("firmId"));
            final EntityFirm firm = EntityManager.find(EntityFirm.class, firmId);
            final ua.com.testes.manager.entity.user.EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
            final EntityView view = LogicView.get(user);
            final SimpleDateFormat repeatFormat = new SimpleDateFormat("dd MMMM yy", request.getLocale());
            final SimpleDateFormat createFormat = new SimpleDateFormat("dd MMMM yy HH:mm", request.getLocale());
        %>
        <title>Информация о фирме - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            .pipolEmail, .pipolDescription, .pipolTelephon, .pipolRang {
                font-size: 12px;
                margin-left: 30px
            }

            .firmHistory {
                color: #aaaaaa;
            }

            .pipolHistory {
                color: #aaaaaa;
            }

            .contactHistory {
                color: #aaaaaa;
            }

            .firmInfo, .pipolInfo {
                font-size: 12px;
                margin-left: 10px
            }

        </style>
    </head>
    <body>
        <jsp:include page="/security/util/mail/list.jsp" flush="true"/>
        <jsp:include page="/security/util/rate/list.jsp" flush="true"/>
        <table width="100%" border="0" cellpadding="0" cellspacing="5">
            <tr>
                <td colspan="2" valign="top">
                    Выход <a href="/security/search/search.jsp">Поиск</a> к <a href="/security/main.jsp">разделам</a>,
                    может <a href="<%= "/security/firmadd.jsp?sectionId=" + firm.getSection().getId() %>">создать</a>
                    <% if (firm.getDelete() == null) { %>
                        или <a href="<%= "/security/firmedit.jsp?firmId=" + firmId %>">редактировать</a> фирму,
                    <% } %>
                    <a href="<%= "/security/views.jsp?firmId=" + firmId %>">представление</a>
                    <p>
                    Фирма <%= firm.getName() %> №<%= firm.getId() %> из раздела
                    <a href="<%= "/security/list.jsp?sectionid=" + firm.getSection().getId() + "#firmId" + firm.getId() %>"><%= LogicStyle.getHtml(firm.getSection().getStyle(), firm.getSection().getName()) %></a><br>
                    <div class="firmInfo">Менеджер <a href="mailto:<%= firm.getUser().getEmail() %>"><%= firm.getUser().getFio() %></a><br>
                        Добавлена <%= createFormat.format(firm.getCreate()) %><br>
                        Телефон <%= firm.getTelephon() %><br>
                        <% if (firm.getSite().length() > 0) { %>
                            <a href="<%= firm.getSite() %>"><%= firm.getSite() %></a><br>
                        <% } %>
                        <% if (firm.getFax().length() > 0) { %>
                            Факс <%= firm.getFax() %><br>
                        <% } %>
                        <% if (firm.getAddress().length() > 0) { %>
                            <%= firm.getAddress() %><br>
                        <% } %>
                        <a href="mailto:<%= firm.getEmail() %>"><%= firm.getEmail() %></a><br>
                        <%= firm.getDescription() %>
                    </div>
                    <% if (view.history.firm && !firm.getHistorys().isEmpty()) { %>
                        <p class="firmHistory">
                            История
                            <% final List<EntityFirmHistory> firmHistorys = new ArrayList<EntityFirmHistory>(firm.getHistorys()); %>
                            <% Collections.sort(firmHistorys, new FirmHistoryComparator()); %>
                            <% for (final EntityFirmHistory history : firmHistorys) { %>
                                <p class="firmHistory">
                                    Фирма <%= history.name %> измененния от <%= createFormat.format(history.id.update) %>
                                    <div class="firmInfo firmHistory">
                                        Менеджер <a href="mailto:<%= history.user.getEmail() %>"><%= history.user.getFio() %></a><br>
                                        <% if (history.telephon.length() > 0) { %>
                                            Телефон <%= history.telephon %><br>
                                        <% } %>
                                        <% if (history.site.length() > 0) { %>
                                            <a href="<%= history.getSite() %>"><%= history.getSite() %></a><br>
                                        <% } %>
                                        <% if (history.fax.length() > 0) { %>
                                            Факс <%= history.fax %><br>
                                        <% } %>
                                        <a href="mailto:<%= history.email %>"><%= history.email %></a><br>
                                        <%= history.description %>
                                    </div>
                                </p>
                            <% } %>
                        </p>
                    <% } %>
                </td>
            </tr>
            <tr>
                <td width="30%" valign="top">
                    Сотрудников <%= firm.getPipols().size() %><p>
                    <% for (final EntityPipol pipol : firm.getPipols()) { %>
                        <% if (!view.delete.pipol && pipol.getDelete() != null) continue; %>
                        <div>
                            <% if (pipol.getDelete() == null) { %>
                                <a href="<%= "/security/pipoldeleteconfirm.jsp?pipolId=" + pipol.getId() %>"><img
                                        src="/image/delete.gif" style="vertical-align: middle;" alt="Удалить" width="15" height="15"
                                        border="0"></a>
                            <% } %>
                            <%= pipol.getFio() %>,
                            <% if (pipol.getDelete() == null) { %>
                                <a href="<%= "/security/pipoledit.jsp?pipolId=" + pipol.getId() %>">редактировать</a><br>
                            <% } %>
                            <span class="pipolRang">Менеджер <a href="mailto:<%= pipol.getUser().getEmail() %>"><%= pipol.getUser().getFio() %></a></span><br>
                            <span class="pipolRang">Добавлен <%= createFormat.format(pipol.getCreate()) %></span><br>
                            <% if (pipol.getRang().length() > 0) { %>
                                <span class="pipolRang"><%= pipol.getRang() %></span><br>
                            <% } %>
                            <% if (pipol.getEmail().length() > 0) { %>
                                <a class="pipolEmail" href="mailto:<%= pipol.getEmail() %>"><%= pipol.getEmail() %></a><br>
                            <% } %>
                            <% if (pipol.getTelephon().length() > 0) { %>
                                <span class="pipolTelephon"><%= pipol.getTelephon() %></span><br>
                            <% } %>
                            <% if (pipol.getDescription().length() > 0) { %>
                                <span class="pipolDescription"><%= pipol.getDescription() %></span><br>
                            <% } %>
                        </div>
                        <% if (view.history.pipol && !pipol.getHistorys().isEmpty()) { %>
                            <p class="pipolHistory">
                                История
                                <% final List<EntityPipolHistory> pipolHistorys = new ArrayList<EntityPipolHistory>(pipol.getHistorys()); %>
                                <% Collections.sort(pipolHistorys, new PipolHistoryComparator()); %>
                                <% for (final EntityPipolHistory history : pipolHistorys) { %>
                                    <p class="pipolHistory">
                                        <%= history.fio %> изминенния от <%= createFormat.format(history.id.update) %>
                                        редактировал <a href="mailto:<%= history.user.getEmail() %>"><%= history.user.getFio() %></a><br>
                                        <div class="pipolInfo pipolHistory">
                                            <% if (history.email.length() > 0) { %>
                                                <a href="mailto:<%= history.email %>"><%= history.email %></a><br>
                                            <% } %>
                                            <% if (history.telephon.length() > 0) { %>
                                                <%= history.telephon %><br>
                                            <% } %>
                                            <% if (history.description.length() > 0) { %>
                                                <%= history.description %><br>
                                            <% } %>
                                        </div>
                                    </p>
                                <% } %>
                            </p>
                        <% } %>
                    <% } %>
                    <p><a href="<%= "/security/pipoladd.jsp?firmId=" + firmId %>">Добавить</a>
                </td>
                <td width="70%" valign="top">
                    <%
                        final List<EntityContact> contacts = new ArrayList<EntityContact>();
                        for (final EntityPipol pipol : firm.getPipols()) {
                            for (final EntityContact contact : pipol.getContacts()) {
                                contacts.add(contact);
                            }
                        }
                        Collections.sort(contacts, new ContactComparator());
                    %>
                    Беседа, всего <%= contacts.size() %><p>
                    <% for (final EntityContact contact : contacts) { %>
                        <%
        if (!view.delete.contact && (contact.pipol.getDelete() != null || contact.delete != null)) continue; %>
                        <%
        if (contact.delete == null && contact.pipol.getDelete() == null) {
        Integer result = contact.id;
    %>
                            <a href="<%= "/security/contactdeleteconfirm.jsp?contactId=" + result %>"><img
                                    src="/image/delete.gif" style="vertical-align: middle;" alt="Удалить" width="15" height="15"
                                    border="0"></a>
                        <% }
        Date result1 = contact.create;
    EntityUser result3 = contact.user;
    %>
                        <%= createFormat.format(result1) %> беседовал
                        <%= result3.getFio() %> с
                        <%
        if (contact.pipol.getEmail().length() > 0) {
        EntityPipol result = contact.pipol;
    EntityPipol result2 = contact.pipol;
    %>
                            <a href="mailto:<%= result2.getEmail() %>"><%= result.getFio() %></a>,
                        <% } else {
        EntityPipol result = contact.pipol;
    %>
                            <%= result.getFio() %>,
                        <% } %>
                        <%
        if (contact.delete == null && contact.pipol.getDelete() == null) {
        Integer result = contact.id;
    %>
                            <a href="<%= "/security/contactedit.jsp?contactId=" + result %>">редактировать</a><br>
                        <% }
        EntityStatus result2 = contact.status;
    %>
                        Со статусом <%= result2.name %><br>
                        <%
        if (contact.description.length() > 0) {
        String result = contact.description;
    %>
                            <%= result %><br>
                        <% } %>
                        <%
        if (contact.repeat != null) {
        Date result = contact.repeat;
    %>
                            <b>Нужно перезвонить <%= repeatFormat.format(result) %></b>
                        <% } %>
                        <p>
                        <%
        if (view.history.contact && !contact.historys.isEmpty()) { %>
                            <p class="contactHistory">
                                История
                                <%
        final List<EntityContactHistory> contactHistorys = new ArrayList<EntityContactHistory>(contact.historys); %>
                                <% Collections.sort(contactHistorys, new ContactHistoryComparator()); %>
                                <% for (final EntityContactHistory history : contactHistorys) { %>
                                    <p class="contactHistory">
                                        Изминения от <%= createFormat.format(history.id.update) %><br>
                                        <% if (history.description.length() > 0) { %>
                                            <%= history.description %><br>
                                        <% } %>
                                        <% if (history.repeat != null) { %>
                                            <b>Нужно перезвонить <%= repeatFormat.format(history.repeat) %></b>
                                        <% } %>
                                    </p>
                                <% } %>
                            </p>
                        <% } %>
                    <% } %>
                    <a href="<%= "/security/contactadd.jsp?firmId=" + firmId %>">Беседа</a>
                </td>
            </tr>
        </table>
    </body>
</html>
