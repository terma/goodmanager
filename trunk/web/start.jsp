<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.util.Date" %>
<%@ page import="ua.com.testes.manager.entity.tiding.EntityTiding" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final List<EntityTiding> tidings = EntityManager.list(
            "select tiding from tidings as tiding where tiding.finish > :p0 and tiding.start < :p1 order by tiding.start desc", new Date(), new Date());
%>
<html>
<head>
    <title>НПО ТехЭлектроСервис - Решения по экологии</title>
    <link type="text/css" href="styles/header.css" rel="stylesheet"/>
    <link type="text/css" href="styles/menu.css" rel="stylesheet"/>
    <link type="text/css" href="styles/footer.css" rel="stylesheet"/>
    <link type="text/css" href="styles/tiding.css" rel="stylesheet"/>
    <style type="text/css">

        body {
            background-image: url( "image/background.jpg" );
        }

        body, div, td {
            color: white;
            font-size: 14pt;
        }

    </style>
    <script type="text/javascript">

        function focusOnSearch() {
            var search = document.getElementById("search");
            if (!search.startWork) {
                search.backupValue = search.value;
                search.value = "";
            }
        }

        function inputInSearch() {
            var search = document.getElementById("search");
            search.startWork = true;
        }

        function focusFromSearch() {
            var search = document.getElementById("search");
            if (search.value.length == 0) {
                search.value = search.backupValue;
                search.startWork = false;
            }
        }

    </script>
</head>
<body>
<img id="headerBackground" src="image/header.png" alt=""
     style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src=image/header.png); width:expression(1); height:expression(1)">
<jsp:include page="header.jsp" flush="true"/>

<div id="menuBackground">
    <img src="image/menu.png" alt=""
         style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src=image/menu.png); width:expression(1); height:expression(1)">
</div>

<div id="menu">
    <a href="ecology.jsp">Решения по экологии</a>
    <a href="about.jsp">О компании</a>
    <form action="searchresult.jsp" method="get" style="margin: 0; display: inline;">
        <input type="text" id="search" name="text" value="Поиск" onkeyup="inputInSearch()" onblur="focusFromSearch()" onfocus="focusOnSearch()">
    </form>
</div>

<div id="tidingBackground">
    <img src="image/tiding.png" alt=""
         style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src=image/tiding.png); width:expression(1); height:expression(1)">
</div>

<div id="tiding">
    <% if (tidings.size() > 0) { %>
        <%= tidings.get(0).name %>    
    <% } %>
</div>
<a href="alltidings.jsp" id="allTidings">Все...</a>
<jsp:include page="footer.jsp" flush="true"/>
</body>
</html>