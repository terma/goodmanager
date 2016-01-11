<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.logic.view.LogicView" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityView" %>
<%@ page import="ua.com.testes.manager.logic.style.LogicStyle" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page language='java' %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%!

    private static final long month3 = 3L * 31L * 24L * 60L * 60L * 1000L;
    private static final long month6 = 2 * month3;
    private static final long month9 = 3 * month3;

    private static final Comparator<FirmLastContact> firmLastContactComparator =
            new Comparator<FirmLastContact>() {

                public final int compare(FirmLastContact firmLastContact1, FirmLastContact firmLastContact2) {
                    if (firmLastContact1.contact == null) {
                        return firmLastContact2.contact == null ? 0 : 1;
                    }
                    if (firmLastContact2.contact == null) {
                        return -1;
                    }
                    return firmLastContact1.contact.create.compareTo(firmLastContact2.contact.create);
                }

            };

    private static final class FirmLastContact {

        public EntityFirm firm;
        public EntityContact contact;

    }
%>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final EntityView view = LogicView.get(user);
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy", request.getLocale());

    final GregorianCalendar nowCalendar = new GregorianCalendar();
    nowCalendar.set(Calendar.MINUTE, 0);
    nowCalendar.set(Calendar.HOUR_OF_DAY, 0);
    nowCalendar.set(Calendar.MILLISECOND, 0);
    nowCalendar.set(Calendar.SECOND, 0);
    nowCalendar.add(Calendar.DAY_OF_MONTH, 1);

    final long currentTime = System.currentTimeMillis();
    final List<FirmLastContact> firmLastContacts = new ArrayList<FirmLastContact>();
    final List<EntitySection> sections = EntityManager.list("select section from sections as section");
    int last3Month = 0;
    int last6Month = 0;
    int last9Month = 0;
    int lastOtherMonth = 0;
    for (final EntitySection section : sections) {
        for (final EntityFirm firm : section.getFirms()) {
            if (firm.getDelete() != null) continue;

            // Давно не прозваниваемые клиенты
            if (!view.byMeOld || firm.getUser() == user) {
                // Получаем самый последний контакт
                final FirmLastContact firmLastContact = new FirmLastContact();
                firmLastContact.firm = firm;
                firmLastContact.contact = firm.lastContact();
                if (firmLastContact.contact == null || (currentTime - firmLastContact.contact.create.getTime() > month9)) {
                    firmLastContacts.add(firmLastContact);
                }
            }

            for (final EntityPipol pipol : firm.getPipols()) {
                if (pipol.getDelete() != null) continue;
                for (final EntityContact contact : pipol.getContacts()) {
                    if (contact.delete != null) continue;
                    if (!view.byMeTotal || contact.user == user) {
                        if (System.currentTimeMillis() - contact.create.getTime() < month3) {
                            last3Month++;
                        } else {
                            if (System.currentTimeMillis() - contact.create.getTime() < month6) {
                                last6Month++;
                            } else {
                                if (System.currentTimeMillis() - contact.create.getTime() < month9) {
                                    last9Month++;
                                } else {
                                    lastOtherMonth++;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Collections.sort(firmLastContacts, firmLastContactComparator);
%>
<html>
    <head>
        <title>Начало - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            .firmInfo {
                font-size: 12px;
                margin-left: 10px
            }

        </style>
        <script src="/jquery.js"></script>
        <script src="/engine.js"></script>
    </head>
    <body>
        <jsp:include page="/security/util/mail/list.jsp" flush="true"/>
        <jsp:include page="/security/util/rate/list.jsp" flush="true"/>
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="30%" style="padding-right: 10px" valign="top">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="top">
                                Пользователь <b><%= user.getFio() %></b><p>
                                Контактов <%= !view.byMeTotal ? "всех" : "моих" %> за последние
                                <ul>
                                    <li>3 месяца <%= last3Month == 0 ? "нет" : Integer.toString(last3Month) %></li>
                                    <li>6 месяца <%= last6Month == 0 ? "нет" : Integer.toString(last6Month) %></li>
                                    <li>9 месяца <%= last9Month == 0 ? "нет" : Integer.toString(last9Month) %></li>
                                    <li>Больше <%= lastOtherMonth == 0 ? "нет" : Integer.toString(lastOtherMonth) %></li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" id="contactsWithRepeat">
                                <jsp:include page="/security/contactrepeats.jsp" flush="true">
                                    <jsp:param name="limitInPast" value="5"/>
                                </jsp:include>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <a href="/security/search/search.jsp">Поиск</a><br>
                                <a href="/security/firmadd.jsp">Создать фирму</a><br>
                                <a href="/security/pipoladd.jsp">Создать сотрудника</a><br>
                                <%--<a href="/security/user.jsp"/>">О себе</a><br>--%>
                                <a href="/security/rule.jsp">Права</a><br>
                                <a href="/security/contract/main.jsp">Договора</a><br>
                                <%--<a href="/security/task/list.jsp"/>">Задачи</a><br>--%>
                                <a href="/security/views.jsp">Представление</a><br>
                                <%--<a href="/security/product/main.jsp"/>">Продукция</a><br>--%>
                                <%--<a href="/security/tiding/main.jsp"/>">Новости</a><br>--%>
                                <%--<a href="/security/mail/main.jsp"/>">Почта</a><br>--%>
                                <%--<a href="/security/product/storage/main.jsp"/>">Склад</a><br>--%>
                                <a href="/logout.jsp">Выйти</a><br>
                                <% if (user.getGroup().id == 2) { %>
                                    <a href="/security/style/list.jsp">Стили</a><br>
                                    <a href="/security/content/main.jsp">Содержимое</a><br>
                                    <a href="/security/admin/main.jsp">Администрирование</a>
                                <% } %>
                                <%
                                    final List<EntityUser> users = EntityManager.list(
                                        "select user from ua.com.testes.manager.entity.user.EntityUser as user");
                                %>
                                <p>Статистика</p>
                                <ul style="list-style: none">
                                    <% if (!user.getGroup().allowStatistic(users).isEmpty()) { %>
                                        <li><a href="/security/statistic/count.jsp">По количеству</a></li>
                                        <li><a href="/security/statistic/date.jsp">По периоду</a></li>
                                        <li><a href="/security/statistic/user.jsp">По менеджеру</a></li>
                                        <li><a href="/security/statistic/work.jsp">По сделанному</a></li>
                                    <% } %>
                                    <li><a href="/security/statistic/repeat.jsp">Перезвонить</a></li>
                                </ul>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="30%" valign="top">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="top">
                                Разделы, всего <%= sections.size() %><p>                                
                                <% for (final EntitySection section : sections) { %>
                                    <a href="<%= "/security/list.jsp?sectionid=" + section.getId() %>"><%= LogicStyle.getHtml(section.getStyle(), section.getName()) %></a>
                                    <% if (user.getGroup().id == 2) { %>
                                        , <a href="<%= "/security/sectionstyleadd.jsp?sectionid=" + section.getId() %>">стиль</a>
                                    <% } %>
                                    <br>
                                <% } %>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="40%" valign="top" id="firmlastcontacts">
                    <%= view.byMeOld ? "Мои" : "Все" %> фирмы по которым не было контакта уже 9 месяцев (<%= firmLastContacts.size() %>):
                    <p>
                            <% final int firmLastContactsLimit = Math.min(firmLastContacts.size(), 10); %>
                        <% for (int i = 0; i < firmLastContactsLimit; i++) { %>
                            <% final FirmLastContact firmLastContact = firmLastContacts.get(i); %>
                            <a href="<%= "/security/detail.jsp?firmId=" + firmLastContact.firm.getId() %>"><%= firmLastContact.firm.getName() %></a><br>
                            <% if (firmLastContact.contact != null) { %>
                                <div class="firmInfo">
                                    Последний контакт от <%= format.format(firmLastContact.contact.create) %> с
                                    <%= firmLastContact.contact.pipol.getFio() %> по поводу <%= firmLastContact.contact.description %>
                                </div>
                            <% } %>
                        <% } %>
                    </p>
                    <% if (firmLastContactsLimit < firmLastContacts.size()) { %>
                        <a id="showfirmlastcontacts" href="javascript:firmLastContacts()">Показать остальные <%= firmLastContacts.size() - firmLastContactsLimit %></a>
                    <% } %>
                </td>
            </tr>
        </table>
    </body>
</html>