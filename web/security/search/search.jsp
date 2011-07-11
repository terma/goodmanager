<%@ page import="ua.com.testes.manager.web.page.PageSearch" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<% request.setCharacterEncoding("utf-8"); %>
<html>
    <head>
        <title>Поиск - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            #searchHelp {
                display: none;
                width: 80%;
                text-align: left;
                margin: 10px
            }

        </style>
        <script type="text/javascript">

            function searchHelpClick() {
                document.getElementById("searchHelp").style.display = "block";
            }

        </script>
    </head>
    <body>
        <%
            PageSearch pageSearch = (PageSearch) session.getAttribute("pageSearch");
            if (pageSearch == null) {
                pageSearch = new PageSearch();
            }
        %>
        <table width="100%" height="100%">
            <tr>
                <td valign="center" align="center">
                    <p>
                        К <a href="<login:link value="/security/main.jsp"/>">разделам</a>
                        простой поиск, к
                        <a href="<login:link value="/security/search/searchadvance.jsp"/>">расширенному</a>
                        поиску, краткое
                        описание <a href="javascript:searchHelpClick()">здесь</a><br>
                        <div id="searchHelp">Поиск работает достаточно просто
                            выберете категорию поиска, если не одна не выбрана
                            поиск будет произведен везде, как если бы вы выбрали все,
                            на странице результатов вы можете выбрать вернуться
                            и вернетесь к этому окну с сохраненными настройками.
                        </div>
                    </p>
                    <form action="/security/search/searchresult.jsp" method="post">
                        <login:input/>
                        <input type="text" name="text" value="<%= pageSearch.text %>" style="width: 70%;">
                        <input type="submit" name="" value="Выполнить" style="vertical-align: top;"><br>
                        Место поиска <input type="checkbox" name="firm" <%= pageSearch.firm ? "checked" : "" %>> фирмы,
                        <input type="checkbox" name="pipol" <%= pageSearch.pipol ? "checked" : "" %>> сотрудники,
                        <input type="checkbox" name="contact" <%= pageSearch.contact ? "checked" : "" %>> контакты
                    </form>
                    <form action="/security/search/searchidresult.jsp">
                        <login:input/>
                        <input type="text" name="text" value="" style="width: 10%;">
                        <input type="submit" name="" value="По коду" style="vertical-align: top;">
                    </form>
                </td>
            </tr>
        </table>
    </body>
</html>