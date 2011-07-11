<%@ page import="ua.com.testes.manager.entity.product.EntityCategory" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!

    private static void appendCategory(
            EntityCategory category, JspWriter out,
            Set<EntityCategory> selectedCategorys) throws IOException {
        out.append("<div class=\"menuItem\">");
        if (selectedCategorys.contains(category)) {
            out.append("<div class=\"selectedMenuItemLink\">");
        } else {
            out.append("<div class=\"menuItemLink\">");
        }
        out.append("<a href=\"ecology.jsp?categoryid=");
        out.append(Integer.toString(category.id));
        out.append("\">");
        out.append(category.name);
        out.append("</a>");
        out.append("</div>");
        for (EntityCategory childCategory : category.childs) {
            appendCategory(childCategory, out, selectedCategorys);
        }
        out.append("</div>\n");
    }

    private static Set<EntityCategory> getSelected(EntityCategory selectedCategory) {
        Set<EntityCategory> selectedCategorys = new HashSet<EntityCategory>();
//        EntityCategory parent = selectedCategory;
//        while (parent != null) {
//            selectedCategorys.add(parent);
//            parent = parent.parent;
//        }
        selectedCategorys.add(selectedCategory);
        return selectedCategorys;
    }

%>
<%
    final List<EntityCategory> rootCategorys = EntityManager.list(
            "select category from categorys as category where category.parent is null");
    Integer selectCategoryId = null;
    try {
        selectCategoryId = Integer.parseInt(request.getParameter("categoryid"));
    } catch (NumberFormatException exception) {
    }
    EntityCategory selectCategory = null;
    if (selectCategoryId != null) {
        selectCategory = EntityManager.get().find(EntityCategory.class, selectCategoryId);
    }
%>
<div id="tree">
    <div class="menuItemBlock">
        Решения по экологии
        <% Set<EntityCategory> selectedCategorys = getSelected(selectCategory); %>
        <% for (EntityCategory category : rootCategorys) { %>
            <% appendCategory(category, out, selectedCategorys); %>
        <% } %>
    </div>
    <div class="menuItemBlock">
        О компании
        <div class="menuItem">
            <div class="menuItemLink"><a href="contacts.jsp">Контакты</a></div>
        </div>
        <div class="menuItem">
            <div class="menuItemLink"><a href="#">Вакансии</a></div>
        </div>
    </div>
</div>