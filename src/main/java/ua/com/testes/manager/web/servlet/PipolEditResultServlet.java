package ua.com.testes.manager.web.servlet;

import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.EntityPipolHistory;
import ua.com.testes.manager.entity.EntityTransaction;
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

public class PipolEditResultServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        HttpSession session = request.getSession(true);
        final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
        if (user == null) {
            response.sendError(403, "No user!");
            return;
        }

        final EntityPipol pipolEdit = new EntityPipol();
        final List<PageDetailError> errors = new ArrayList<PageDetailError>();

        final String pipolId = request.getParameter("pipolid");
        if (pipolId == null) {
            response.sendRedirect("/security/main.jsp");
            return;
        }

        pipolEdit.setId(Integer.parseInt(pipolId));
        final EntityPipol pipol = EntityManager.find(EntityPipol.class, pipolEdit.getId());
        pipolEdit.setFio(request.getParameter("pipolfio").trim());
        pipolEdit.setFirm(pipol.getFirm());
        pipolEdit.setEmail(request.getParameter("pipolemail").trim());
        pipolEdit.setRang(request.getParameter("pipolrank").trim());
        pipolEdit.setTelephon(request.getParameter("pipoltelephon").trim());
        pipolEdit.setDescription(request.getParameter("pipoldescription"));
        if (pipolEdit.getFio() == null || pipolEdit.getFio().trim().length() == 0) {
            errors.add(PageDetailError.PIPOL_FIO_EMPTY);
        }
        if (errors.isEmpty()) {
            final List<EntityPipol> pipols = EntityManager.list(
                    "select pipol from ua.com.testes.manager.entity.EntityPipol as pipol where firm.id = :p0", pipol.getFirm().getId());
            for (final EntityPipol tempPipol : pipols) {
                if (!pipolEdit.getId().equals(tempPipol.getId()) && pipolEdit.getFio().toLowerCase().trim().equals(tempPipol.getFio().toLowerCase().trim())) {
                    errors.add(PageDetailError.PIPOL_FIO_NOT_UNIQUE);
                    break;
                }
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("pipol", pipolEdit);
            request.getRequestDispatcher("/security/pipoledit.jsp").forward(request, response);
        } else {
            EntityManager.execute(new EntityTransaction() {

                public Object execute(javax.persistence.EntityManager manager) {
                    final EntityPipolHistory history = new EntityPipolHistory();
                    history.description = pipol.getDescription();
                    history.id.pipol = pipol;
                    history.fio = pipol.getFio();
                    history.rang = pipol.getRang();
                    history.email = pipol.getEmail();
                    history.user = user;
                    history.telephon = pipol.getTelephon();
                    pipol.getHistorys().add(history);
                    pipol.setFio(pipolEdit.getFio());
                    pipol.setEmail(pipolEdit.getEmail());
                    pipol.setTelephon(pipolEdit.getTelephon());
                    pipol.setRang(pipolEdit.getRang());
                    pipol.setDescription(pipolEdit.getDescription());
                    manager.persist(pipol);
                    return null;
                }

            });
            response.sendRedirect("/security/detail.jsp?firmId=" + pipol.getFirm().getId());
        }
    }
}