package ua.com.testes.manager.web.servlet;

import junit.framework.Assert;
import org.junit.Test;
import org.mockito.Matchers;
import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.EntityFirmHistory;
import ua.com.testes.manager.entity.EntitySection;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.servlet.ServletException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

import static org.mockito.Mockito.*;

public class FirmEditResultServletTest extends ServletTest {

    @Test
    public void failsIfNoUser() throws IOException, ServletException {
        when(entityManager.findNonStatic(any(EntityUser.class.getClass()), Matchers.any())).thenReturn(null);

        new FirmEditResultServlet().service(request, response);

        verify(response).sendError(403, "No user!");
    }

    @Test
    public void saveEditedAddOldAsVersion() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(eq(EntityUser.class), Matchers.any())).thenReturn(user);
        when(request.getParameter("firmid")).thenReturn("1");
        when(request.getParameter("firmname")).thenReturn("name");
        when(request.getParameter("firmemail")).thenReturn("email");
        when(request.getParameter("firmsite")).thenReturn("site");
        when(request.getParameter("firmaddress")).thenReturn("address");
        when(request.getParameter("firmtelephon")).thenReturn("telephone");
        when(request.getParameter("firmfax")).thenReturn("fax");
        when(request.getParameter("firmdescription")).thenReturn("des");

        EntityFirm firm = new EntityFirm();
        when(entityManager.findNonStatic(eq(EntityFirm.class), Matchers.any())).thenReturn(firm);

        EntitySection section = new EntitySection();
        section.setId(11);
        firm.setSection(section);
        when(request.getParameter("sectionId")).thenReturn(section.getId().toString());

        when(entityManager.listNonStatic(anyString(), any())).thenReturn(new ArrayList<Object>());

        new FirmEditResultServlet().service(request, response);

        Assert.assertEquals(1, firm.getHistorys().size());
        EntityFirmHistory firmHistory = firm.getHistorys().get(0);
        Assert.assertEquals("", firmHistory.name);
        Assert.assertEquals("", firmHistory.email);
        Assert.assertEquals("http://", firmHistory.site);
        Assert.assertEquals("", firmHistory.address);
        Assert.assertEquals("", firmHistory.telephon);
        Assert.assertEquals("", firmHistory.fax);
        Assert.assertEquals("", firmHistory.description);

        Assert.assertEquals("name", firm.getName());
        Assert.assertEquals("email", firm.getEmail());
        Assert.assertEquals("http://site", firm.getSite());
        Assert.assertEquals("address", firm.getAddress());
        Assert.assertEquals("telephone", firm.getTelephon());
        Assert.assertEquals("fax", firm.getFax());
        Assert.assertEquals("des", firm.getDescription());
        Assert.assertNull(firm.getDelete());

        verify(javaxEntityManager).persist(firm);
    }

    @Test
    public void saveNewSectionIfChanged() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(eq(EntityUser.class), Matchers.any())).thenReturn(user);
        when(request.getParameter("firmid")).thenReturn("1");
        when(request.getParameter("firmname")).thenReturn("name");
        when(request.getParameter("firmemail")).thenReturn("email");
        when(request.getParameter("firmsite")).thenReturn("site");
        when(request.getParameter("firmaddress")).thenReturn("address");
        when(request.getParameter("firmtelephon")).thenReturn("telephone");
        when(request.getParameter("firmfax")).thenReturn("fax");
        when(request.getParameter("firmdescription")).thenReturn("des");

        EntityFirm firm = new EntityFirm();
        when(entityManager.findNonStatic(eq(EntityFirm.class), Matchers.any())).thenReturn(firm);

        EntitySection newSection = new EntitySection();
        newSection.setId(90);

        EntitySection oldSection = new EntitySection();
        oldSection.setId(15);
        oldSection.getFirms().add(firm);
        firm.setSection(oldSection);

        when(request.getParameter("sectionId")).thenReturn(newSection.getId().toString());
        when(entityManager.findNonStatic(eq(EntitySection.class), Matchers.any())).thenReturn(newSection);


        when(entityManager.listNonStatic(anyString(), any())).thenReturn(new ArrayList<Object>());

        new FirmEditResultServlet().service(request, response);

        Assert.assertEquals(newSection, firm.getSection());
        verify(entityManager).findNonStatic(EntitySection.class, newSection.getId());
        Assert.assertEquals(0, oldSection.getFirms().size());
        Assert.assertEquals(Arrays.asList(firm), newSection.getFirms());

        verify(javaxEntityManager).persist(firm);
    }

    @Test
    public void ifNoFirmIdSpecifiedGotoMain() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(eq(EntityUser.class), Matchers.any())).thenReturn(user);

        new FirmEditResultServlet().service(request, response);

        verify(response).sendRedirect("/security/main.jsp");
        verifyZeroInteractions(javaxEntityManager);
    }

}
