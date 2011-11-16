<%@ page import="ua.com.testes.manager.web.page.PageDetailError" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final EntityContact contact = new EntityContact();
    final List<PageDetailError> errors = new ArrayList<PageDetailError>();
    int firmId;
    try {
        firmId = Integer.parseInt(request.getParameter("firmId"));
    } catch (NumberFormatException exception) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    int pipolId = 0;
    try {
        pipolId = Integer.parseInt(request.getParameter("pipolId"));
    } catch (NumberFormatException exception) {
        errors.add(PageDetailError.PIPOL_NOT_SELECT);
    }
    int statusId = 0;
    try {
        statusId = Integer.parseInt(request.getParameter("statusId"));
    } catch (NumberFormatException exception) {
        errors.add(PageDetailError.STATUS_NOT_SELECT);
    }
    contact.description = request.getParameter("contactdescription");
    if (contact.description == null || contact.description.trim().length() == 0) {
        errors.add(PageDetailError.CONTACT_DESCRIPTION_EMPTY);
    }

    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.setAttribute("contact", contact);
        request.getRequestDispatcher("/security/contactadd.jsp?firmId=" + firmId + "&pipolId=" + pipolId).forward(request, response);
    } else {
        final int tempPipolId = pipolId;
        final int tempStatusId = statusId;
        EntityManager.execute(new EntityTransaction<Object>() {

            public Object execute(final javax.persistence.EntityManager manager) {
                contact.pipol = manager.find(EntityPipol.class, tempPipolId);
                contact.user = user;
                contact.status = manager.find(EntityStatus.class, tempStatusId);
                manager.persist(contact);
                contact.pipol.getContacts().add(contact);
                return null;
            }

        });
        response.sendRedirect("/security/detail.jsp?firmId=" + firmId);
    }
%>