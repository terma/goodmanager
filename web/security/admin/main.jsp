<%@ page import="net.sf.ehcache.CacheManager" %>
<%@ page import="ua.com.testes.manager.web.filter.performan.PerformanCounter" %>
<%@ page import="ua.com.testes.manager.web.filter.performan.PerformanManager" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.logic.activeX1c.LogicActiveX1c" %>
<%@ page import="ua.com.testes.manager.util.activex1c.UtilActiveX1cConnection" %>
<%@ page import="ua.com.testes.manager.util.activex1c.UtilActiveX1c" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!

    private static final class CounterComparator implements Comparator<String> {

        private final Map<String, PerformanCounter> counters;

        public CounterComparator(final Map<String, PerformanCounter> counters) {
            this.counters = counters;
        }

        public int compare(String o1, String o2) {
            final PerformanCounter counter1 = counters.get(o1);
            final PerformanCounter counter2 = counters.get(o2);
            if (counter1 == null) return -1;
            if (counter2 == null) return +1;
            return Double.compare(counter2.getAverage(), counter1.getAverage());
        }
    }

%>
<%
    final CacheManager cacheManager = CacheManager.getInstance();
    final String[] cacheNames = cacheManager.getCacheNames();
%>
<html>
    <head>
        <title>Администрирование - Менджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        Назад к <a href="/security/main.jsp">разделам</a>
        <table border="0" cellpadding="0" cellspacing="10">
            <tr>
                <td valign="top">
                    Кеши
                    <ul style="list-style: none">
                        <% for (final String cacheName : cacheNames) { %>
                            <li>
                                <%= cacheName %>
                                <div style="font-size: 12px; padding-left: 20px">
                                    элементов <%= cacheManager.getCache(cacheName).getSize() %>
                                    размер <%= cacheManager.getCache(cacheName).getMemoryStoreSize() %>
                                </div>
                            </li>
                        <% } %>
                    </ul>
                    <% if (LogicActiveX1c.isUse()) { %>
                        Подключения к 1с, можно <a href="<login:link value="/security/admin/activex1cresetresult.jsp"/>">сбросить</a>
                        <ul>
                            <% for (final UtilActiveX1cConnection connection : UtilActiveX1c.getActive()) { %>
                                <li>База <%= connection.url %> Логин <%= connection.login %></li>
                            <% } %>
                        </ul>
                    <% } %>
                </td>
                <td valign="top">
                    Блоки производительности
                    <ul style="list-style: none">
                        <% Map<String, PerformanCounter> counters = PerformanManager.get(); %>
                        <% final CounterComparator comparator = new CounterComparator(counters); %>
                        <% final List<String> orderCounterNames = new ArrayList<String>(counters.keySet()); %>
                        <% Collections.sort(orderCounterNames, comparator); %>
                        <% for (final String name : orderCounterNames) { %>
                            <li>    
                                <a href="<%= name %>"><%= name %></a> время раз
                                <%= counters.get(name).getCount() %> общее
                                <%= counters.get(name).getTime() %>,
                                среднее <%= counters.get(name).getAverage() %> милисекунд
                            </li>
                        <% } %>
                    </ul>
                </td>
            </tr>
        </table>
    </body>
</html>