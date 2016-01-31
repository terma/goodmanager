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
import java.util.ArrayList;
import java.util.List;

public class FirmEditResultServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        HttpSession session = request.getSession(true);

        final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
        if (user == null) {
            response.sendError(403, "No user!");
            return;
        }

        final EntityFirm firmEdit = new EntityFirm();
        final List<PageDetailError> errors = new ArrayList<PageDetailError>();

        final String firmId = request.getParameter("firmid");
        if (firmId == null) {
            response.sendRedirect("/security/main.jsp");
            return;
        }

        final int sectionId = Integer.parseInt(request.getParameter("sectionId"));

        firmEdit.setId(Integer.parseInt(firmId));
        final EntityFirm firm = EntityManager.find(EntityFirm.class, firmEdit.getId());
        firmEdit.setName(request.getParameter("firmname").trim());
        firmEdit.setSection(firm.getSection());
        firmEdit.setEmail(request.getParameter("firmemail").trim());
        firmEdit.setSite(request.getParameter("firmsite").trim());
        firmEdit.setAddress(request.getParameter("firmaddress").trim());
        firmEdit.setTelephon(request.getParameter("firmtelephon").trim());
        firmEdit.setFax(request.getParameter("firmfax").trim());
        firmEdit.setDescription(request.getParameter("firmdescription"));

        // validation
        if (firmEdit.getName() == null || firmEdit.getName().trim().length() == 0) {
            errors.add(PageDetailError.FIRM_NAME_EMPTY);
        }

        if (errors.isEmpty()) {
            final List<EntityFirm> firms = EntityManager.list(
                    "select firm from ua.com.testes.manager.entity.EntityFirm as firm");
            for (final EntityFirm tempFirm : firms) {
                if (!firmEdit.getId().equals(tempFirm.getId()) && firmEdit.getName().toLowerCase().trim().equals(tempFirm.getName().toLowerCase().trim())) {
                    errors.add(PageDetailError.FIRM_NAME_NOT_UNIQUE);
                    break;
                }
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("firm", firmEdit);
            request.getRequestDispatcher("/security/firmedit.jsp").forward(request, response);
        } else {
            EntityManager.execute(new EntityTransaction() {

                public Object execute(javax.persistence.EntityManager manager) {
                    final EntityFirmHistory history = new EntityFirmHistory();
                    history.address = firm.getAddress();
                    history.description = firm.getDescription();
                    history.id.firm = firm;
                    history.name = firm.getName();
                    history.site = firm.getSite();
                    history.email = firm.getEmail();
                    history.fax = firm.getFax();
                    history.user = user;
                    history.telephon = firm.getTelephon();
                    firm.getHistorys().add(history);

                    if (!firm.getSection().getId().equals(sectionId)) {
                        final EntitySection oldSection = firm.getSection();
                        oldSection.getFirms().remove(firm);

                        final EntitySection section = EntityManager.find(EntitySection.class, sectionId);
                        firm.setSection(section);
                        section.getFirms().add(firm);
                    }

                    firm.setAddress(firmEdit.getAddress());
                    firm.setSite(firmEdit.getSite());
                    firm.setEmail(firmEdit.getEmail());
                    firm.setTelephon(firmEdit.getTelephon());
                    firm.setFax(firmEdit.getFax());
                    firm.setName(firmEdit.getName());
                    firm.setDescription(firmEdit.getDescription());
                    manager.persist(firm);
                    return null;
                }

            });
            response.sendRedirect("/security/detail.jsp?firmId=" + firmEdit.getId());
        }
    }

}
