<%@ page import="ua.com.testes.manager.web.page.PageFirm" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityView" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
    final EntityView view = (EntityView) request.getAttribute("view");
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy", request.getLocale());
    final Integer monthCount = (Integer) request.getAttribute("monthCount");
    final List<PageFirm> firmInfoList = (List<PageFirm>) request.getAttribute("pageFirmList");
%>
<tr>
    <td colspan="5">
        <% if (view.byMe) { %>
            <b>Фирм <%= monthCount == null ? "без с моими контактами" : "с последним моим контактом в " + monthCount + " месяцев" %>
        <% } else { %>
                <b>Фирм <%= monthCount == null ? "без контактов" : "с последним контактом в " + monthCount + " месяцев" %>        
        <% } %>

        <% if (firmInfoList.isEmpty()) { %>
                не оказалось.
        <% } else { %>
                всего <%= firmInfoList.size() %>    
        <% } %>
            </b>
    </td>
</tr>

<% if (!firmInfoList.isEmpty()) { %>
    <% boolean even = false; %>
    <% for (final PageFirm firmInfo : firmInfoList) { %>
        <tr bgcolor="<%= even ? "#F8F8F8" : "#ffffff" %>" id="firmInfo<%= firmInfo.firm.getId() %>">
            <td>
                <% if (firmInfo.firm.getPublicStyle() != null) { %>
                    <% if (firmInfo.firm.getPublicStyle().bold) { %><b><% } %>
                    <% if (firmInfo.firm.getPublicStyle().underline) { %><u><% } %>
                    <% if (firmInfo.firm.getPublicStyle().strikeout) { %><s><% } %>
                    <% if (firmInfo.firm.getPublicStyle().italic) { %><i><% } %>
                <% } %>

                <% if (firmInfo.firm.getDelete() == null) { %>
                    <a href="/security/firmdeleteconfirm.jsp?firmId=<%= firmInfo.firm.getId() %>">
                        <img src="/image/delete.gif" style="vertical-align: middle;" width="15" height="15" border="0" alt="Удалить фирму"></a>
                <% } %>

                <a name="firmId<%= firmInfo.firm.getId() %>">
                    <span style="color: #<%= Integer.toHexString(firmInfo.firm.getPublicStyle() == null ? 0 : firmInfo.firm.getPublicStyle().color) %>">
                        №<%= firmInfo.firm.getId() %>&nbsp;
                        <a href="detail.jsp?firmId=<%= firmInfo.firm.getId() %>"><%= firmInfo.firm.getName() %></a>
                    </span>
                </a>

                <% if (firmInfo.firm.getPublicStyle() != null) { %>
                    <% if (firmInfo.firm.getPublicStyle().underline) { %></u><% } %>
                    <% if (firmInfo.firm.getPublicStyle().italic) { %></i><% } %>
                    <% if (firmInfo.firm.getPublicStyle().strikeout) { %></s><% } %>
                    <% if (firmInfo.firm.getPublicStyle().bold) { %></b><% } %>
                <% } %>

                <input type="hidden" name="firmInfoId" value="<%= firmInfo.firm.getId() %>">
                <input type="hidden" id="firmInfo<%= firmInfo.firm.getId() %>Name" value="<%= firmInfo.firm.getName() %>">
            </td>

            <td class="firmInfo">
                <% if (view.showTelephon && StringUtils.isNotEmpty(firmInfo.firm.getTelephon())) { %>
                    Тел.: <%= firmInfo.firm.getTelephon() %><br>
                <% } %>
                <% if (view.showFax && StringUtils.isNotEmpty(firmInfo.firm.getFax())) { %>
                    Факс: <%= firmInfo.firm.getFax() %><br>
                <% } %>
                <% if (view.showEmail && StringUtils.isNotEmpty(firmInfo.firm.getEmail())) { %>
                    E-mail: <a href="mailto:<%= firmInfo.firm.getEmail() %>"><%= firmInfo.firm.getEmail() %></a><br>
                <% } %>
                <% if (view.showWeb && StringUtils.isNotEmpty(firmInfo.firm.getSite())) { %>
                    <a href="<%= firmInfo.firm.getSite() %>"><%= firmInfo.firm.getSite() %></a>
                <% } %>
            </td>

            <td class="firmInfo">
                <% if (view.showAddress) { %>
                    <%= firmInfo.firm.getAddress() %>
                <% } %>
            </td>

            <% if (view.showOwner) { %>
                <td class="firmInfo">
                    <a href="mailto:<%=firmInfo.firm.getUser().getEmail() %>"><%= firmInfo.firm.getUser().getFio() %></a> от
                    <%= format.format(firmInfo.firm.getCreate()) %>
                </td>
            <% } %>

            <% if (view.showLastContact) { %>
                <td class="firmInfo">
                    Последний контакт от <%= firmInfo.last != null ? format.format(firmInfo.last.create) : "нет" %>
                </td>
            <% } %>
            <% even = !even; %>

        </tr>
    <% } %>
<% } %>
