<%@ page import="ua.com.testes.manager.entity.EntityFirm" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.content.EntityImage" %>
<%@ page import="ua.com.testes.manager.web.filter.upload.UploadFile" %>
<%@ page import="ua.com.testes.manager.web.filter.upload.UploadFiles" %>
<%@ page import="ua.com.testes.manager.web.filter.upload.UploadRequest" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final Integer userId = (Integer) session.getAttribute("userId");
    EntityImage image = null;
    if (userId != null) {
        final UploadFiles files = (UploadFiles) request.getAttribute(UploadRequest.UPLOAD_REQUEST_ATTRIBUTE);
        if (files != null && files.getCount() > 0) {
            for (final UploadFile file : files.getCollection()) {
                image = new EntityImage();
                image.extend = file.getFileExt();
                image.data = file.toByteArray();
                final EntityImage tempImage = image;
                EntityManager.execute(new EntityTransaction<EntityFirm>() {

                    public EntityFirm execute(javax.persistence.EntityManager manager) {
                        manager.persist(tempImage);
                        return null;
                    }

                });
            }
        }
    }
%>
<script type="text/javascript">

    window.parent.OnUploadCompleted(<%= image != null ? 0 : 203 %>, "/content/imageget?imageid=<%= image.id %>", "", "");

</script>