<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntitySection" %>
<%@ page import="ua.com.testes.manager.view.search.ViewSearch" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.IOException" %>
<%@ page import="ua.com.testes.manager.entity.search.*" %>
<%@ page import="ua.com.testes.manager.logic.style.LogicStyle" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.util.UtilCalendar" %>
<%@ page import="ua.com.testes.manager.entity.EntityStatus" %>
<%@ page import="java.text.DateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%!

    private static final Comparator<EntitySearch> useSearchComparator = new Comparator<EntitySearch>() {

        public int compare(EntitySearch o1, EntitySearch o2) {
            return o2.use.compareTo(o1.use);
        }

    };

    private static void writeRule(final EntitySearchRule rule, final JspWriter writer, final DateFormat format) throws IOException {
        writer.print("<li>");
        if (rule instanceof EntitySearchRuleFirmComposite) {
            final EntitySearchRuleFirmComposite ruleComposite = (EntitySearchRuleFirmComposite) rule;
//            writer.print("где ");
//            writer.print(ruleComposite.type == EntitySearchRuleFirmComposite.Type.AND ? "" : " все ");
//            writer.print("<ul>");
            for (final EntitySearchRuleFirm childRule : ruleComposite.rules) {
                writeRule(childRule, writer, format);
            }
//            writer.print("</ul>");
        } else if (rule instanceof EntitySearchRulePipolComposite) {
            final EntitySearchRulePipolComposite ruleComposite = (EntitySearchRulePipolComposite) rule;
//            writer.print("где сотрудники ");
//            writer.print(ruleComposite.type == EntitySearchRulePipolComposite.Type.AND ? "" : " все ");
//            writer.print("<ul>");
            for (final EntitySearchRulePipol childRule : ruleComposite.rules) {
                writeRule(childRule, writer, format);
            }
//            writer.print("</ul>");
        } else if (rule instanceof EntitySearchRuleContactComposite) {
            final EntitySearchRuleContactComposite ruleComposite = (EntitySearchRuleContactComposite) rule;
//            writer.print("где контакты ");
//            writer.print(ruleComposite.type == EntitySearchRuleContactComposite.Type.AND ? "" : " все ");
//            writer.print("<ul>");
            for (final EntitySearchRuleContact childRule : ruleComposite.rules) {
                writeRule(childRule, writer, format);
            }
//            writer.print("</ul>");
        } else if (rule instanceof EntitySearchRuleFirmName) {
            final EntitySearchRuleFirmName ruleFirmName = (EntitySearchRuleFirmName) rule;
            writer.print("в название есть ");
            writer.print("<b>");
            writer.print(ruleFirmName.name);
            writer.print("</b>");
        } else if (rule instanceof EntitySearchRulePipolFio) {
            final EntitySearchRulePipolFio rulePipolFio = (EntitySearchRulePipolFio) rule;
            writer.print("в ФИО сотрудника есть ");
            writer.print("<b>");
            writer.print(rulePipolFio.fio);
            writer.print("</b>");
        } else if (rule instanceof EntitySearchRulePipolOther) {
            final EntitySearchRulePipolOther rulePipolOther = (EntitySearchRulePipolOther) rule;
            writer.print("в описании, телефоне, должности, e-mail сотрудника есть ");
            writer.print("<b>");
            writer.print(rulePipolOther.text);
            writer.print("</b>");
        } else if (rule instanceof EntitySearchRuleContactDescription) {
            final EntitySearchRuleContactDescription ruleContact = (EntitySearchRuleContactDescription) rule;
            writer.print("в описании контакта есть ");
            writer.print("<b>");
            writer.print(ruleContact.description);
            writer.print("</b>");
        } else if (rule instanceof EntitySearchRuleContactRepeat) {
            final EntitySearchRuleContactRepeat ruleContactRepeat = (EntitySearchRuleContactRepeat) rule;
            writer.print("есть контакты по которым перезвонить ");
            if (ruleContactRepeat.start != null) {
                writer.print("от <b>");
                writer.print(format.format(ruleContactRepeat.start));
                writer.print("</b>");
            }
            if (ruleContactRepeat.finish != null) {
                writer.print(" до <b>");
                writer.print(format.format(ruleContactRepeat.finish));
                writer.print("</b>");
            }
        } else if (rule instanceof EntitySearchRuleContactCreate) {
            final EntitySearchRuleContactCreate ruleContactCreate = (EntitySearchRuleContactCreate) rule;
            writer.print("есть контакты созданые ");
            if (ruleContactCreate.start != null) {
                writer.print("от <b>");
                writer.print(format.format(ruleContactCreate.start));
                writer.print("</b>");
            }
            if (ruleContactCreate.finish != null) {
                writer.print(" до <b>");
                writer.print(format.format(ruleContactCreate.finish));
                writer.print("</b>");
            }
        } else if (rule instanceof EntitySearchRuleFirmCreate) {
            final EntitySearchRuleFirmCreate ruleCreate = (EntitySearchRuleFirmCreate) rule;
            writer.print("есть фирмы созданые ");
            if (ruleCreate.start != null) {
                writer.print("от <b>");
                writer.print(format.format(ruleCreate.start));
                writer.print("</b>");
            }
            if (ruleCreate.finish != null) {
                writer.print(" до <b>");
                writer.print(format.format(ruleCreate.finish));
                writer.print("</b>");
            }
        } else if (rule instanceof EntitySearchRuleFirmDelete) {
            final EntitySearchRuleFirmDelete ruleFirm = (EntitySearchRuleFirmDelete) rule;
            writer.print("есть фирмы удаленные ");
            if (ruleFirm.start != null) {
                writer.print("от <b>");
                writer.print(format.format(ruleFirm.start));
                writer.print("</b>");
            }
            if (ruleFirm.finish != null) {
                writer.print(" до <b>");
                writer.print(format.format(ruleFirm.finish));
                writer.print("</b>");
            }
        } else if (rule instanceof EntitySearchRulePipolCreate) {
            final EntitySearchRulePipolCreate ruleCreate = (EntitySearchRulePipolCreate) rule;
            writer.print("есть сотрудники созданые ");
            if (ruleCreate.start != null) {
                writer.print("от <b>");
                writer.print(format.format(ruleCreate.start));
                writer.print("</b>");
            }
            if (ruleCreate.finish != null) {
                writer.print(" до <b>");
                writer.print(format.format(ruleCreate.finish));
                writer.print("</b>");
            }
        } else if (rule instanceof EntitySearchRulePipolDelete) {
            final EntitySearchRulePipolDelete rulePipol = (EntitySearchRulePipolDelete) rule;
            writer.print("есть сотрудники удаленные ");
            if (rulePipol.start != null) {
                writer.print("от <b>");
                writer.print(format.format(rulePipol.start));
                writer.print("</b>");
            }
            if (rulePipol.finish != null) {
                writer.print(" до <b>");
                writer.print(format.format(rulePipol.finish));
                writer.print("</b>");
            }
        } else if (rule instanceof EntitySearchRuleContactDelete) {
            final EntitySearchRuleContactDelete ruleContactDelete = (EntitySearchRuleContactDelete) rule;
            writer.print("есть контакты удаленые ");
            if (ruleContactDelete.start != null) {
                writer.print("от <b>");
                writer.print(format.format(ruleContactDelete.start));
                writer.print("</b>");
            }
            if (ruleContactDelete.finish != null) {
                writer.print(" до <b>");
                writer.print(format.format(ruleContactDelete.finish));
                writer.print("</b>");
            }
        } else if (rule instanceof EntitySearchRuleFirmOther) {
            final EntitySearchRuleFirmOther ruleFirmOther = (EntitySearchRuleFirmOther) rule;
            writer.print("в описание, e-mail, телефон, факс, адрес есть ");
            writer.print("<b>");
            writer.print(ruleFirmOther.text);
            writer.print("</b>");
        } else if (rule instanceof EntitySearchRuleFirmUser) {
            final EntitySearchRuleFirmUser ruleFirmUser = (EntitySearchRuleFirmUser) rule;
            if (ruleFirmUser.items.size() == 1) {
                writer.print("пользователь ");
            } else {
                writer.print("пользователи ");
            }
            writer.print("<br><b>");
            for (final EntitySearchRuleFirmUserItem item : ruleFirmUser.items) {
                final EntityUser tempUser = EntityManager.find(EntityUser.class, item.id.userId);
                writer.print("№" + item.id.userId);
                writer.print(" <a href=\"");
                writer.print("mailto:");
                writer.print(tempUser.getEmail());
                writer.print("\">");
                writer.print(tempUser.getFio());
                writer.print("</a><br>");
            }
            writer.print("</b>");
        } else if (rule instanceof EntitySearchRuleFirmSection) {
            final EntitySearchRuleFirmSection ruleFirmSection = (EntitySearchRuleFirmSection) rule;
            if (ruleFirmSection.items.size() == 1) {
                writer.print("в разделе ");
            } else {
                writer.print("в разделах ");
            }
            writer.print("<br><b>");
            for (final EntitySearchRuleFirmSectionItem item : ruleFirmSection.items) {
                final EntitySection section = EntityManager.find(EntitySection.class, item.id.sectionId);
                if (section != null) {
                    writer.print("№" + item.id.sectionId);
                    writer.print(" <a href=\"");
                    writer.print("/security/list.jsp?sectionid=");
                    writer.print(Integer.toString(section.getId()));
                    writer.print("\">");
                    writer.print(LogicStyle.getHtml(section.getStyle(), section.getName()));
                    writer.print("</a><br>");
                }
            }
            writer.print("</b>");
        } else if (rule instanceof EntitySearchRulePipolUser) {
            final EntitySearchRulePipolUser rulePipolUser = (EntitySearchRulePipolUser) rule;
            writer.print("сотрудники от ");
            if (rulePipolUser.items.size() == 1) {
                writer.print("менедера ");
            } else {
                writer.print("менеджеров ");
            }
            writer.print("<br><b>");
            for (final EntitySearchRulePipolUserItem item : rulePipolUser.items) {
                final EntityUser tempUser = EntityManager.find(EntityUser.class, item.id.userId);
                writer.print("№" + item.id.userId);
                writer.print(" <a href=\"");
                writer.print("mailto:");
                writer.print(tempUser.getEmail());
                writer.print("\">");
                writer.print(tempUser.getFio());
                writer.print("</a><br>");
            }
            writer.print("</b>");
        } else if (rule instanceof EntitySearchRuleContactUser) {
            final EntitySearchRuleContactUser ruleContactUser = (EntitySearchRuleContactUser) rule;
            writer.print("контакты от ");
            if (ruleContactUser.items.size() == 1) {
                writer.print("менеджера ");
            } else {
                writer.print("менеджеров ");
            }
            writer.print("<br><b>");
            for (final EntitySearchRuleContactUserItem item : ruleContactUser.items) {
                final EntityUser tempUser = EntityManager.find(EntityUser.class, item.id.userId);
                writer.print("№" + item.id.userId);
                writer.print(" <a href=\"");
                writer.print("mailto:");
                writer.print(tempUser.getEmail());
                writer.print("\">");
                writer.print(tempUser.getFio());
                writer.print("</a><br>");
            }
            writer.print("</b>");
        } else if (rule instanceof EntitySearchRuleContactStatus) {
            final EntitySearchRuleContactStatus ruleContactStatus = (EntitySearchRuleContactStatus) rule;
            writer.print("контакты с ");
            if (ruleContactStatus.items.size() == 1) {
                writer.print("статусом ");
            } else {
                writer.print("статусами ");
            }
            writer.print("<br><b>");
            for (final EntitySearchRuleContactStatusItem item : ruleContactStatus.items) {
                final EntityStatus tempStatus = EntityManager.find(EntityStatus.class, item.id.statusId);
                writer.print(tempStatus.name);
                writer.print("<br>");
            }
            writer.print("</b>");
        }
        writer.print("</li>");
    }

    private static void writeSearch(final EntitySearch search, final JspWriter writer, final DateFormat format) throws IOException {
        for (final EntitySearchSource source : search.sources) {
            writer.println("<div style=\"font-size: 12px;\">");
            writer.print("Поиск ");
            writer.print("<b>");
            if (source instanceof EntitySearchSourceFirm) {
                writer.print("фирм");
            } else if (source instanceof EntitySearchSourcePipol) {
                writer.print("сотрудников");
            } else if (source instanceof EntitySearchSourceContact) {
                writer.print("контактов");
            }
            writer.print("</b>");
            writer.print("<ul style=\"margin-left: 0;\">");
            writeRule(source.rule, writer, format);
            writer.print("</ul>");
            writer.println("</div>");
        }
    }

%>
<%
    request.setCharacterEncoding("utf-8");
    final ua.com.testes.manager.entity.user.EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final List<EntityUser> users = EntityManager.list(
            "select user from ua.com.testes.manager.entity.user.EntityUser as user");
    final List<EntitySection> sections = EntityManager.list(
            "select section from ua.com.testes.manager.entity.EntitySection as section");
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy", request.getLocale());
    final List<EntityStatus> statuses = EntityManager.list(
            "select status from ua.com.testes.manager.entity.EntityStatus as status");
%>
<html>
    <head>
        <title>Расширенный поиск - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <script type="text/javascript">

            function firmCreateStartChange() {
                document.getElementById("firmcreatestart").checked = true;
            }

            function firmCreateFinishChange() {
                document.getElementById("firmcreatefinish").checked = true;
            }

            function firmDeleteStartChange() {
                document.getElementById("firmdeletestart").checked = true;
            }

            function firmDeleteFinishChange() {
                document.getElementById("firmdeletefinish").checked = true;
            }

            function pipolCreateStartChange() {
                document.getElementById("pipolcreatestart").checked = true;
            }

            function pipolCreateFinishChange() {
                document.getElementById("pipolcreatefinish").checked = true;
            }

            function pipolDeleteStartChange() {
                document.getElementById("pipoldeletestart").checked = true;
            }

            function pipolDeleteFinishChange() {
                document.getElementById("pipoldeletefinish").checked = true;
            }

            function contactCreateStartChange() {
                document.getElementById("contactcreatestart").checked = true;
            }

            function contactCreateFinishChange() {
                document.getElementById("contactcreatefinish").checked = true;
            }

            function contactDeleteStartChange() {
                document.getElementById("contactdeletestart").checked = true;
            }

            function contactDeleteFinishChange() {
                document.getElementById("contactdeletefinish").checked = true;
            }

            function contactRepeatStartChange() {
                document.getElementById("contactrepeatstart").checked = true;
            }

            function contactRepeatFinishChange() {
                document.getElementById("contactrepeatfinish").checked = true;
            }

        </script>
    </head>
    <body>
        <p>
            К <a href="<login:link value="/security/main.jsp"/>">разделам</a>
            расширенный поиск, к
            <a href="<login:link value="/security/search/search.jsp"/>">простому</a>
            поиску
        </p>
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td valign="top" width="70%">
                    <!-- Условия поиска -->
                    <form action="/security/search/searchadvanceaddresult.jsp" method="post">
                        <login:input/>
                        <p><b>Условия по фирмам:</b></p>
                        <p>
                            Название<br>
                            <input type="text" name="firmname" value="" style="width: 100%"><br>
                            <p>
                                <input type="checkbox" name="firmdelete" style="vertical-align: top;">
                                Включать в поиск удаленные
                            </p>
                            <p>
                                <input type="checkbox" name="firmedit" style="vertical-align: top;">
                                Включать в поиск редактирование
                            </p>
                            Текст в адресе, телефоне, факсе, сайте, e-mail<br>
                            <input type="text" name="firmother" value="" style="width: 100%"><br>
                            <p>
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="50%" valign="top">
                                            Менеджеры
                                            <ul style="list-style: none">
                                                <% for (final EntityUser tempUser : users) { %>
                                                    <li>
                                                        <input type="checkbox" name="firmuser" style="vertical-align: middle;" value="<%= tempUser.getId() %>">
                                                        <a href="mailto:<%= tempUser.getEmail() %>"><%= tempUser.getFio() %></a>
                                                    </li>
                                                <% } %>
                                            </ul>
                                        </td>
                                        <td width="50%" valign="top">
                                            Разделы
                                            <ul style="list-style: none">
                                            <% for (final EntitySection section : sections) { %>
                                                <li>
                                                    <input type="checkbox" name="firmsection" style="vertical-align: middle;" value="<%= section.getId() %>">
                                                    <a href="<login:link value="<%= "/security/list.jsp?sectionid=" + section.getId() %>"/>"><%= LogicStyle.getHtml(section.getStyle(), section.getName()) %></a>
                                                </li>
                                            <% } %>
                                            </ul>
                                        </td>
                                    </tr>
                                </table>
                            </p>
                            Период создание фирмы <input type="checkbox" name="firmcreatestart"> от и
                            <input type="checkbox" name="firmcreatefinish"> до
                            <p>
                                От
                                <select onchange="firmCreateStartChange()" style="vertical-align: middle;" name="firmcreatestartyear">
                                    <%
                                        final GregorianCalendar calendar = new GregorianCalendar();
                                        final int year = calendar.get(Calendar.YEAR) - 5;
                                        final int maxYear = calendar.get(Calendar.YEAR) + 5;
                                        int repeatYear = calendar.get(Calendar.YEAR);
                                    %>
                                    <% for (int i = year; i < year + maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <% int repeatMonth = calendar.get(Calendar.MONTH); %>
                                <select style="vertical-align: middle;" onchange="firmCreateStartChange()" name="firmcreatestartmonth">
                                    <% final List<UtilCalendar.Month> months = UtilCalendar.getDisplayMonths(request.getLocale()); %>
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <% int repeatDay = calendar.get(Calendar.DAY_OF_MONTH); %>
                                <select name="firmcreatestartday" onchange="firmCreateStartChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                                до
                                <select onchange="firmCreateFinishChange()" style="vertical-align: middle;" name="firmcreatefinishyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="firmCreateFinishChange()" name="firmcreatefinishmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="firmcreatefinishday" onchange="firmCreateFinishChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                            </p>
                            Период удаления фирмы <input type="checkbox" name="firmdeletestart"> от и
                            <input type="checkbox" name="firmdeletefinish"> до
                            <p>
                                От
                                <select onchange="firmDeleteStartChange()" style="vertical-align: middle;" name="firmdeletestartyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="firmDeleteStartChange()" name="firmdeletestartmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="firmdeletestartday" onchange="firmDeleteStartChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                                до
                                <select onchange="firmDeleteFinishChange()" style="vertical-align: middle;" name="firmdeletefinishyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="firmDeleteFinishChange()" name="firmdeletefinishmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="firmdeletefinishday" onchange="firmDeleteFinishChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                            </p>
                        </p>
                        <p><b>Условия по сотрудникам:</b></p>
                        <p>
                            ФИО менеджера включает:
                            <p><input type="text" name="pipolfio" style="width: 100%"></p>
                            Описание, должность, телефон или электронный адрес менеджера включает:
                            <p><input type="text" name="pipolother" style="width: 100%"></p>
                            Менеджеры владелец:
                            <p>
                                <ul>
                                    <% for (final EntityUser tempUser : users) { %>
                                        <li>
                                            <input type="checkbox" name="pipoluser" style="vertical-align: middle;" value="<%= tempUser.getId() %>">
                                            <a href="mailto:<%= tempUser.getEmail() %>"><%= tempUser.getFio() %></a>
                                        </li>
                                    <% } %>
                                </ul>
                            </p>    
                            Период добавления сотрудника <input type="checkbox" name="pipolcreatestart"> от и
                            <input type="checkbox" name="pipolcreatefinish"> до
                            <p>
                                От
                                <select onchange="pipolCreateStartChange()" style="vertical-align: middle;" name="pipolcreatestartyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="pipolCreateStartChange()" name="pipolcreatestartmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="pipolcreatestartday" onchange="pipolCreateStartChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                                до
                                <select onchange="pipolCreateFinishChange()" style="vertical-align: middle;" name="pipolcreatefinishyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="pipolCreateFinishChange()" name="pipolcreatefinishmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="pipolcreatefinishday" onchange="pipolCreateFinishChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                            </p>
                            Период удаления сотрудника <input type="checkbox" name="pipoldeletestart"> от и
                            <input type="checkbox" name="pipoldeletefinish"> до
                            <p>
                                От
                                <select onchange="pipolDeleteStartChange()" style="vertical-align: middle;" name="pipoldeletestartyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="pipolDeleteStartChange()" name="pipoldeletestartmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="pipoldeletestartday" onchange="pipolDeleteStartChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                                до
                                <select onchange="pipolDeleteFinishChange()" style="vertical-align: middle;" name="pipoldeletefinishyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="pipolDeleteFinishChange()" name="pipoldeletefinishmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="pipoldeletefinishday" onchange="pipolDeleteFinishChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                            </p>
                        </p>
                        <p><b>Условия по контактам:</b></p>
                        <p>
                            Статус контакта один из
                            <p>
                                <ul>
                                    <% for (final EntityStatus status : statuses) { %>
                                        <li><input type="checkbox" name="contactstatus" value="<%= status.id %>"><%= status.name %></li>
                                    <% } %>
                                </ul>
                            </p>
                            Менеджеры владелец:
                            <p>
                                <ul>
                                    <% for (final EntityUser tempUser : users) { %>
                                        <li>
                                            <input type="checkbox" name="contactuser" style="vertical-align: middle;" value="<%= tempUser.getId() %>">
                                            <a href="mailto:<%= tempUser.getEmail() %>"><%= tempUser.getFio() %></a>
                                        </li>
                                    <% } %>
                                </ul>
                            </p>
                            Описание контакта включает:
                            <p><input type="text" name="contactdescription" style="width: 100%"></p>    
                            Период добавления контакта <input type="checkbox" name="contactcreatestart"> от и
                            <input type="checkbox" name="contactcreatefinish"> до
                            <p>
                                От
                                <select onchange="contactCreateStartChange()" style="vertical-align: middle;" name="contactcreatestartyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="contactCreateStartChange()" name="contactcreatestartmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="contactcreatestartday" onchange="contactCreateStartChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                                до
                                <select onchange="contactCreateFinishChange()" style="vertical-align: middle;" name="contactcreatefinishyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="contactCreateFinishChange()" name="contactcreatefinishmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="contactcreatefinishday" onchange="contactCreateFinishChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                            </p>
                            Период удаления контакта <input type="checkbox" name="contactdeletestart"> от и
                            <input type="checkbox" name="contactdeletefinish"> до
                            <p>
                                От
                                <select onchange="contactDeleteStartChange()" style="vertical-align: middle;" name="contactdeletestartyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="contactDeleteStartChange()" name="contactdeletestartmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="contactdeletestartday" onchange="contactDeleteStartChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                                до
                                <select onchange="contactDeleteFinishChange()" style="vertical-align: middle;" name="contactdeletefinishyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="contactDeleteFinishChange()" name="contactdeletefinishmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="contactdeletefinishday" onchange="contactDeleteFinishChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                            </p>
                            Период перезвонить контакта <input type="checkbox" name="contactrepeatstart"> от и
                            <input type="checkbox" name="contactrepeatfinish"> до
                            <p>
                                От
                                <select onchange="contactRepeatStartChange()" style="vertical-align: middle;" name="contactrepeatstartyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="contactRepeatStartChange()" name="contactrepeatstartmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="contactrepeatstartday" onchange="contactRepeatStartChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                                до
                                <select onchange="contactRepeatFinishChange()" style="vertical-align: middle;" name="contactrepeatfinishyear">
                                    <% for (int i = year; i < maxYear; i++) { %>
                                        <option <%= repeatYear == i ? "selected" : "" %> value="<%= i %>"><%= i %> год</option>
                                    <% } %>
                                </select> ,
                                <select style="vertical-align: middle;" onchange="contactRepeatFinishChange()" name="contactrepeatfinishmonth">
                                    <% for (UtilCalendar.Month month : months) { %>
                                        <option <%= repeatMonth == month.order ? "selected" : "" %> value="<%= month.order %>"><%= month.name %>
                                            (<%= month.getDisplayOrder() %>)
                                        </option>
                                    <% } %>
                                </select>,
                                <select name="contactrepeatfinishday" onchange="contactRepeatFinishChange()" style="vertical-align: middle;">
                                    <% for (int i = 1; i < 32; i++) { %>
                                        <option <%= repeatDay == i ? "selected" : "" %> value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>
                            </p>
                        </p>
                        <input type="submit" name="" value="Выполнить" style="vertical-align: top;">
                    </form>
                </td>
                <td width="30%" valign="top" style="padding-left: 20px">
                    <!-- Список поисков сохраненных и последних используемых -->
                    <%
                        final List<EntitySearch> parkSearchs = ViewSearch.getByPark(user.getId());
                        final List<EntitySearch> useSearchs = ViewSearch.getByUse(user.getId());
                        Collections.sort(useSearchs, useSearchComparator);
                    %>
                    <p>
                        <b>Сохраненных поисков
                            <% if (!parkSearchs.isEmpty()) { %>
                                <%= parkSearchs.size() %>
                            <% } else { %>
                                нет
                            <% } %>
                        </b>
                        <% if (!parkSearchs.isEmpty()) { %>
                            <p>                        
                                <% for (final EntitySearch search : parkSearchs) { %>
                                    <p>
                                        <a href="<login:link value="<%= "/security/search/searchadvancedeleteresult.jsp?searchId=" + search.id %>"/>"><img src="/image/delete.gif" alt="Удалить" border="0" width="15" style="vertical-align: top;" height="15"></a>
                                        От <%= format.format(search.use) %>,
                                        <a href="<login:link value="<%= "/security/search/searchadvance.jsp?searchId=" + search.id %>"/>">посмотреть</a>,
                                        <a href="<login:link value="<%= "/security/search/searchadvanceresult.jsp?searchId=" + search.id %>"/>">результат</a>
                                        <% writeSearch(search, out, format); %>
                                    </p>
                                <% } %>
                            </p>
                        <% } %>
                    </p>
                    <% if (!useSearchs.isEmpty()) { %>
                        <p>
                            <b>Последние поиски, всего <%= useSearchs.size() %></b>
                            <% for (final EntitySearch search : useSearchs) { %>
                                <p>
                                    <a href="<login:link value="<%= "/security/search/searchadvancedeleteresult.jsp?searchId=" + search.id %>"/>"><img src="/image/delete.gif" alt="Удалить" border="0" width="15" style="vertical-align: top;" height="15"></a>
                                    От <%= format.format(search.use) %>,
                                    <a href="<login:link value="<%= "/security/search/searchadvance.jsp?searchId=" + search.id %>"/>">посмотреть</a>,
                                    <a href="<login:link value="<%= "/security/search/searchadvanceresult.jsp?searchId=" + search.id %>"/>">результат</a>,
                                    <a href="<login:link value="<%= "/security/search/searchadvanceparkresult.jsp?searchId=" + search.id %>"/>">сохранить</a>
                                    <% writeSearch(search, out, format); %>
                                </p>
                            <% } %>
                        </p>
                    <% } %>
                </td>
            </tr>
        </table>
    </body>
</html>