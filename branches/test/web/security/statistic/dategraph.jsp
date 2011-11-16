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

    //    private static final long DAY = 24L * 60L * 60L * 1000L;
    private static final ContactDateComparator contactComparator = new ContactDateComparator();
    private static final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yyyy");

    private static final class ContactDateComparator implements Comparator<EntityContact> {

        public int compare(EntityContact o1, EntityContact o2) {
            return o1.create.compareTo(o2.create);
        }

    }

    private static final class StatisticDate {

        public Map<StatisticStatus, Integer> counts;
        public Date current;

    }

    private static final class StatisticStatus implements Comparable<StatisticStatus> {

        public final EntityStatus status;

        public int compareTo(StatisticStatus o) {
            return o.status.order - status.order;
        }

        public boolean equals(Object object) {
            if (object == this) return true;
            if (object instanceof StatisticStatus) {
                return status.id == ((StatisticStatus) object).status.id;
            }
            return false;
        }

        public StatisticStatus(EntityStatus status) {
            this.status = status;
        }

    }

%>
<%
    // Создаем условия статистики
    final PageStatisticDate pageStatistic = new PageStatisticDate();
    session.setAttribute("pageStatisticDate", pageStatistic);
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
    Set<PageStatisticDate.Error> errors = new HashSet<PageStatisticDate.Error>();

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

    // Ограничения по разделам
    String[] sectionStringArray = request.getParameterValues("statisticsection");
    Set<String> sectionSet = null;
    if (sectionStringArray != null) {
        sectionSet = new HashSet<String>(Arrays.asList(sectionStringArray));
    }

    // Перчень всех контактов, нужных
    final List<EntityContact> contacts = new ArrayList<EntityContact>();

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
                    contacts.add(contact);
                }
            }
        }
    }

    final List<StatisticDate> statistics = new ArrayList<StatisticDate>();

    // Теперь упорядочем по возрастанию даты
    Collections.sort(contacts, contactComparator);

    // Назначем первую за начальной дату
    final GregorianCalendar calendar = new GregorianCalendar();
    if (pageStatistic.period) {
        calendar.setTime(pageStatistic.start);
    } else {
        if (contacts.isEmpty()) {
            calendar.setTime(new Date());
        } else {
            calendar.setTime(contacts.get(0).create);
        }
    }
    calendar.set(Calendar.SECOND, 0);
    calendar.set(Calendar.HOUR, 0);
    calendar.set(Calendar.MINUTE, 0);
    calendar.set(Calendar.MILLISECOND, 0);

    int countMax = 0;

    final Date start = calendar.getTime();

    while (!contacts.isEmpty()) {
        // Получае текущию дату
        calendar.set(Calendar.DAY_OF_MONTH, calendar.get(Calendar.DAY_OF_MONTH) + pageStatistic.step);
        final Date current = calendar.getTime();

        // Создание пустого отчета
        final Map<StatisticStatus, Integer> counts = new TreeMap<StatisticStatus, Integer>();
        for (final EntityStatus status : statuses) {
            counts.put(new StatisticStatus(status), 0);
        }

        final Iterator<EntityContact> contactIterator = contacts.iterator();
        while (contactIterator.hasNext()) {
            final EntityContact contact = contactIterator.next();
            if (contact.create.before(current)) {
                // Попадание
                Integer count = counts.get(new StatisticStatus(contact.status)) + 1;
                counts.put(new StatisticStatus(contact.status), count);
                if (countMax < count + 1) {
                    countMax = count;
                }
                contactIterator.remove();
            } else {
                // Дальше искать бесполезно список отсортирован
                break;
            }
        }
        // Добавление отчета статистики
        StatisticDate date = new StatisticDate();
        date.counts = counts;
        date.current = calendar.getTime();
        statistics.add(date);
    }

    final Date end = calendar.getTime();

    final double percent = 400.00 / (double) countMax;

    // Если перечень ошибок не пуст, вернуться на страницу настройки
    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.getRequestDispatcher("/security/statistic/date.jsp").forward(request, response);
        return;
    }
%>
<html>
    <head>
        <title>По периоду - статистика - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <p>
            Назад к <a href="<login:link value="/security/statistic/date.jsp"/>">статистики</a>, или к
            <a href="<login:link value="/security/main.jsp"/>">разделам</a>            
        </p>
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td colspan="2">
                    <table border="0" cellpadding="0" cellspacing="5">
                        <tr>
                            <% for (final StatisticDate statistic : statistics) { %>
                                <td valign="bottom">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <% for (final StatisticStatus status : statistic.counts.keySet()) { %>
                                                <% final int value = statistic.counts.get(status); %>
                                                <td valign="bottom">
                                                    <img src="/image/border.gif"
                                                        alt="Отчет <%= status.status.name %> количество <%= value %> на момент <%= format.format(statistic.current) %>"
                                                        width="5" height="<%= (int) (value * percent) %>"></td>
                                            <% } %>
                                        </tr>
                                    </table>
                                </td>
                            <% } %>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="left"><%= format.format(start) %></td>
                <td align="right"><%= format.format(end) %></td>
            </tr>
        </table>
    </body>
</html>