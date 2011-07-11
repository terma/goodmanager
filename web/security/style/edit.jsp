<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.logic.style.LogicStyleException" %>
<%@ page import="ua.com.testes.manager.logic.style.LogicStyleError" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityUser user = EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    final EntityStyle style = EntityManager.find(
            EntityStyle.class, Integer.parseInt(request.getParameter("styleid")));
    if (style == null) {
        response.sendRedirect("/security/style/list.jsp");
        return;
    }
    final LogicStyleException exception = (LogicStyleException) request.getAttribute("exception");
%>
<html>
    <head>
        <title>Редактирование стиля - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <script type="text/javascript">

            function styleDemoBuild() {
                var styleDemo = document.getElementById("styledemo").style;
                if (document.getElementById("stylebold").checked) {
                    styleDemo.fontWeight = "bold";
                } else {
                    styleDemo.fontWeight = "normal";
                }
                if (document.getElementById("styleitaly").checked) {
                    styleDemo.fontStyle = "italic";
                } else {
                    styleDemo.fontStyle = "normal";
                }
                if (document.getElementById("stylecolorlist").checked) {
                    var styleColor = document.getElementById("stylecolor");
                    styleDemo.color = "#" + styleColor.options[styleColor.selectedIndex].value;
                } else {
                    styleDemo.color = "#" + document.getElementById("stylecolortext").value;
                }
            }

        </script>
    </head>
    <body onload="styleDemoBuild()">
        К <a href="<login:link value="/security/style/list.jsp"/>">стилям</a>,
        <a href="<login:link value="/security/main.jsp"/>">разделам</a>
        <form action="/security/style/editresult.jsp" method="post">
            <login:input/>
            <input type="hidden" name="styleid" value="<%= style.id %>">
            <p>
                Название стиля<br>
                <% if (exception != null && exception.errors.contains(LogicStyleError.NAME_EMPTY)) { %>
                    <b>Укажите не пустое имя стиля</b><br>
                <% } %>
                <% if (exception != null && exception.errors.contains(LogicStyleError.NAME_NOT_UNIQUE)) { %>
                    <b>Укажите уникальное имя стиля</b><br>
                <% } %>
                <input type="text" style="width: 80%" name="stylename" value="<%= exception != null ? exception.name : style.name %>">
            </p>
            <p>
                <input type="checkbox" onclick="styleDemoBuild()" id="stylebold" <%= style.bold ? "checked" : "" %> name="stylebold"> жирный<br>
                <input type="checkbox" onclick="styleDemoBuild()" id="styleunderline" <%= style.underline ? "checked" : "" %> name="styleunderline"> подчеркнутый<br>
                <input type="checkbox" onclick="styleDemoBuild()" id="stylestrikeout" <%= style.strikeout ? "checked" : "" %> name="stylestrikeout"> перечеркнутый<br>
                <input type="checkbox" onclick="styleDemoBuild()" id="styleitaly" <%= style.italic ? "checked" : "" %> name="styleitaly"> наклонный<br>
            </p>
            <p>
                И цвет
                <ul>
                    <li>
                        <input type="radio" name="stylecolormanual" id="stylecolorlist" style="vertical-align: middle;" onclick="styleDemoBuild()"> по списку
                        <select name="stylecolor" id="stylecolor" onchange="styleDemoBuild()">
                            <option value="000000">Черный</option>
                            <option value="ffffff">Белый</option>
                            <option value="00ff00">Зеленый</option>
                            <option value="ff0000">Красный</option>
                            <option value="0000ff">Синий</option>
                        </select>
                    </li>
                    <li>&nbsp;</li>
                    <li>
                        <input type="radio" checked name="stylecolormanual" id="stylecolormanual" style="vertical-align: middle;" onclick="styleDemoBuild()"> вручную #
                        <input type="text" maxlength="6" name="stylecolortext" id="stylecolortext" style="width: 55px; vertical-align: middle;" onkeypress="styleDemoBuild()" value="<%= style.color %>">
                    </li>
                </ul>
            </p>
            <p>
                Заметки (не обязательное)<br>
                <textarea rows="5" cols="" name="styledescription" style="width: 80%"><%= exception != null ? exception.description : style.description %></textarea>
            </p>
            <p>
                <span id="styledemo">Выглядеть это должно так</span>
            </p>
            <input type="submit" name="" value="Сохранить">
        </form>
    </body>
</html>