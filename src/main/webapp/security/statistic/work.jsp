<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.util.UtilCalendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Выполненному - Статистика - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <%
            // Сеанс пользователя
            final EntityUser user = EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));
            if (user.getGroup().id != 2) {
                response.sendRedirect("/security/main.jsp");
                return;
            }
            final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy hh:mm", request.getLocale());
            final List<EntityUser> users = EntityManager.list(
                    "select user from ua.com.testes.manager.entity.user.EntityUser as user");
            final String userIdString = request.getParameter("userid");
            Integer userId = null;
            int startDay = 0;
            int startMonth = 0;
            int startYear = 0;
            try {
                userId = Integer.parseInt(userIdString);
                startYear = Integer.parseInt(request.getParameter("startyear"));
                startMonth = Integer.parseInt(request.getParameter("startmonth"));
                startDay = Integer.parseInt(request.getParameter("startday"));
            } catch (NumberFormatException exception) {
            }
        %>
        <p>Назад к <a href="/security/main.jsp">разделам</a></p>
        <form action="/security/statistic/work.jsp" method="post">
            <p>
                Показать для менеджера
                <select name="userid">
                    <% for (final EntityUser tempUser : users) { %>
                        <option <%= userId != null && userId.equals(tempUser.getId()) ? "selected" : "" %> value="<%= tempUser.getId() %>"><%= tempUser.getFio() %></option>
                    <% } %>
                </select>
                на
                <select size="1" name="startyear">
                <%
                    final GregorianCalendar calendar = new GregorianCalendar();
                    if (userId != null) {
                        calendar.set(Calendar.YEAR, startYear);
                        calendar.set(Calendar.MONTH, startMonth);
                        calendar.set(Calendar.DAY_OF_MONTH, startDay);
                    }
                    calendar.set(Calendar.MILLISECOND, 0);
                    calendar.set(Calendar.SECOND, 0);
                    calendar.set(Calendar.HOUR, 0);
                    calendar.set(Calendar.MINUTE, 0);
                    final int year = calendar.get(Calendar.YEAR);
                    final List<UtilCalendar.Month> months = UtilCalendar.getDisplayMonths(request.getLocale());
                %>
                    <% for (int i = year - 5; i < year + 5; i++) { %>
                        <option <%= calendar.get(Calendar.YEAR) == i ? "selected" : "" %>
                            value="<%= i %>"><%= i %></option>
                    <% } %>
                </select>
                <select name="startmonth" size="1">
                    <% for (final UtilCalendar.Month month : months) { %>
                        <option <%= calendar.get(Calendar.MONTH) == month.order ? "selected" : "" %>
                            value="<%= month.order %>"><%= month.name %> (<%= month.getDisplayOrder() %>)</option>
                    <% } %>
                </select>
                <select size="1" name="startday">
                    <% for (int i = 1; i < 32; i++) { %>
                        <option <%= calendar.get(Calendar.DATE) == i ? "selected" : "" %>
                            value="<%= i %>"><%= i %></option>
                    <% } %>
                </select>
                <input type="submit" value="Показать">
            </p>
            <% if (userId != null) { %>
                <%
                    final EntityUser workUser = EntityManager.find(EntityUser.class, userId);
                    final Date start = calendar.getTime();
                    calendar.add(Calendar.DAY_OF_MONTH, 1);
                    final Date finish = calendar.getTime();
                    final List<EntityFirm> createFirms = new ArrayList<EntityFirm>();
                    final List<EntityPipol> createPipols = new ArrayList<EntityPipol>();
                    final List<EntityPipol> deletePipols = new ArrayList<EntityPipol>();
                    final List<EntityPipolHistory> updatePipols = new ArrayList<EntityPipolHistory>();
                    final List<EntityContact> createContacts = new ArrayList<EntityContact>();
                    final List<EntityContact> deleteContacts = new ArrayList<EntityContact>();
                    final List<EntityContactHistory> updateContacts = new ArrayList<EntityContactHistory>();
                    final List<EntityFirm> deleteFirms = new ArrayList<EntityFirm>();
                    final List<EntityFirmHistory> updateFirms = new ArrayList<EntityFirmHistory>();
                    final List<EntitySection> sections = EntityManager.list(
                            "select section from ua.com.testes.manager.entity.EntitySection as section");
                    for (final EntitySection section : sections) {
                        for (final EntityFirm firm : section.getFirms()) {
                            for (final EntityFirmHistory firmHistory : firm.getHistorys()) {
                                if (firmHistory.user.getId() == userId) {
                                    if (start.before(firmHistory.id.update) && finish.after(firmHistory.id.update)) {
                                        updateFirms.add(firmHistory);
                                    }
                                }
                            }
                            if (firm.getUser().getId().equals(userId)) {
                                if (start.before(firm.getCreate()) && finish.after(firm.getCreate())) {
                                    createFirms.add(firm);
                                }
                                if (firm.getDelete() != null && start.before(firm.getDelete()) && finish.after(firm.getDelete())) {
                                    deleteFirms.add(firm);
                                }
                            }
                            for (final EntityPipol pipol : firm.getPipols()) {
                                if (pipol.getUser().getId().equals(userId)) {
                                    if (start.before(pipol.getCreate()) && finish.after(pipol.getCreate())) {
                                        createPipols.add(pipol);
                                    }
                                    if (pipol.getDelete() != null && start.before(pipol.getDelete()) && finish.after(pipol.getDelete())) {
                                        deletePipols.add(pipol);
                                    }
                                }
                                for (final EntityPipolHistory pipolHistory : pipol.getHistorys()) {
                                    if (pipolHistory.user.getId() == userId) {
                                        if (start.before(pipolHistory.id.update) && finish.after(pipolHistory.id.update)) {
                                            updatePipols.add(pipolHistory);
                                        }
                                    }
                                }
                                for (final EntityContact contact : pipol.getContacts()) {
                                    if (contact.user.getId().equals(userId)) {
                                        if (start.before(contact.create) && finish.after(contact.create)) {
                                            createContacts.add(contact);
                                        }
                                        if (contact.delete != null && start.before(contact.delete) && finish.after(contact.delete)) {
                                            deleteContacts.add(contact);
                                        }
                                    }
                                    for (final EntityContactHistory contactHistory : contact.historys) {
                                        if (contactHistory.user.getId().equals(userId)) {
                                            if (start.before(contactHistory.id.update) && finish.after(contactHistory.id.update)) {
                                                updateContacts.add(contactHistory);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    final List<EntityContract> contracts = EntityManager.list(
                            "select contract from ua.com.testes.manager.entity.EntityContract as contract");
                    final List<EntityContractVersion> createContractVersions = new ArrayList<EntityContractVersion>();
                    for (final EntityContract contract : contracts) {
                        for (final EntityContractVersion contractVersion : contract.versions) {
                            if (contractVersion.user.getId().equals(userId)) {
                                if (start.before(contractVersion.create) && finish.after(contractVersion.create)) {
                                    createContractVersions.add(contractVersion);
                                }
                            }
                        }
                    }
                %>
                <% if (workUser.getBlock() != null) { %>
                    <p>
                        <b>
                            Пользователь
                            <% if (workUser.isBlock()) { %>
                                заблокирован до <%= format.format(workUser.getBlock()) %>
                            <% } else { %>
                                был заблокирован до <%= format.format(workUser.getBlock()) %>
                            <% } %>
                        </b>
                    </p>
                <% } %>
                <% if (!createFirms.isEmpty()) { %>
                    <p>Создал фирмы (<%= createFirms.size() %>)</p>
                    <ul>
                        <% for (final EntityFirm firm : createFirms) { %>
                            <li><a href="/security/detail.jsp?firmId=<%= firm.getId() %>"><%= firm.getName() %></a></li>
                        <% } %>
                    </ul>
                <% } %>
                <% if (!deleteFirms.isEmpty()) { %>
                    <p>Удалил фирмы (<%= deleteFirms.size() %>)</p>
                    <ul>
                        <% for (final EntityFirm firm : deleteFirms) { %>
                            <li><a href="/security/detail.jsp?firmId=<%= firm.getId() %>"><%= firm.getName() %></a></li>
                        <% } %>
                    </ul>
                <% } %>
                <% if (!updateFirms.isEmpty()) { %>
                    <p>Отредактировал фирмы (<%= updateFirms.size() %>)</p>
                    <ul>
                        <% for (final EntityFirmHistory firmHistory : updateFirms) { %>
                            <li><a href="/security/detail.jsp?firmId=<%= firmHistory.id.firm.getId() %>"><%= firmHistory.id.firm.getName() %></a></li>
                        <% } %>
                    </ul>
                <% } %>
                <% if (!createPipols.isEmpty()) { %>
                    <p>Создал сотрудников (<%= createPipols.size() %>)</p>
                    <ul>
                        <% for (final EntityPipol pipol : createPipols) { %>
                            <li>
                                <% if (pipol.getEmail().length() > 0) { %>
                                    <a href="mailto:<%= pipol.getEmail() %>"><%= pipol.getFio() %></a>
                                <% } else { %>
                                    <%= pipol.getFio() %>
                                <% } %>
                                из <a href="/security/detail.jsp?firmId=<%= pipol.getFirm().getId() %>"><%= pipol.getFirm().getName() %></a>
                            </li>
                        <% } %>
                    </ul>
                <% } %>
                <% if (!deletePipols.isEmpty()) { %>
                    <p>Удалил сотрудники (<%= deletePipols.size() %>)</p>
                    <ul>
                        <% for (final EntityPipol pipol : deletePipols) { %>
                            <% if (pipol.getEmail().length() > 0) { %>
                                    <a href="mailto:<%= pipol.getEmail() %>"><%= pipol.getFio() %></a>
                                <% } else { %>
                                    <%= pipol.getFio() %>
                                <% } %>
                                из <a href="/security/detail.jsp?firmId=<%= pipol.getFirm().getId() %>"><%= pipol.getFirm().getName() %></a>
                        <% } %>
                    </ul>
                <% } %>
                <% if (!updatePipols.isEmpty()) { %>
                    <p>Отредактировал сотрудники (<%= updatePipols.size() %>)</p>
                    <ul>
                        <% for (final EntityPipolHistory pipolHistory : updatePipols) { %>
                            <li>
                                <% if (pipolHistory.id.pipol.getEmail().length() > 0) { %>
                                    <a href="mailto:<%= pipolHistory.id.pipol.getEmail() %>"><%= pipolHistory.id.pipol.getFio() %></a>
                                <% } else { %>
                                    <%= pipolHistory.id.pipol.getFio() %>
                                <% } %>
                                <% String link6 = "/security/detail.jsp?firmId=" + pipolHistory.id.pipol.getFirm().getId(); %>
                                из <a href="<%= link6 %>"><%= pipolHistory.id.pipol.getFirm().getName() %></a>
                            </li>
                        <% } %>
                    </ul>
                <% } %>
                <% if (!createContacts.isEmpty()) { %>
                    <p>Создал контакты (<%= createContacts.size() %>)</p>
                    <ul>
                        <% for (final EntityContact contact : createContacts) { %>
                            <% EntityPipol result = contact.pipol; %>
                            <li><a href="/security/detail.jsp?firmId=<%= result.getFirm().getId() %>"><%= contact.description %></a></li>
                        <% } %>
                    </ul>
                <% } %>
                <% if (!deleteContacts.isEmpty()) { %>
                    <p>Удалил контакты (<%= deleteContacts.size() %>)</p>
                    <ul>
                        <% for (final EntityContact contact : deleteContacts) { %>
                            <% EntityPipol result = contact.pipol; %>
                            <li><a href="/security/detail.jsp?firmId=<%= result.getFirm().getId() %>"><%= contact.description %></a></li>
                        <% } %>
                    </ul>
                <% } %>
                <% if (!updateContacts.isEmpty()) { %>
                    <p>Отредактировал контакты (<%= updateContacts.size() %>)</p>
                    <ul>
                        <% for (final EntityContactHistory contactHistory : updateContacts) { %>
                            <% EntityPipol result = contactHistory.id.contact.pipol; %>
                            <li><a href="/security/detail.jsp?firmId=<%= result.getFirm().getId() %>"><%= contactHistory.id.contact.pipol.getFirm().getName() %></a></li>
                        <% } %>
                    </ul>
                <% } %>
                <% if (!createContractVersions.isEmpty()) { %>
                    <p>Занес договора (<%= createContractVersions.size() %>)</p>
                    <ul>
                        <% for (final EntityContractVersion contractVersion : createContractVersions) { %>
                            <li>
                                №<%= contractVersion.contract.id %>
                                <a href="/security/contract/detail.jsp?contractId=<%= contractVersion.contract.id %>"><%= contractVersion.contract.name %></a>
                            </li>
                        <% } %>
                    </ul>
                <% } %>
            <% } %>
        </form>
    </body>
</html>