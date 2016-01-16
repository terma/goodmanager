package ua.com.testes.manager.web.servlet;

import ua.com.testes.manager.entity.*;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.web.page.PageDetailError;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

public class FirmAddResultServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        final HttpSession session = request.getSession(true);
        final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
        if (user == null) {
            response.sendError(403, "No user!");
            return;
        }

        final EntityFirm firm = new EntityFirm();
        final EntityPipol pipol = new EntityPipol();
        final EntityContact contact = new EntityContact();
        firm.getPipols().add(pipol);
        pipol.setFirm(firm);
        pipol.getContacts().add(contact);
        contact.pipol = pipol;
        final List<PageDetailError> errors = new ArrayList<PageDetailError>();

        final String sectionIdString = request.getParameter("sectionId");
        if (sectionIdString == null) {
            response.sendRedirect("/security/main.jsp");
            return;
        }

        int sectionId = 0;
        try {
            sectionId = Integer.parseInt(sectionIdString);
        } catch (NumberFormatException exception) {
            errors.add(PageDetailError.SECTION_NOT_SELECT);
        }
        int statusId = 0;
        try {
            statusId = Integer.parseInt(request.getParameter("statusId"));
        } catch (NumberFormatException exception) {
            errors.add(PageDetailError.STATUS_NOT_SELECT);
        }
        firm.setName(request.getParameter("firmname").trim());
        firm.setEmail(request.getParameter("firmemail").trim());
        firm.setSite(request.getParameter("firmsite").trim());
        firm.setAddress(request.getParameter("firmaddress").trim());
        firm.setTelephon(request.getParameter("firmtelephon").trim());
        firm.setFax(request.getParameter("firmfax").trim());
        firm.setDescription(request.getParameter("firmdescription"));
        pipol.setFio(request.getParameter("pipolfio").trim());
        pipol.setTelephon(request.getParameter("pipoltelephon").trim());
        pipol.setRang(request.getParameter("pipolrank").trim());
        pipol.setEmail(request.getParameter("pipolemail").trim());
        pipol.setDescription(request.getParameter("pipoldescription"));
        contact.description = request.getParameter("contactdescription");
        if (firm.getName() == null || firm.getName().trim().length() == 0) {
            errors.add(PageDetailError.FIRM_NAME_EMPTY);
        } else if (pipol.getFio() == null || pipol.getFio().trim().length() == 0) {
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
            final List<EntityFirm> firms = EntityManager.list(
                    "select firm from ua.com.testes.manager.entity.EntityFirm as firm");
            for (final EntityFirm tempFirm : firms) {
                if (firm.getName().toLowerCase().trim().equals(tempFirm.getName().toLowerCase().trim())) {
                    errors.add(PageDetailError.FIRM_NAME_NOT_UNIQUE);
                    break;
                }
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("firm", firm);
            request.getRequestDispatcher("/security/firmadd.jsp?sectionId=" + sectionId).forward(request, response);
        } else {
            final int tempSectionId = sectionId;
            final int tempStatusId = statusId;
            EntityManager.execute(new EntityTransaction<EntityFirm>() {

                public EntityFirm execute(javax.persistence.EntityManager manager) {
                    firm.setSection(EntityManager.find(EntitySection.class, tempSectionId));
                    firm.getSection().getFirms().add(firm);
                    firm.setUser(user);
                    pipol.setUser(user);
                    contact.user = user;
                    contact.status = manager.find(EntityStatus.class, tempStatusId);
                    manager.persist(firm);
                    return firm;
                }

            });
            response.sendRedirect("/security/detail.jsp?firmId=" + firm.getId());
        }
    }

}
