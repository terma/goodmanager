<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.content.EntityText" %>
<%@ page import="ua.com.testes.manager.logic.content.TextError" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    final EntityText text = new EntityText();
    final Set<TextError> errors = new HashSet<TextError>();

    text.name = request.getParameter("textname").trim();
    text.description = request.getParameter("textdescription").trim();

    if (text.name.length() == 0) {
        errors.add(TextError.NAME_EMPTY);
    } else {
        if (!EntityManager.list("select text from texts as text where text.name = :p0", text.name).isEmpty()) {
            errors.add(TextError.NAME_NOT_UNIQUE);
        }
    }

    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.setAttribute("text", text);
        request.getRequestDispatcher("/security/content/text/add.jsp").forward(request, response);
        return;
    }

    EntityManager.get().persist(text);

    response.sendRedirect("/security/content/text/main.jsp");
%>