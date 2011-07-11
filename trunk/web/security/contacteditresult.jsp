<%@ page import="ua.com.testes.manager.web.page.PageDetailError" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final EntityContact editContact = new EntityContact();
    final List<PageDetailError> errors = new ArrayList<PageDetailError>();
    editContact.setId(Integer.parseInt(request.getParameter("contactid")));
    final EntityContact contact = EntityManager.find(EntityContact.class, editContact.getId());
    editContact.setPipol(contact.getPipol());
    editContact.setDescription(request.getParameter("contactdescription").trim());
    try {
        final int statusId = Integer.parseInt(request.getParameter("statusId"));
        editContact.setStatus(EntityManager.find(EntityStatus.class, statusId));
    } catch (NumberFormatException exception) {
        errors.add(PageDetailError.STATUS_NOT_SELECT);
    }
    // Если нужно повторный контакт
    if (request.getParameter("contactrepeatneed") != null) {
        final String repeatType = request.getParameter("contactrepeattype");
        if ("date".equals(repeatType)) {
            final GregorianCalendar calendar = new GregorianCalendar();
            try {
                int year = Integer.parseInt(request.getParameter("contactrepeatdateyear"));
                int month = Integer.parseInt(request.getParameter("contactrepeatdatemonth"));
                int day = Integer.parseInt(request.getParameter("contactrepeatdateday"));
                calendar.set(year, month, day, 0, 0, 0);
                // Устанавливаем дату контакта
                final GregorianCalendar nowCalendar = new GregorianCalendar();
                nowCalendar.set(Calendar.HOUR_OF_DAY, 0);
                nowCalendar.set(Calendar.MINUTE, 0);
                nowCalendar.set(Calendar.SECOND, 0);
                nowCalendar.set(Calendar.MILLISECOND, 0);
                if (nowCalendar.getTime().after(calendar.getTime())) {
                    errors.add(PageDetailError.CONTACT_REPEATE_DATE_INCORRENT);
                }
                editContact.setRepeat(calendar.getTime());
            } catch (Exception exception) {
                editContact.setRepeat(new Date());
                errors.add(PageDetailError.CONTACT_REPEATE_DATE_INCORRENT);
            }
        } else if ("delta".equals(repeatType)) {

        }
    }
    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.setAttribute("contact", editContact);
        request.getRequestDispatcher("/security/contactedit.jsp").forward(request, response);
    } else {
        EntityManager.execute(new EntityTransaction() {

            public Object execute(javax.persistence.EntityManager manager) {
                final EntityContactHistory history = new EntityContactHistory();
                history.repeat = contact.getRepeat();
                history.description = contact.getDescription();
                history.id.contact = contact;
                history.status = contact.getStatus();
                history.user = user;
                contact.getHistorys().add(history);
                contact.setStatus(editContact.getStatus());
                contact.setRepeat(editContact.getRepeat());
                contact.setDescription(editContact.getDescription());
                manager.persist(contact);
                return null;
            }

        });
        response.sendRedirect("/security/detail.jsp?firmId=" + contact.getPipol().getFirm().getId());
    }
%>