<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageStatistic" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageStatisticDate" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!

    private static final ContactDateComparator contactComparator = new ContactDateComparator();

    private static final class ContactDateComparator implements Comparator<EntityContact> {

        public int compare(EntityContact o1, EntityContact o2) {
            return o1.create.compareTo(o2.create);
        }

    }

    private static final StatusComparator statusComparator = new StatusComparator();

    private static final class StatusComparator implements Comparator<EntityStatus> {

        public int compare(EntityStatus o1, EntityStatus o2) {
            return o2.order - o1.order;
        }

    }

    // Данные для одного пользователя
    private static final class StatisticUser {
        // Пользователь для которого указанна статистика
        public EntityUser user;
        public List<StatisticDate> dates = new ArrayList<StatisticDate>();

    }

    // Елемент данных по одному разделу времени
    private static final class StatisticDate {
        // Карта количества контактов по статусу
        public Map<StatisticStatus, Integer> counts;
        // Дата по которую укзанно количество
        public Date finish;
        public Date start;

    }

    private static final class StatisticStatus implements Comparable<StatisticStatus> {

        public final EntityStatus status;

        public int compareTo(StatisticStatus o) {
            return o.status.order - status.order;
        }

        public boolean equals(Object object) {
            if (object == this) return true;
            if (object instanceof StatisticStatus) {
                return status.id.equals(((StatisticStatus) object).status.id);
            }
            return false;
        }

        public StatisticStatus(EntityStatus status) {
            this.status = status;
        }

    }

%>
<%
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yyyy");
    // Создаем условия статистики
    final PageStatisticDate pageStatistic = new PageStatisticDate();
    session.setAttribute("statisticuser", pageStatistic);
    // Выбираем статусы
    final List<EntityStatus> statuses = EntityManager.list(
            "select status from ua.com.testes.manager.entity.EntityStatus as status order by order desc");
    // Ограничеваем если надо перечень статусов
    String[] statusStringArray = request.getParameterValues("statisticstatus");
    // Если задан фильтр удалить все не нуждные статуты
    if (statusStringArray != null) {
        final Set<String> statusSet = new HashSet<String>(Arrays.asList(statusStringArray));
        Iterator<EntityStatus> statusIterator = statuses.iterator();
        while (statusIterator.hasNext()) {
            EntityStatus status = statusIterator.next();
            if (!statusSet.contains(Integer.toString(status.id))) {
                statusIterator.remove();
            } else {
                pageStatistic.statusIds.add(status.id);
            }
        }
    }

    // Список ошибок в данных
    final Set<PageStatisticDate.Error> errors = new HashSet<PageStatisticDate.Error>();

    // Использовать перидо
    if (request.getParameter("statisticperiod") != null) {
        pageStatistic.period = true;
        final GregorianCalendar calendar = new GregorianCalendar();
        try {
            int startYear = Integer.parseInt(request.getParameter("statisticstartyear"));
            int startMonth = Integer.parseInt(request.getParameter("statisticstartmonth"));
            int startDay = Integer.parseInt(request.getParameter("statisticstartday"));
            int finishDay = Integer.parseInt(request.getParameter("statisticfinishday"));
            int finishYear = Integer.parseInt(request.getParameter("statisticfinishyear"));
            int finishMonth = Integer.parseInt(request.getParameter("statisticfinishmonth"));
            calendar.set(startYear, startMonth, startDay, 0, 0, 0);
            pageStatistic.start = calendar.getTime();
            calendar.set(finishYear, finishMonth, finishDay, 0, 0, 0);
            pageStatistic.finish = calendar.getTime();
            if (pageStatistic.start.getTime() > pageStatistic.finish.getTime()) {
                errors.add(PageStatistic.Error.START_AFTER_FINISH_DATE);
                pageStatistic.finish = new Date(pageStatistic.start.getTime() + 1000L * 60L * 60L * 24L);
            }
        } catch (Exception exception) {
            pageStatistic.start = new Date();
            pageStatistic.finish = new Date(pageStatistic.start.getTime() + 1000L * 60L * 60L * 24L);
            errors.add(PageStatistic.Error.INCORRECT_DATE);
        }
    }

    // Получаем шаг нашей статистики
    pageStatistic.step = Integer.parseInt(request.getParameter("statisticstep"));

    // Множество пользователей
    final List<EntityUser> users = EntityManager.list(
            "select user from ua.com.testes.manager.entity.user.EntityUser as user");

    // Выбираем перечень пользователей
    final String[] userStringArray = request.getParameterValues("statisticuser");
    Set<String> userSet = null;
    if (userStringArray != null) {
        userSet = new HashSet<String>(Arrays.asList(userStringArray));
        Iterator<EntityUser> userIterator = users.iterator();
        while (userIterator.hasNext()) {
            final EntityUser user = userIterator.next();
            if (!userSet.contains(Integer.toString(user.getId()))) {
                userIterator.remove();
            }
        }
    }

    // Сеанс пользователя
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));

    // Выбираем все разделы
    final List<EntitySection> sections = EntityManager.list(
            "select section from ua.com.testes.manager.entity.EntitySection as section");

    // Ограничения по разделам
    String[] sectionStringArray = request.getParameterValues("statisticsection");
    Set<String> sectionSet = null;
    if (sectionStringArray != null) {
        sectionSet = new HashSet<String>(Arrays.asList(sectionStringArray));
    }

    // Перчень всех контактов, нужных
    final List<EntityContact> contacts = new ArrayList<EntityContact>();

    // Дата первого контакта по умолчанию
    Date defaultStart = new Date();

    Date defaultFinish = defaultStart;

    for (final EntitySection section : sections) {
        // Если множество не содержит этого раздела его не брать
        if (sectionSet != null) {
            if (!sectionSet.contains(Integer.toString(section.getId()))) continue;
            pageStatistic.sectionIds.add(section.getId());
        }

        for (final EntityFirm firm : section.getFirms()) {
            if (firm.getDelete() != null) continue;
            for (final EntityPipol pipol : firm.getPipols()) {
                if (pipol.getDelete() != null) continue;
                for (final EntityContact contact : pipol.getContacts()) {
                    if (contact.delete != null) continue;
                    if (userSet != null) {
                        if (!userSet.contains(Integer.toString(contact.user.getId()))) continue;
                        pageStatistic.userIds.add(contact.user.getId());
                    }
                    if (!user.getGroup().allowStatistic(contact.user)) continue;
                    if (pageStatistic.period) {
                        if (pageStatistic.start.getTime() > contact.create.getTime()) continue;
                        if (pageStatistic.finish.getTime() < contact.create.getTime()) continue;
                    }
                    if (!statuses.contains(contact.status)) continue;
                    // Если нужно укажем более малую дату
                    if (defaultStart.after(contact.create)) {
                        defaultStart = contact.create;
                    }
                    // Находим последнию дату
                    if (defaultFinish.before(contact.create)) {
                        defaultFinish = contact.create;
                    }
                    contacts.add(contact);
                }
            }
        }
    }

    // Теперь упорядочем по возрастанию даты
    Collections.sort(contacts, contactComparator);

    Date start;
    Date finish;
    Date current;

    // Назначем первую за начальной дату
    if (pageStatistic.period) {
        start = pageStatistic.start;
        finish = pageStatistic.finish;
    } else {
        start = defaultStart;
        finish = defaultFinish;
    }

    int countMax = 0;

    current = start;
    Date previous = start;

    int i = 0;

    final Map<EntityUser, StatisticUser> statistics = new HashMap<EntityUser, StatisticUser>();

    while (current.before(finish)) {

        // Получае текущию дату
        previous = current;
        current = new Date(current.getTime() + 1000L * 60L * 60L * 24L * (long) pageStatistic.step);

        // Перебераем всех пользователей
        for (EntityUser tempUser : users) {

            // Создание пустого отчета, на эту дату
            final Map<StatisticStatus, Integer> counts = new TreeMap<StatisticStatus, Integer>();
            for (final EntityStatus status : statuses) {
                counts.put(new StatisticStatus(status), 0);
            }

            // Перебираем все дозволенные контакты
            Iterator<EntityContact> contactIterator = contacts.iterator();
            while (contactIterator.hasNext()) {
                final EntityContact contact = contactIterator.next();

                // Если это нужный пользователь
                if (tempUser == contact.user) {

                    if (contact.create.before(current)) {
                        contactIterator.remove();
                        // Попадание
                        Integer count = counts.get(new StatisticStatus(contact.status)) + 1;
                        counts.put(new StatisticStatus(contact.status), count);
                        if (countMax < count + 1) {
                            countMax = count;
                        }
                    }
                }
            }

            // Добавление отчета статистики
            final StatisticDate date = new StatisticDate();
            date.counts = counts;
            date.start = previous;
            date.finish = current;

            // Выбираем для пользователя статистику
            StatisticUser statisticUser = statistics.get(tempUser);
            if (statisticUser == null) {
                statisticUser = new StatisticUser();
                statisticUser.user = tempUser;
                statistics.put(tempUser, statisticUser);
            }
            statisticUser.dates.add(date);
        }

        i++;

    }

    final double percent = 200.00 / (double) countMax;

    // Если перечень ошибок не пуст, вернуться на страницу настройки
    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.getRequestDispatcher("/security/statistic/user.jsp").forward(request, response);
        return;
    }
%>
<html>
    <head>
        <title>По периоду - статистика - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            .userInfo {font-size: 12px}
            .statusInfo {font-size: 8px; text-align: center;}

        </style>
    </head>
    <body>
        <p>
            Назад к <a href="/security/statistic/user.jsp"/>">статистики</a>, или к
            <a href="/security/main.jsp"/>">разделам</a>, максимум <%= countMax %>
        </p>
        <table border="0" cellpadding="0" cellspacing="0">
            <% for (final StatisticUser statisticUser : statistics.values()) { %>
                <tr>
                    <td colspan="2">
                        <%
                            boolean isZero = true;
                            for (StatisticDate statisticDate : statisticUser.dates) {
                                for (Integer count : statisticDate.counts.values()) {
                                    if (count > 0) {
                                        isZero = false;
                                        break;
                                    }
                                }
                            }
                            final Map<EntityStatus, Integer> countByStatusUsers = new HashMap<EntityStatus, Integer>(); 
                        %>
                        <% if (!isZero) { %>
                        <table border="0" cellpadding="0" cellspacing="5">
                            <tr>
                                <% for (final StatisticDate statistic : statisticUser.dates) { %>
                                    <td valign="bottom">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                    <img src="/image/transparent.gif" alt="" width="1" height="<%= (int) (countMax * percent) %>">
                                                </td>
                                                <%
                                                    List<StatisticStatus> statusList = new ArrayList<StatisticStatus>(statistic.counts.keySet());
                                                    Collections.sort(statusList);
                                                %>
                                                <% for (StatisticStatus status : statusList) { %>
                                                    <td valign="bottom">
                                                        <% final int value = statistic.counts.get(status); %>
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <% if (value > 0) { %>
                                                                <tr><td class="statusInfo"><%= value %></td></tr>
                                                            <% } %>
                                                            <tr>
                                                                <td valign="bottom" <%= value == 0 ? "rowspan=\"2\"" : "" %>>
                                                                    <% String link1 = "/security/statistic/userdaygraph.jsp?start=" + statistic.start.getTime() + "&finish=" + statistic.finish.getTime() + "&userid=" + statisticUser.user.getId(); %>
                                                                    <a target="_blank" href="<%= link1 %>"/>"><img src="/image/border.gif" border="0"
                                                                        alt="Отчет <%= status.status.name %> количество <%= value %> с <%= format.format(statistic.start) %> по <%= format.format(statistic.finish) %>"
                                                                        width="5" height="<%= (int) (value * percent) %>"></a></td>
                                                                    <%
                                                                        Integer countByStatusUser = countByStatusUsers.get(status.status);
                                                                        if (countByStatusUser == null) {
                                                                            countByStatusUsers.put(status.status, value);
                                                                        } else {
                                                                            countByStatusUsers.put(status.status, value + countByStatusUser);
                                                                        }
                                                                    %>
                                                            </tr>
                                                            <!--<tr>-->
                                                                <%--<td class="statusInfo" style="writing-mode: tb-rl"><%= format.format(statistic.current) %></td>--%>
                                                            <!--</tr>-->
                                                        </table>
                                                    </td>
                                               <% } %>
                                            </tr>
                                        </table>
                                    </td>
                                <% } %>
                            </tr>
                        </table>
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <a href="mailto:<%= statisticUser.user.getEmail() %>"><%= statisticUser.user.getFio() %></a>
                        <span class="userInfo">
                            <% int countTotal = 0; %>
                            <ul style="list-style: none; margin-top: 0; margin-bottom: 0">
                                <%
                                    List<EntityStatus> statusList = new ArrayList<EntityStatus>(countByStatusUsers.keySet());
                                    Collections.sort(statusList, statusComparator);
                                %>
                                <% for (final EntityStatus status : statusList) { %>
                                    <li><%= status.name %> <%= countByStatusUsers.get(status) %></li>
                                    <% countTotal += countByStatusUsers.get(status); %>
                                <% } %>
                            </ul>
                            <% if (countTotal == 0) { %>
                                <b>ничего нет</b>
                            <% } else { %>
                                <b>всего <%= countTotal %></b>
                            <% } %>
                        </span>    
                    </td>
                </tr>
                <tr><td>&nbsp;</td></tr>
            <% } %>
            <tr>
                <td align="left">С <%= format.format(start) %></td>
                <td align="right">по <%= format.format(finish) %></td>
            </tr>
        </table>
    </body>
</html>