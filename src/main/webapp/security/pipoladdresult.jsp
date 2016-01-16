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
    final EntityPipol pipol = new EntityPipol();
    final EntityContact contact = new EntityContact();
    pipol.getContacts().add(contact);
    contact.pipol = pipol;
    final List<PageDetailError> errors = new ArrayList<PageDetailError>();
    int firmId = 0;
    try {
        firmId = Integer.parseInt(request.getParameter("firmId"));
    } catch (NumberFormatException exception) {
        errors.add(PageDetailError.FIRM_NOT_SELECT);
    }
    int statusId = 0;
    try {
        statusId = Integer.parseInt(request.getParameter("statusId"));
    } catch (NumberFormatException exception) {
        errors.add(PageDetailError.STATUS_NOT_SELECT);
    }
    pipol.setFio(request.getParameter("pipolfio"));
    pipol.setTelephon(request.getParameter("pipoltelephon"));
    pipol.setRang(request.getParameter("pipolrank"));
    pipol.setEmail(request.getParameter("pipolemail"));
    pipol.setDescription(request.getParameter("pipoldescription"));
    contact.description = request.getParameter("contactdescription");
    if (pipol.getFio() == null || pipol.getFio().trim().length() == 0) {
        errors.add(PageDetailError.PIPOL_FIO_EMPTY);
    } else if (contact.description == null || contact.description.trim().length() == 0) {
        errors.add(PageDetailError.CONTACT_DESCRIPTION_EMPTY);
    }

    // Если нужно повторный контакт
    if (request.getParameter("contactrepeatneed") != null) {
        String repeatType = request.getParameter("contactrepeattype");
        if ("date".equals(repeatType)) {
            GregorianCalendar calendar = new GregorianCalendar();
            try {
                int year = Integer.parseInt(request.getParameter("contactrepeatdateyear"));
                int month = Integer.parseInt(request.getParameter("contactrepeatdatemonth"));
                int day = Integer.parseInt(request.getParameter("contactrepeatdateday"));
                calendar.set(year, month, day, 0, 0, 0);
                // Устанавливаем дату контакта
                GregorianCalendar nowCalendar = new GregorianCalendar();
                nowCalendar.set(Calendar.HOUR_OF_DAY, 0);
                nowCalendar.set(Calendar.MINUTE, 0);
                nowCalendar.set(Calendar.SECOND, 0);
                nowCalendar.set(Calendar.MILLISECOND, 0);
                if (nowCalendar.getTime().after(calendar.getTime())) {
                    errors.add(PageDetailError.CONTACT_REPEATE_DATE_INCORRENT);
                }
                contact.repeat = calendar.getTime();
            } catch (Exception exception) {
                contact.repeat = new Date();
                errors.add(PageDetailError.CONTACT_REPEATE_DATE_INCORRENT);
            }
        } else if ("delta".equals(repeatType)) {

        }
    }

    if (errors.isEmpty()) {
        final List<EntityPipol> pipols = EntityManager.list(
                "select pipol from ua.com.testes.manager.entity.EntityPipol as pipol where firm.id = :p0", firmId);
        for (final EntityPipol tempPipol : pipols) {
            if (pipol.getFio().toLowerCase().trim().equals(tempPipol.getFio().toLowerCase().trim())) {
                errors.add(PageDetailError.PIPOL_FIO_NOT_UNIQUE);
                break;
            }
        }
    }

    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.setAttribute("pipol", pipol);
        request.getRequestDispatcher("/security/pipoladd.jsp?firmId=" + firmId).forward(request, response);
    } else {
        final int tempFirmId = firmId;
        final int tempStatusId = statusId;
        EntityManager.execute(new EntityTransaction() {

            public Object execute(final javax.persistence.EntityManager manager) {
                pipol.setFirm(manager.find(EntityFirm.class, tempFirmId));
                pipol.setUser(user);
                contact.user = user;
                contact.status = manager.find(EntityStatus.class, tempStatusId);
                manager.persist(pipol);
                pipol.getFirm().getPipols().add(pipol);
                return null;
            }

        });
        response.sendRedirect("/security/detail.jsp?firmId=" + firmId);
    }
%>