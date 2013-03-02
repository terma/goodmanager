<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageContractError" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final EntityContractVersion version = EntityManager.find(
            EntityContractVersion.class, Integer.parseInt(request.getParameter("versionId")));
    if (!user.getGroup().allowContractAccept(version.contract.user)) {
        response.sendRedirect("/security/contract/detail.jsp?contractId=" + version.contract.id);
        return;
    }
    final EntityVersionResolution resolution = new EntityVersionResolution();
    resolution.user = user;
    resolution.version = version;
    final Set<PageContractError> errors = new HashSet<PageContractError>();
    resolution.description = request.getParameter("resolutiondescription").trim();
    if (resolution.description == null) {
        resolution.description = "";
    }
    resolution.ok = request.getParameter("resolutionok") != null;
    if (!resolution.ok && resolution.description.trim().length() == 0) {
        errors.add(PageContractError.VERSION_RESOLUTION_TEXT_EMPTY);
    }

    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.setAttribute("resolution", resolution);
        request.getRequestDispatcher("/security/contract/versionaccept.jsp?versionId=" + version.id).forward(request, response);
    } else {
        EntityManager.execute(new EntityTransaction<EntityFirm>() {

            public EntityFirm execute(javax.persistence.EntityManager manager) {
                version.resolution = resolution;
                manager.persist(resolution);
                return null;
            }

        });
        response.sendRedirect("/security/contract/detail.jsp?contractId=" + version.contract.id);
    }
%>