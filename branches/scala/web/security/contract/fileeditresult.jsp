<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.filter.upload.UploadFile" %>
<%@ page import="ua.com.testes.manager.web.filter.upload.UploadFiles" %>
<%@ page import="ua.com.testes.manager.web.filter.upload.UploadRequest" %>
<%@ page import="ua.com.testes.manager.web.page.PageContractError" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final EntityVersionFile previousFile = EntityManager.find(
            EntityVersionFile.class, Integer.parseInt(request.getParameter("fileid")));
    final EntityContractVersion version = new EntityContractVersion();
    version.user = user;
    version.contract = previousFile.version.contract;
    previousFile.version.contract.versions.add(version);
    final Set<PageContractError> errors = new HashSet<PageContractError>();
    final UploadFiles files = (UploadFiles) request.getAttribute(UploadRequest.UPLOAD_REQUEST_ATTRIBUTE);
    if (files == null || files.getCount() == 0) {
        errors.add(PageContractError.CONTRACT_FILE_EMTPY);
    } else {
        for (final UploadFile file : files.getCollection()) {
            final EntityVersionFile versionFile = new EntityVersionFile();
            versionFile.version = version;
            versionFile.name = file.getFileName();
            versionFile.path = file.getFilePathName();
            versionFile.data = file.toByteArray();
            version.files.add(versionFile);
        }
        for (final EntityVersionFile file : previousFile.version.files) {
            if (file.id != previousFile.id) {
                final EntityVersionFile newFile = new EntityVersionFile();
                newFile.data = file.data;
                newFile.name = file.name;
                newFile.path = file.path;
                newFile.version = version;
                version.files.add(newFile);
            }
        }
    }

    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.getRequestDispatcher("/security/contract/fileedit.jsp").forward(request, response);
    } else {
        EntityManager.execute(new EntityTransaction<EntityFirm>() {

            public EntityFirm execute(javax.persistence.EntityManager manager) {
                manager.persist(version);
                return null;
            }

        });
        response.sendRedirect("/security/contract/detail.jsp?contractId=" + previousFile.version.contract.id);
    }
%>