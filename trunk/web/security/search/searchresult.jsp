<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.web.page.PageSearch" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.search.*" %>
<%@ page import="ua.com.testes.manager.logic.search.LogicSearch" %>
<%@ page import="java.io.Serializable" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<% request.setCharacterEncoding("utf-8"); %>
<%!
    private static final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy");
%>
<html>
    <%
        PageSearch pageSearch = (PageSearch) session.getAttribute("pageSearch");
        if (pageSearch == null) {
            pageSearch = new PageSearch();
        }
        session.setAttribute("pageSearch", pageSearch);
        String text = request.getParameter("text");
        if (text != null) {
            pageSearch.text = text.trim().toLowerCase();
        }
        // Отмечаем
        pageSearch.firm = (request.getParameter("firm") != null);
        pageSearch.contact = (request.getParameter("contact") != null);
        pageSearch.pipol = (request.getParameter("pipol") != null);
        // Если нечего не отмеченно
        if (!pageSearch.firm && !pageSearch.pipol && !pageSearch.contact) {
            pageSearch.firm = true;
            pageSearch.pipol = true;
            pageSearch.contact = true;
        }
        EntitySearch search = new EntitySearch();
        EntitySearchSource firms = null;
        EntitySearchSource pipols = null;
        EntitySearchSource contacts = null;
//        final List<EntityFirm> firmList = new ArrayList<EntityFirm>();
//        final List<EntityContact> contactList = new ArrayList<EntityContact>();
//        final List<EntityPipol> pipolList = new ArrayList<EntityPipol>();
//        final List<EntitySection> sections = EntityManager.list(
//            "select section from ua.com.testes.manager.entity.EntitySection as section");
        if (pageSearch.firm) {
            firms = new EntitySearchSourceFirm();
            EntitySearchRuleFirmName firmRule = new EntitySearchRuleFirmName();
            firmRule.name = pageSearch.text;
            firms.rule = firmRule;
            firmRule.source = firms;
            search.sources.add(firms);
            firms.search = search;
        }
        if (pageSearch.pipol) {
            pipols = new EntitySearchSourcePipol();
            EntitySearchRulePipolFio pipolRule = new EntitySearchRulePipolFio();
            pipolRule.fio = pageSearch.text;
            pipols.rule = pipolRule;
            search.sources.add(pipols);
            pipols.search = search;
        }
        if (pageSearch.contact) {
            contacts = new EntitySearchSourceContact();
            EntitySearchRuleContactDescription contactRule = new EntitySearchRuleContactDescription();
            contactRule.description = pageSearch.text;
            contacts.rule = contactRule;
            search.sources.add(contacts);
            contacts.search = search;
        }
        // Собственно сам поиск
        final Map<EntitySearchSource, List<Serializable>> results = LogicSearch.execute(search);
    %>
    <head>
        <title>Результаты поиска - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
    <a href="<login:link value="/security/search/search.jsp"/>">Назад</a> к поиску<p>
        <% if (pageSearch.firm) { %>
            <%
                final List<EntityFirm> resultFirms = (List) results.get(firms);
                final StringBuffer emailBuffer = new StringBuffer(resultFirms.size() * 36);
                boolean first = true;
                for (final EntityFirm firm : resultFirms) {
                    if (firm.getEmail().length() > 0) {
                        if (first) {
                            first = false;
                        } else {
                            emailBuffer.append(";");
                        }
                        emailBuffer.append(firm.getEmail());
                    }
                }
            %>
            <p>
                <b>Найдено фирм <%= resultFirms.size() %></b> для строки <b><%= pageSearch.text %></b>
                <% if (emailBuffer.length() > 0) { %>
                    <a href="mailto:&bcc=<%= emailBuffer.toString() %>">написать</a> этим компаниям
                <% } %>
            </p>
            <% for (final EntityFirm firm : resultFirms) { %>
                <a href="<login:link value="<%= "/security/detail.jsp?firmId=" + firm.getId() %>"/>"><%= firm.getName() %></a><br>
            <% } %>
        <% } %>
        <% if(pageSearch.pipol) { %>
            <% final List<EntityPipol> resultPipols = (List) results.get(pipols); %>
            <p><b>Найдены сотрудников <%= resultPipols.size() %></b><p>
            <% for (final EntityPipol pipol : resultPipols) { %>
                <%= pipol.getFio() %> из фирмы <a href="<login:link value="<%= "/security/detail.jsp?firmId=" + pipol.getFirm().getId() %>"/>"><%= pipol.getFirm().getName() %></a><br>
            <% } %>
        <% } %>
        <% if (pageSearch.contact) { %>
            <% final List<EntityContact> resultContacts = (List) results.get(contacts); %>
            <p><b>Найдены контактов <%= resultContacts.size() %></b><p>
            <% for (final EntityContact contact : resultContacts) { %>
                От <%= format.format(contact.getCreate()) %> с <%= contact.getPipol().getFio() %> из <a href="<login:link value="<%= "/security/detail.jsp?firmId=" + contact.getPipol().getFirm().getId() %>"/>"><%= contact.getPipol().getFirm().getName() %></a><br>
            <% } %>
        <% } %>
    </body>
</html>