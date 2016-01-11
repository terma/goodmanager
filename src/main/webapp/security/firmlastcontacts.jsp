<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.logic.view.LogicView" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityView" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page language='java' %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%!

    private static final long month3 = 3L * 31L * 24L * 60L * 60L * 1000L;
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
        }
    }
    Collections.sort(firmLastContacts, firmLastContactComparator);
%>
<%= view.byMeOld ? "Мои" : "Все" %> фирмы по которым не было контакта уже 9 месяцев (<%= firmLastContacts.size() %>):
<p>
    <%--<% final int firmLastContactsLimit = Math.min(firmLastContacts.size(), 10); %>--%>
    <% final int firmLastContactsLimit = firmLastContacts.size(); %>
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