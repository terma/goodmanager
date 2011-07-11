<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityFirmSort" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityView" %>
<%@ page import="ua.com.testes.manager.logic.view.LogicView" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!

    private static String fieldName(EntityFirmSort.Field field) {
        switch (field) {
            case ID: return "Код";
            case SITE: return "Сайт";
            case EMAIL: return "Электропочта";
            case NAME: return "Название";
            case FAX: return "Факс";
            case TELEPHON: return "Телефон";
            case DESCRIPTION: return "Заметки";
            case ADDRESS: return "Адрес";
        }
        return "";
    }

%>
<html>
    <head>
        <title>Представление - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <%
            final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
            Integer sectionId = null;
            if (request.getParameter("sectionId") != null) {
                sectionId = Integer.parseInt(request.getParameter("sectionId"));
            }
            Integer firmId = null;
            if (request.getParameter("firmId") != null) {
                firmId = Integer.parseInt(request.getParameter("firmId"));
            }
            final EntityView view = LogicView.get(user);
            EntityManager.execute(new EntityTransaction() {

                public Object execute(javax.persistence.EntityManager manager) {
                    user.setDefaultView(view);
                    manager.persist(user);
                    return null;
                }

            });
        %>
        Назад к <a href="<login:link value="/security/main.jsp"/>">главной</a>
        <% if (sectionId != null) { %>
            , к <a href="<login:link value='<%= "/security/list.jsp?sectionid=" + sectionId %>'/>">разделу</a>
        <% } %>
        <% if (firmId != null) { %>
            , к <a href="<login:link value='<%= "/security/detail.jsp?firmId=" + firmId %>'/>">фирме</a>
        <% } %>
        <p>
            Представление вашего интерфейса
            <%
                final List<EntityUser> users = EntityManager.list(
                    "select user from ua.com.testes.manager.entity.user.EntityUser as user");
            %>
            <form action="/security/viewuseraddresult.jsp" method="post">
                <table border="0" cellpadding="0" cellspacing="10">
                    <tr>
                        <td valign="top">
                            <% if (sectionId != null) { %>
                                <input type="hidden" name="sectionId" value="<%= sectionId %>">
                            <% } %>
                            <% if (firmId != null) { %>
                                <input type="hidden" name="firmId" value="<%= firmId %>">
                            <% } %>
                            Показывать фирмы только этих менеджеров
                            <ul style="list-style: none">
                                <% for (final EntityUser tempUser : users) { %>
                                    <li><input type="checkbox" <%= LogicView.isUserCheck(tempUser.getId(), view, false) ? "checked" : "" %> style="vertical-align: middle;" name="viewusers" value="<%= tempUser.getId() %>"> <%= tempUser.getFio() %></li>
                                <% } %>
                            </ul>
                            <login:input/>
                            Показывать историю
                            <ul style="list-style: none">
                                <li><input type="checkbox" <%= view.history.firm ? "checked" : "" %> name="firmhistorys"> редактирования фирмы</li>
                                <li><input type="checkbox" <%= view.history.pipol ? "checked" : "" %> name="pipolhistorys"> редактирования сорудников</li>
                                <li><input type="checkbox" <%= view.history.contact ? "checked" : "" %> name="contacthistorys"> редактирования контактов</li>
                            </ul>
                            Показывать удаленные
                            <ul>
                                <li><input type="checkbox" <%= view.delete.firm ? "checked" : "" %> name="firmdelete"> Показывать удаленные фирмы</li>
                                <li><input type="checkbox" <%= view.delete.pipol ? "checked" : "" %> name="pipoldelete"> Показывать удаленных сотрудников</li>
                                <li><input type="checkbox" <%= view.delete.contact ? "checked" : "" %> name="contactdelete"> Показывать удаленные контакты</li>
                            </ul>
                            Ваша почта
                            <ul>
                                <li><input type="checkbox" <%= view.mail.show ? "checked" : "" %> name="mailshow"> Показывать письма в вашем почтовом ящике</li>
                                <li><input type="text" name="mailcount" style="vertical-align: middle; width: 30px" value="<%= view.mail.count == null ? "" : view.mail.count %>"> количество писем которые нужно показывать</li>
                            </ul>
                            Разные счетчики
                            <ul>
                                <li><input type="checkbox" <%= view.byMe ? "checked" : "" %> name="byme"> Показывать 3, 6, 9 месяцев в списке фирм основываясь на моих контактах</li>
                                <li><input type="checkbox" <%= view.byMeOld ? "checked" : "" %> name="bymeold"> Показывать фирмы по которым давно не звонили только мои</li>
                                <li><input type="checkbox" <%= view.byMeTotal ? "checked" : "" %> name="bymetotal"> Показывать количество фирм только мои фирмы</li>
                                <li><input type="checkbox" <%= view.byMeRepeat ? "checked" : "" %> name="bymerepeat"> Показывать перезвонить только по мои контактам</li>
                            </ul>
                            Разное
                            <ul>
                                <li><input type="checkbox" <%= view.flateHead ? "checked" : "" %> name="flatehead"> Прокручивать заголовок в списке фирм</li>
                            </ul>
                            Курс валют (по отношени к гривне)
                            <ul style="list-style: none">
                                <li>
                                    <input type="checkbox" <%= view.showRate ? "checked" : "" %> name="rateshow"> Показывать курс валют
                                    (береться с <a href="http://www.bank.gov.ua">сайта</a> Национального Банка Украины)
                                </li>
                            </ul>
                            <input type="submit" value="Сохранить">
                        </td>
                        <td valign="top">
                            Сортировать фирмы по столбцам, так
                            <ul style="list-style: none">
                                <% for (final EntityFirmSort sort : view.sort.firms) { %>
                                    <li>
                                        №<%= sort.order %> <%= fieldName(sort.field) %>
                                        <% if (sort.order > 0) { %>
                                            <a href="<login:link value='<%= "/security/viewsorttopresult.jsp?sortId=" + sort.id + (sectionId == null ? "" : "&sectionId=" + sectionId) %>'/>">
                                                <img src="/image/top.gif" alt="На один вверх" height="15" width="15" border="0" style="vertical-align: middle;"></a>
                                        <% } %>
                                        порядок
                                        <% if (!sort.inverse) { %>
                                            <a href="<login:link value='<%= "/security/viewsortinverserresult.jsp?sortId=" + sort.id + "&inverse=true" + (sectionId == null ? "" : "&sectionId=" + sectionId) %>'/>">прямой</a>
                                        <% } else { %>
                                            <a href="<login:link value='<%= "/security/viewsortinverserresult.jsp?sortId=" + sort.id + "&inverse=false" + (sectionId == null ? "" : "&sectionId=" + sectionId) %>'/>">обратный</a>
                                        <% } %>
                                    </li>
                                <% } %>
                            </ul>
                            Показывать в списке фирм отмеченные данные:
                            <ul style="list-style: none">
                                <li><input type="checkbox" <%= view.showTelephon ? "checked" : "" %> name="showtelephon"> телефон</li>
                                <li><input type="checkbox" <%= view.showFax ? "checked" : "" %> name="showfax"> факс</li>
                                <li><input type="checkbox" <%= view.showAddress ? "checked" : "" %> name="showaddress"> адрес</li>
                                <li><input type="checkbox" <%= view.showEmail ? "checked" : "" %> name="showemail"> электронный адрес</li>
                                <li><input type="checkbox" <%= view.showWeb ? "checked" : "" %> name="showweb"> страница в интернете</li>
                                <li><input type="checkbox" <%= view.showOwner ? "checked" : "" %> name="showowner"> менеджера которому пренадлежит фирма</li>
                                <li><input type="checkbox" <%= view.showLastContact ? "checked" : "" %> name="showlastcontact"> последний контакт по фирме</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </form>
    </body>
</html>