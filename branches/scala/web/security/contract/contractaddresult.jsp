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
    final EntityContract contract = new EntityContract();
    contract.user = user;
    final EntityContractVersion version = new EntityContractVersion();
    version.user = user;
    version.contract = contract;
    contract.versions.add(version);
    final Set<PageContractError> errors = new HashSet<PageContractError>();
    contract.name = request.getParameter("contractname").trim();
    contract.description = request.getParameter("contractdescription").trim();
    if (contract.name == null || contract.name.trim().length() == 0) {
        errors.add(PageContractError.CONTRACT_NAME_EMPTY);
    }
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
    }

    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.setAttribute("contract", contract);
        request.getRequestDispatcher("/security/contract/contractadd.jsp").forward(request, response);
    } else {
        EntityManager.execute(new EntityTransaction<EntityFirm>() {

            public EntityFirm execute(javax.persistence.EntityManager manager) {
                manager.persist(contract);
                return null;
            }

        });
        response.sendRedirect("/security/contract/main.jsp");
    }
%>