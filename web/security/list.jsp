<%@ page import="ua.com.testes.manager.web.page.PageFirm" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityFirmSort" %>
<%@ page import="ua.com.testes.manager.logic.view.LogicView" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityView" %>
<%@ page import="ua.com.testes.manager.logic.style.LogicStyle" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%!

    private static final class PageFirmComparator implements Comparator<PageFirm> {

        private final List<EntityFirmSort> sorts;

        public PageFirmComparator(final List<EntityFirmSort> sorts) {
            this.sorts = sorts;
        }

        public int compare(PageFirm o1, PageFirm o2) {
            int result;
            for (final EntityFirmSort sort : sorts) {
                if (sort.field == EntityFirmSort.Field.ID) {
                    result = o1.firm.getId().compareTo(o2.firm.getId());
                } else if (sort.field == EntityFirmSort.Field.NAME) {
                    result = o1.firm.getName().compareTo(o2.firm.getName());
                } else if (sort.field == EntityFirmSort.Field.DESCRIPTION) {
                    result = o1.firm.getDescription().compareTo(o2.firm.getDescription());
                } else if (sort.field == EntityFirmSort.Field.TELEPHON) {
                    result = o1.firm.getTelephon().compareTo(o2.firm.getTelephon());
                } else if (sort.field == EntityFirmSort.Field.SITE) {
                    result = o1.firm.getSite().compareTo(o2.firm.getSite());
                } else if (sort.field == EntityFirmSort.Field.FAX) {
                    result = o1.firm.getFax().compareTo(o2.firm.getFax());
                } else {
                    result = o1.firm.getEmail().compareTo(o2.firm.getEmail());
                }
                if (result != 0) {
                    return sort.inverse ? -1 * result : result;
                }
            }
            return 0;
        }

    }

%>
<html>
    <head>
        <title>Таблица фирм - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            .firmInfo {font-size: 12px;}
            .firmItem {border-style: solid; border-color:#000000; border-width: 1px;}
            #floathead {position: absolute; overflow: scroll;}

            #header {
                width: 100%; padding: 5px;
                position: fixed; top: 0;
                //position: absolute;
                top: expression(
                    document.getElementsByTagName( 'body' )[0].scrollTop + "px"
                );
            }
            #content {width: 100%;}

        </style>
        <script type="text/javascript">

            function changeFilterPhrase() {
                var filterPhrase = document.getElementById("filterPhrase").value;
                var firmInfoIds = document.getElementsByName("firmInfoId");

                var filteredFirmInfoCount = 0;

                for (var i = 0; i < firmInfoIds.length; i++) {
                    var firmInfoName = firmInfoIds[i].parentNode.getElementsByTagName("input")[1];
                    var mathcFirmName = firmInfoName.value.match(filterPhrase);
                    firmInfoName.parentNode.parentNode.style.display = mathcFirmName ? "block" : "none";
                    if (mathcFirmName) filteredFirmInfoCount++;
                }

                var filterPhraseResult = document.getElementById("filterPhraseResult");
                filterPhraseResult.innerHTML = "(всего " + firmInfoIds.length + " видно " + filteredFirmInfoCount + ")";
            }

        </script>
    </head>
    <body>
        <%
            final ua.com.testes.manager.entity.user.EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
            final EntityView view = LogicView.get(user);
            int sectionId;
            try {
                sectionId = Integer.parseInt(request.getParameter("sectionid"));
            } catch (NumberFormatException e) {
                response.sendRedirect("main.jsp");
                return;
            }
            final int tempSectionId = sectionId;
            final EntitySection section = EntityManager.find(EntitySection.class, tempSectionId);
            final long month3 = 3L * 31L * 24L * 60L * 60L * 1000L;
            final long month6 = 2 * month3;
            final long month9 = 3 * month3;
            final List<EntityFirm> firmList = section.getFirms();
            final List<PageFirm> pageFirm3List = new ArrayList<PageFirm>();
            final List<PageFirm> pageFirm6List = new ArrayList<PageFirm>();
            final List<PageFirm> pageFirm9List = new ArrayList<PageFirm>();
            final List<PageFirm> pageFirmList = new ArrayList<PageFirm>();
            for (final EntityFirm firm : firmList) {
                if (!view.delete.firm && firm.getDelete() != null) continue;
                if (!LogicView.isUserCheck(firm.getUser().getId(), view, true)) continue;
                final PageFirm firmInfo = new PageFirm();
                firmInfo.firm = firm;

                for (final EntityPipol pipol : firm.getPipols()) {
                    if (!view.delete.pipol && pipol.getDelete() != null) continue;
                    for (final EntityContact contact : pipol.getContacts()) {
                        if (!view.delete.contact && contact.delete != null) continue;
                        // Если смотреть по мне и это не мой контакт
                        if (view.byMe && contact.user != user) continue;
                        if (firmInfo.last == null) {
                            firmInfo.last = contact;
                        } else {
                            if (firmInfo.last.create.getTime() < contact.create.getTime()) {
                                firmInfo.last = contact;
                            }
                        }
                    }
                }

                if (firmInfo.last == null) {
                    pageFirmList.add(firmInfo);
                } else {
                    if (System.currentTimeMillis() - firmInfo.last.create.getTime() < month3) {
                        pageFirm3List.add(firmInfo);
                    } else {
                        if (System.currentTimeMillis() - firmInfo.last.create.getTime() < month6) {
                            pageFirm6List.add(firmInfo);
                        } else {
                            if (System.currentTimeMillis() - firmInfo.last.create.getTime() < month9) {
                                pageFirm9List.add(firmInfo);
                            } else {
                                pageFirmList.add(firmInfo);
                            }
                        }
                    }
                }
            }
            final PageFirmComparator comparator = new PageFirmComparator(view.sort.firms);
            Collections.sort(pageFirm3List, comparator);
            Collections.sort(pageFirm6List, comparator);
            Collections.sort(pageFirm9List, comparator);
            Collections.sort(pageFirmList, comparator);
        %>
            <%--<% if (view.flateHead) { %>--%>
        <!--<div id="header">-->
            <%--<% } else { %>--%>
            <jsp:include page="/security/util/mail/list.jsp" flush="true"/>
            <jsp:include page="/security/util/rate/list.jsp" flush="true"/>
            <p>
                Перечень фирм в разделе <%= LogicStyle.getHtml(section.getStyle(), section.getName()) %> к <a href="<login:link value='<%= "/security/main.jsp#section" + section.getId() %>'/>">разделам</a> к
                <a href="<login:link value="/security/search/search.jsp"/>">поиску</a> или создать <a href="<login:link value='<%= "/security/firmadd.jsp?sectionId=" + section.getId() %>'/>">фирму</a>,
                <a href="<login:link value='<%= "/security/views.jsp?sectionId=" + sectionId %>'/>">представление</a>
            </p>
            <p>
                Показывать фирмы если в названии есть <span id="filterPhraseResult"></span><br>
                <input type="text" style="width: 80%" id="filterPhrase" onkeyup="changeFilterPhrase()">
            </p>
        <!--</div>-->
        <!--<div id="content">-->
            <table border=0 cellspacing=0 cellpadding="5" width="100%">
                <% request.setAttribute("pageFirmList", pageFirm3List); %>
                <% request.setAttribute("monthCount", 3); %>
                <% request.setAttribute("view", view); %>
                <jsp:include page="/security/listinclude.jsp" flush="true"></jsp:include>
                <% request.setAttribute("monthCount", 6); %>
                <% request.setAttribute("pageFirmList", pageFirm6List); %>
                <jsp:include page="/security/listinclude.jsp" flush="true"></jsp:include>
                <% request.setAttribute("monthCount", 9); %>
                <% request.setAttribute("pageFirmList", pageFirm9List); %>
                <jsp:include page="/security/listinclude.jsp" flush="true"></jsp:include>
                <% request.setAttribute("monthCount", null); %>
                <% request.setAttribute("pageFirmList", pageFirmList); %>
                <jsp:include page="/security/listinclude.jsp" flush="true"></jsp:include>
            </table>
        <!--</div>-->
    </body>
</html>
