<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageStatistic" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!

    private static final class PageSectionCount {

        public EntitySection section;
        public Map<PageStatisticStatus, Integer> counts;

    }

    private static final class PageStatisticStatus implements Comparable<PageStatisticStatus> {

        public final EntityStatus status;

        public int compareTo(PageStatisticStatus o) {
            return o.status.order - status.order;
        }

        public boolean equals(Object object) {
            if (object == this) return true;
            if (object instanceof PageStatisticStatus) {
                return status.id == ((PageStatisticStatus) object).status.id;
            }
            return false;
        }

        public PageStatisticStatus(EntityStatus status) {
            this.status = status;
        }

    }

%>
<%// Создаем условия статистики
    final PageStatistic pageStatistic = new PageStatistic();
    session.setAttribute("pageStatistic", pageStatistic);
    // Выбираем статусы
    final List<EntityStatus> statuses = EntityManager.list(
            "select status from ua.com.testes.manager.entity.EntityStatus as status order by order desc");
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
    Set<PageStatistic.Error> errors = new HashSet<PageStatistic.Error>();

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

    // Выбираем перечень пользователей
    final String[] userStringArray = request.getParameterValues("statisticuser");
    Set<String> userSet = null;
    if (userStringArray != null) {
        userSet = new HashSet<String>(Arrays.asList(userStringArray));
    }

    // Сеанс пользователя
    final EntityUser user = EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));

    // Выбираем все разделы
    final List<EntitySection> sections = EntityManager.list(
            "select section from ua.com.testes.manager.entity.EntitySection as section");
    final List<PageSectionCount> statistics = new ArrayList<PageSectionCount>(sections.size());
    int maxCount = 1;
    String[] sectionStringArray = request.getParameterValues("statisticsection");
    Set<String> sectionSet = null;
    if (sectionStringArray != null) {
        sectionSet = new HashSet<String>(Arrays.asList(sectionStringArray));
    }
    for (final EntitySection section : sections) {
        // Если множество не содержит этого раздела его не брать
        if (sectionSet != null) {
            if (!sectionSet.contains(Integer.toString(section.getId()))) continue;
            pageStatistic.sectionIds.add(section.getId());
        }
        final Map<PageStatisticStatus, Integer> count = new TreeMap<PageStatisticStatus, Integer>();
        for (final EntityStatus status : statuses) {
            count.put(new PageStatisticStatus(status), 0);
        }
        for (final EntityFirm firm : section.getFirms()) {
            if (firm.getDelete() != null) continue;
            for (final EntityPipol pipol : firm.getPipols()) {
                if (pipol.getDelete() != null) continue;
                for (final EntityContact contact : pipol.getContacts()) {
                    if (contact.getDelete() != null) continue;
                    if (userSet != null) {
                        if (!userSet.contains(Integer.toString(contact.getUser().getId()))) continue;
                        pageStatistic.userIds.add(contact.getUser().getId());
                    }
                    if (!user.getGroup().allowStatistic(contact.getUser())) continue;
                    if (pageStatistic.period) {
                        if (pageStatistic.start.getTime() > contact.getCreate().getTime()) continue;
                        if (pageStatistic.finish.getTime() < contact.getCreate().getTime()) continue;
                    }
                    if (!statuses.contains(contact.getStatus())) continue;
                    int tempCount = count.get(new PageStatisticStatus(contact.getStatus())) + 1;
                    if (maxCount < tempCount) {
                        maxCount = tempCount;
                    }
                    count.put(new PageStatisticStatus(contact.getStatus()), tempCount);
                }
            }
        }
        final PageSectionCount statistic = new PageSectionCount();
        statistic.section = section;
        statistic.counts = count;
        statistics.add(statistic);
    }
    final double percent = 300.00 / (double) maxCount;

    // Если перечень ошибок не пуст, вернуться на страницу настройки
    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.getRequestDispatcher("/security/statistic/count.jsp").forward(request, response);
        return;
    }
%>
<html>
    <head>
        <title>Информация о вас - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <p>
            Назад к <a href="<login:link value="/security/statistic/count.jsp"/>">статистики</a>, или к
            <a href="<login:link value="/security/main.jsp"/>">разделам</a>            
        </p>
        <table border="0" cellpadding="5" cellspacing="0">
            <% boolean even = true; %>
            <% for (final PageSectionCount statistic : statistics) { %>
                <tr bgcolor="<%= even ? "#F8F8F8" : "#ffffff" %>">
                    <td><a href="/security/list.jsp?sectionId=<%= statistic.section.getId() %>"><%= statistic.section.getName() %></a></td>
                    <% Integer previous = null; %>
                    <% for (final PageStatisticStatus statisticStatus : statistic.counts.keySet()) { %>
                        <% int count = statistic.counts.get(statisticStatus); %>
                        <td>
                            <% if (previous != null && count > previous) { %><strike><% } %>
                            <%= count %>
                            <% if (previous != null && count > previous) { %></strike><% } %>
                        </td>
                        <% previous = count; %>
                    <% } %>
                    <td>
                        <% for (PageStatisticStatus statisticStatus : statistic.counts.keySet()) { %>
                            <% double i = statistic.counts.get(statisticStatus); %>
                            <img src="/image/border.gif" alt="Результат для <%= statisticStatus.status.name %>, всего <%= (int) i %>" width="<%= (int) (percent * i) %>" height="5"><br>
                        <% } %>
                    </td>
                </tr>
                <% even = !even; %>
            <% } %>
        </table>
    </body>
</html>