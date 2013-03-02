<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageDetailError" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageContractError" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Добавление договор - Менеджер 1.0</title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <script type="text/javascript">

            var contractFileCount = 1;

            function contractFileAdd() {
                contractFileCount++;
                var contractFileNew = document.createElement("div");
                contractFileNew.id = "contractfile" + contractFileCount;
                contractFileNew.innerHTML = "<input type='file' name='contractfile' style='width: 80%' onchange='contractFileAdd()'>";
                document.getElementById("contractfiles").appendChild(contractFileNew);
                document.getElementById("contractfilelabel").innerHTML = "Файлы";
            }

        </script>
    </head>
    <body>
        К <a href="/security/contract/main.jsp">договорам</a>
        <p>
            <%
                final Set<PageContractError> errors = (Set<PageContractError>) request.getAttribute("errors");
                EntityContract contract = (EntityContract) request.getAttribute("contract");
                if (contract == null) {
                    contract = new EntityContract();
                }
            %>
            <form action="/security/contract/contractaddresult.jsp" method="post" enctype="multipart/form-data">
                <p><b>Реквизиты договора</b></p>
                Название (например: ООО Фирмах)<br>
                <% if (errors != null && errors.contains(PageContractError.CONTRACT_NAME_EMPTY)) { %>
                    <b>Введите не пустое название договора</b><br>
                <% } %>
                <input type="text" name="contractname" value="<%= contract.name %>" style="width: 80%"><br>
                Заметки<br>
                <textarea rows="5" cols="1" style="width: 80%" name="contractdescription"></textarea>
                <p><b>Реквизиты файлов</b></p>
                <% if (errors != null && errors.contains(PageContractError.CONTRACT_FILE_EMTPY)) { %>
                    <b>Введите один файл с договором</b><br>
                <% } %>
                <div style="display: inline;" id="contractfilelabel">Файл</div><br>
                <div id="contractfiles">
                    <div id="contractfile1">
                        <input type="file" onchange="contractFileAdd()" name="contractfile" value="" style="width: 80%">
                    </div>
                </div>    
                <p><input type="submit" name="" value="Создать"></p>
            </form>
        </p>        
    </body>
</html>