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
                    return firmLastContact1.contact.getCreate().compareTo(firmLastContact2.contact.getCreate());
                }

            };

    private static final Comparator<EntityContact> contactOldRepeatComparator =
            new Comparator<EntityContact>() {

                public final int compare(EntityContact contact, EntityContact contact2) {
                    if (contact.getRepeat() == null) {
                        return contact2.getRepeat() == null ? 0 : 1;
                    }
                    if (contact2.getRepeat() == null) {
                        return -1;
                    }
                    return contact.getRepeat().compareTo(contact2.getRepeat());
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
    final Date now = nowCalendar.getTime();

    final long currentTime = System.currentTimeMillis();
    final List<EntityContact> contactRepeats = new ArrayList<EntityContact>();
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
                if (firmLastContact.contact == null || (currentTime - firmLastContact.contact.getCreate().getTime() > month9)) {
                    firmLastContacts.add(firmLastContact);
                }
            }

            for (final EntityPipol pipol : firm.getPipols()) {
                if (pipol.getDelete() != null) continue;
                for (final EntityContact contact : pipol.getContacts()) {
                    if (contact.getDelete() != null) continue;
                    if (!view.byMeTotal || contact.getUser().getId().equals(user.getId())) {
                        if (System.currentTimeMillis() - contact.getCreate().getTime() < month3) {
                            last3Month++;
                        } else if (System.currentTimeMillis() - contact.getCreate().getTime() < month6) {
                            last6Month++;
                        } else if (System.currentTimeMillis() - contact.getCreate().getTime() < month9) {
                            last9Month++;
                        } else {
                            lastOtherMonth++;
                        }
                    }

                    // Перезвонить
                    if (contact.getRepeat() == null) continue;
                    if (view.byMeRepeat && contact.getUser() != user) continue;
                    // Если это последний контакт
                    if (contact.getRepeat().before(now) && firm.lastContact() == contact) {
                        contactRepeats.add(contact);
                    }
                }
            }
        }
    }
    Collections.sort(contactRepeats, contactOldRepeatComparator);
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
                            <td valign="top">
                                На сегодня <%= format.format(new Date()) %>
                                <ul>
                                    <%
                                        nowCalendar.add(Calendar.DAY_OF_MONTH, -1);
                                        final Date before = nowCalendar.getTime();
                                    %>
                                    <% for (final EntityContact contact : contactRepeats) { %>
                                        <li>
                                            <% if (contact.getRepeat().before(before)) { %>
                                                <span style="color: #ff0000; font-weight: bold;">Перезвонить</span>
                                            <% } else { %>
                                                <span style="color: #00ff00; font-weight: bold;">Перезвонить</span>
                                            <% } %>
                                            <%= contact.getPipol().getFio() %> с фирмы <a href="<login:link value='<%= "/security/detail.jsp?firmId=" + contact.getPipol().getFirm().getId() %>'/>"><%= contact.getPipol().getFirm().getName() %></a>
                                            из <a href="<login:link value='<%= "/security/list.jsp?sectionid=" + contact.getPipol().getFirm().getSection().getId() + "#firmId" + contact.getPipol().getFirm().getId() %>'/>"><%= contact.getPipol().getFirm().getSection().getName() %></a>
                                            <%
                                                long expiration = System.currentTimeMillis() - contact.getRepeat().getTime();
                                                expiration = expiration / (24 * 60 * 60 * 1000);
                                            %>
                                            <% if (expiration > 1) { %>
                                                <b>ожидает <%= expiration %> дня <%= expiration > 100 ? ", плохо" : "!" %></b>
                                            <% } %>
                                        </li>
                                     <% } %>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <a href="<login:link value="/security/search/search.jsp"/>">Поиск</a><br>
                                <a href="<login:link value="/security/firmadd.jsp"/>">Создать фирму</a><br>
                                <a href="<login:link value="/security/pipoladd.jsp"/>">Создать сотрудника</a><br>
                                <a href="<login:link value="/security/user.jsp"/>">О себе</a><br>
                                <a href="<login:link value="/security/rule.jsp"/>">Права</a><br>
                                <a href="<login:link value="/security/contract/main.jsp"/>">Договора</a><br>
                                <a href="<login:link value="/security/task/list.jsp"/>">Задачи</a><br>
                                <a href="<login:link value="/security/views.jsp"/>">Представление</a><br>
                                <a href="<login:link value="/security/product/main.jsp"/>">Продукция</a><br>
                                <a href="<login:link value="/security/tiding/main.jsp"/>">Новости</a><br>
                                <a href="<login:link value="/security/mail/main.jsp"/>">Почта</a><br>
                                <a href="<login:link value="/security/product/storage/main.jsp"/>">Склад</a><br>
                                <a href="/logout.jsp">Выйти</a><br>
                                <% if (user.getGroup().id == 2) { %>
                                    <a href="<login:link value="/security/style/list.jsp"/>">Стили</a><br>
                                    <a href="<login:link value="/security/content/main.jsp"/>">Содержимое</a><br>
                                    <a href="<login:link value="/security/admin/main.jsp"/>">Администрирование</a>
                                <% } %>
                                <%
                                    final List<EntityUser> users = EntityManager.list(
                                        "select user from ua.com.testes.manager.entity.user.EntityUser as user");
                                %>
                                <p>Статистика</p>
                                <ul style="list-style: none">
                                    <% if (!user.getGroup().allowStatistic(users).isEmpty()) { %>
                                        <li><a href="<login:link value="/security/statistic/count.jsp"/>">По количеству</a></li>
                                        <li><a href="<login:link value="/security/statistic/date.jsp"/>">По периоду</a></li>
                                        <li><a href="<login:link value="/security/statistic/user.jsp"/>">По менеджеру</a></li>
                                        <li><a href="<login:link value="/security/statistic/work.jsp"/>">По сделанному</a></li>
                                    <% } %>
                                    <li><a href="<login:link value="/security/statistic/repeat.jsp"/>">Перезвонить</a></li>
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
                                    <a href="<login:link value='<%= "/security/list.jsp?sectionid=" + section.getId() %>'/>"><%= LogicStyle.getHtml(section.getStyle(), section.getName()) %></a>
                                    <% if (user.getGroup().id == 2) { %>
                                        , <a href="<login:link value='<%= "/security/sectionstyleadd.jsp?sectionid=" + section.getId() %>'/>">стиль</a>
                                    <% } %>
                                    <br>
                                <% } %>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="40%" valign="top">
                    <%= view.byMeOld ? "Мои" : "Все" %> фирмы по которым не было контакта уже 9 месяцев (<%= firmLastContacts.size() %>):
                    <p>
                        <% for (final FirmLastContact firmLastContact : firmLastContacts) { %>
                            <a href="<login:link value='<%= "/security/detail.jsp?firmId=" + firmLastContact.firm.getId() %>'/>"><%= firmLastContact.firm.getName() %></a><br>
                            <% if (firmLastContact.contact != null) { %>
                                <div class="firmInfo">
                                    Последний контакт от <%= format.format(firmLastContact.contact.getCreate()) %> с
                                    <%= firmLastContact.contact.getPipol().getFio() %> по поводу <%= firmLastContact.contact.getDescription() %>
                                </div>
                            <% } %>
                        <% } %>
                    </p>
                </td>
            </tr>
        </table>
    </body>
</html>