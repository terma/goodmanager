<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.logic.view.LogicView" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityView" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page language='java' %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%!

    private static final Comparator<EntityContact> contactsRepeatComparator =
            new Comparator<EntityContact>() {

                public final int compare(EntityContact contact, EntityContact contact2) {
                    if (contact.repeat == null) {
                        return contact2.repeat == null ? 0 : 1;
                    }
                    if (contact2.repeat == null) {
                        return -1;
                    }
                    return contact.repeat.compareTo(contact2.repeat);
                }

            };

%>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final EntityView view = LogicView.get(user);
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy", request.getLocale());

    final int limit;
    if (request.getParameter("limitInPast") != null) {
        limit = Integer.parseInt(request.getParameter("limitInPast"));
    } else {
        limit = Integer.MAX_VALUE;
    }

    final GregorianCalendar nowCalendar = new GregorianCalendar();
    nowCalendar.set(Calendar.MINUTE, 0);
    nowCalendar.set(Calendar.HOUR_OF_DAY, 0);
    nowCalendar.set(Calendar.MILLISECOND, 0);
    nowCalendar.set(Calendar.SECOND, 0);
    nowCalendar.add(Calendar.DAY_OF_MONTH, 1);
    final Date now = nowCalendar.getTime();

    nowCalendar.add(Calendar.DAY_OF_MONTH, -1);
    final Date onDayBefore = nowCalendar.getTime();

    final List<EntityContact> contactRepeatsInPast = new ArrayList<EntityContact>();
    final List<EntityContact> contactsRepeatToday = new ArrayList<EntityContact>();
    final List<EntitySection> sections = EntityManager.list("select section from sections as section");

    for (final EntitySection section : sections) {
        for (final EntityFirm firm : section.getFirms()) {
            if (firm.getDelete() != null) continue;

            for (final EntityPipol pipol : firm.getPipols()) {
                if (pipol.getDelete() != null) continue;
                for (final EntityContact contact : pipol.getContacts()) {
                    if (contact.delete != null) continue;

                    // Перезвонить
                    if (contact.repeat == null) continue;
                    if (view.byMeRepeat && contact.user != user) continue;
                    // Если это последний контакт
                    if (contact.repeat.before(now) && firm.lastContact() == contact) {
                        if (contact.repeat.before(onDayBefore)) {
                            contactRepeatsInPast.add(contact);
                        } else {
                            contactsRepeatToday.add(contact);
                        }
                    }
                }
            }
        }
    }
    Collections.sort(contactRepeatsInPast, contactsRepeatComparator);
    Collections.sort(contactsRepeatToday, contactsRepeatComparator);
%>

На сегодня <%= format.format(now) %>
<ul>
    <% final int showOnlyFirst = Math.min(contactRepeatsInPast.size(), limit); %>
    <% for (int i = 0; i < showOnlyFirst; i++) { %>
        <% final EntityContact contact = contactRepeatsInPast.get(i); %>
        <li>
            <span style="color: #ff0000; font-weight: bold;">Перезвонить</span>
            <%= contact.pipol.getFio() %> с фирмы <a href="<%= "/security/detail.jsp?firmId=" + contact.pipol.getFirm().getId() %>"><%= contact.pipol.getFirm().getName() %></a>
            из <a href="<%= "/security/list.jsp?sectionid=" + contact.pipol.getFirm().getSection().getId() + "#firmId" + contact.pipol.getFirm().getId() %>"><%= contact.pipol.getFirm().getSection().getName() %></a>
            <%
                long expiration = System.currentTimeMillis() - contact.repeat.getTime();
                expiration = expiration / (24 * 60 * 60 * 1000);
            %>
            <% if (expiration > 1) { %>
                <b>ожидает <%= expiration %> дня <%= expiration > 100 ? ", плохо" : "!" %></b>
            <% } %>
        </li>
    <% } %>

    <% if (showOnlyFirst < contactRepeatsInPast.size()) { %>
        <li id="showAllContactsWithRepeat"><a href="javascript:showAllContactsWithRepeat()">Показать остальные контакты, их <%= contactRepeatsInPast.size() - showOnlyFirst %></a></li>
    <% } %>

    <% for (final EntityContact contact : contactsRepeatToday) { %>
        <li>
            <span style="color: #00ff00; font-weight: bold;">Перезвонить</span>
            <%= contact.pipol.getFio() %> с фирмы <a href="<%= "/security/detail.jsp?firmId=" + contact.pipol.getFirm().getId() %>"><%= contact.pipol.getFirm().getName() %></a>
            из <a href="<%= "/security/list.jsp?sectionid=" + contact.pipol.getFirm().getSection().getId() + "#firmId" + contact.pipol.getFirm().getId() %>"><%= contact.pipol.getFirm().getSection().getName() %></a>
        </li>
    <% } %>
</ul>