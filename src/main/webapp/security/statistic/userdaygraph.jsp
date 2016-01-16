<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageStatistic" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageStatisticDate" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!

    private static final class Day {

        public Map<Integer, Hour> hours = new TreeMap<Integer, Hour>();
        public Date start;
        public Date finish;

    }

    private static final class Hour {

        public List<EntityContact> contacts = new ArrayList<EntityContact>();

    }

%>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yyyy");
    final String userIdString = request.getParameter("userid");
    final int userId = Integer.parseInt(userIdString);
    final Date start = new Date(Long.parseLong(request.getParameter("start")));
    final Date finish = new Date(Long.parseLong(request.getParameter("finish")));
    final List<EntityContact> contacts = EntityManager.list(
            "select contact from contacts as contact " +
                    "where contact.user.id = :p0 ", userId);
    Date tempStart = start;
    GregorianCalendar calendar = new GregorianCalendar();
    final List<Day> days = new ArrayList<Day>();
    while (tempStart.before(finish)) {
        tempStart = new Date(tempStart.getTime() + 1000L * 60L * 60L * 24L);
        Day day = new Day();
        day.start = tempStart;
        day.finish = new Date(tempStart.getTime() + 1000L * 60L * 60L * 24L);

        for (int i = 0; i < 24; i++) {
            day.hours.put(i, new Hour());
        }

        for (EntityContact contact : contacts) {
            if (contact.create.after(tempStart) && contact.create.before(day.finish)) {
                calendar.setTime(contact.create);
                final int contactCreateHour = calendar.get(Calendar.HOUR_OF_DAY);
                Hour hour = day.hours.get(contactCreateHour);
                hour.contacts.add(contact);
            }
        }
        days.add(day);
    }
    
%>
<html>
    <head>
        <title>По дням для менеджера - статистика - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            .countContactInHour, .hour {font-size: 8px; text-align: center;}

        </style>
    </head>
    <body>
        <p>
            Период с <%= format.format(start) %> по <%= format.format(finish) %>        
        </p>
        <% for (Day day : days) { %>
            <%
                boolean dayWithoutContact = true;
                for (Integer hourKey : day.hours.keySet()) {
                    if (day.hours.get(hourKey).contacts.size() > 0) {
                        dayWithoutContact = false;
                        break;
                    }
                }
                if (dayWithoutContact) {
                    continue;
                }
            %>
            <% if (day.hours.size() > 0) { %>
                <p>
                    <p><%= day.hours.size() %> контактов за <%= format.format(day.start) %></p>
                    <table border="0" cellpadding="0" cellspacing="10">
                        <tr valign="bottom">
                            <% for (Integer hourKey : day.hours.keySet()) { %>
                                <% final int countContactInHour = day.hours.get(hourKey).contacts.size(); %>
                                <td align="center">
                                    <% if (countContactInHour > 0) { %>
                                    <span class="countContactInHour"><%= countContactInHour %></span><br>
                                    <% } %>
                                    <img border="0" src="/image/border.gif" alt="" width="15" height="<%= (countContactInHour * 10) %>">
                                    <br><span class="hour"><%= (hourKey < 9 ? "0" : "") + (hourKey + 1) %></span>
                                </td>
                            <% } %>
                        </tr>
                    </table>
                </p>
            <% } %>
        <% } %>
    </body>
</html>