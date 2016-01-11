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
    final EntityPipol pipolEdit = new EntityPipol();
    final List<PageDetailError> errors = new ArrayList<PageDetailError>();
    pipolEdit.setId(Integer.parseInt(request.getParameter("pipolid")));
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
%>