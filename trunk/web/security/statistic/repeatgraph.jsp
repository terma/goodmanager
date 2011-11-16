<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageStatistic" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!

    private static final ContactDateComparator contactComparator = new ContactDateComparator();
    private static final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yyyy");

    private static final class ContactDateComparator implements Comparator<EntityContact> {

        public int compare(EntityContact o1, EntityContact o2) {
            return o1.create.compareTo(o2.create);
        }

    }

    private static final class StatisticDate {

        public List<EntityContact> contacts = new ArrayList<EntityContact>();
        public Date current;

    }

%>
<%
    final EntityUser user = EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));

    // Создаем условия статистики
    final PageStatistic pageStatistic = new PageStatistic();
    session.setAttribute("statisticrepeat", pageStatistic);

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
    final Set<PageStatistic.Error> errors = new HashSet<PageStatistic.Error>();

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

    // Множество пользователей
    Set<String> userSet = null;
    final List<EntityUser> users;
    if (user.getGroup().id == 2) {
        users = EntityManager.list(
                "select user from ua.com.testes.manager.entity.user.EntityUser as user");
        // Выбираем перечень пользователей
        final String[] userStringArray = request.getParameterValues("statisticuser");
        if (userStringArray != null) {
            userSet = new HashSet<String>(Arrays.asList(userStringArray));
            Iterator<EntityUser> userIterator = users.iterator();
            while (userIterator.hasNext()) {
                if (!userSet.contains(Integer.toString(userIterator.next().getId()))) {
                    userIterator.remove();
                }
            }
        }
    } else {
        users = new ArrayList<EntityUser>();
        userSet = new HashSet<String>();
        userSet.add(Integer.toString(user.getId()));
        users.add(user);
    }

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
    final Date defaultStart = new Date();
    final Date defaultFinish = defaultStart;

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

    current = start;

    final List<StatisticDate> statistics = new ArrayList<StatisticDate>();

    while (current.before(finish)) {
        // Добавление отчета статистики
        final StatisticDate date = new StatisticDate();
        date.current = current;

        final Date currentNext = new Date(current.getTime() + 1000L * 60L * 60L * 24L);

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
                        if (contact.repeat == null) continue;
                        if (contact.repeat.after(current) && contact.repeat.before(currentNext)) {
                            date.contacts.add(contact);
                        }
                    }
                }
            }
        }

        statistics.add(date);

        current = currentNext;
    }

    // Если перечень ошибок не пуст, вернуться на страницу настройки
    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.getRequestDispatcher("/security/statistic/repeat.jsp").forward(request, response);
        return;
    }
%>
<html>
    <head>
        <title>Перезвонить - статистика - Менеджер 1.0</title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <p>Назад к <a href="/security/statistic/repeat.jsp">статистики</a>, или к <a href="/security/main.jsp">разделам</a></p>
        <table border="0" cellpadding="0" cellspacing="5">
            <tr>
                <% for (final StatisticDate date : statistics) { %>
                    <td valign="top">
                        <b>На <%= format.format(date.current) %></b><br>
                        Контактов <%= date.contacts.size() %>
                        <p>
                            <% for (final EntityContact contact : date.contacts) {
        String result = contact.description;
    EntityPipol result1 = contact.pipol;
    EntityPipol result2 = contact.pipol;
    EntityPipol result3 = contact.pipol;
    EntityPipol result4 = contact.pipol;
    EntityPipol result5 = contact.pipol;
    EntityPipol result6 = contact.pipol;
    %>
                                <p>
                                    Перезвонить <a href="mailto:<%= result6.getEmail() %>"><%= result5.getFio() %></a> из компании
                                    <a href="/security/detail.jsp?firmId=<%= result4.getFirm().getId() %>"><%= result3.getFirm().getName() %></a>
                                    которая в <a href="/security/list.jsp?sectionId=<%= result2.getFirm().getSection().getId() %>"><%= result1.getFirm().getSection().getName() %></a>
                                    по поводу <%= result %>
                                </p>
                            <% } %>
                        </p>
                    </td>
                <% } %>
            </tr>
        </table>
    </body>
</html>