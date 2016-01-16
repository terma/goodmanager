package ua.com.testes.manager.web.servlet;

import junit.framework.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Matchers;
import org.mockito.Mockito;
import ua.com.testes.manager.entity.*;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.web.page.PageDetailError;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;

import static org.mockito.Mockito.*;

public class FirmAddResultServletTest {

    private EntityManager entityManager;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private javax.persistence.EntityManager javaxEntityManager;
    private RequestDispatcher dispatcher;

    @Before
    public void init() {
        entityManager = mock(EntityManager.class);
        EntityManager.setEntityManager(entityManager);

        javaxEntityManager = mock(javax.persistence.EntityManager.class);
        EntityManager.setTestTransaction(true);
        EntityManager.setTestJavaxEntityManager(javaxEntityManager);

        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);

        HttpSession session = mock(HttpSession.class);
        when(request.getSession(Mockito.anyBoolean())).thenReturn(session);

        dispatcher = mock(RequestDispatcher.class);
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);
    }

    @Test
    public void failsIfNoUser() throws IOException, ServletException {
        when(entityManager.findNonStatic(any(EntityUser.class.getClass()), Matchers.any())).thenReturn(null);

        new FirmAddResultServlet().doPost(request, response);

        verify(response).sendError(403, "No user!");
    }

    @Test
    public void saveNewFirmPipolContact() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(eq(EntityUser.class), Matchers.any())).thenReturn(user);
        when(request.getParameter("firmname")).thenReturn("name");
        when(request.getParameter("firmemail")).thenReturn("email");
        when(request.getParameter("firmsite")).thenReturn("site");
        when(request.getParameter("firmaddress")).thenReturn("address");
        when(request.getParameter("firmtelephon")).thenReturn("telephone");
        when(request.getParameter("firmfax")).thenReturn("fax");
        when(request.getParameter("firmdescription")).thenReturn("des");
        when(request.getParameter("pipolfio")).thenReturn("fio");
        when(request.getParameter("pipoltelephon")).thenReturn("ptelephone");
        when(request.getParameter("pipolrank")).thenReturn("rank");
        when(request.getParameter("pipolemail")).thenReturn("pemail");
        when(request.getParameter("pipoldescription")).thenReturn("pdes");
        when(request.getParameter("contactdescription")).thenReturn("cdes");

        EntitySection section = new EntitySection();
        when(entityManager.findNonStatic(eq(EntitySection.class), Matchers.any())).thenReturn(section);
        when(request.getParameter("sectionId")).thenReturn("1");

        EntityStatus status = new EntityStatus();
        when(entityManager.findNonStatic(eq(EntityStatus.class), Matchers.any())).thenReturn(status);
        when(request.getParameter("statusId")).thenReturn("0");

        when(entityManager.listNonStatic(anyString(), any())).thenReturn(new ArrayList<Object>());

        new FirmAddResultServlet().doPost(request, response);

        Assert.assertEquals(1, section.getFirms().size());
        EntityFirm firm = section.getFirms().get(0);
        Assert.assertEquals(0, firm.getHistorys().size());
        Assert.assertEquals("name", firm.getName());
        Assert.assertEquals("email", firm.getEmail());
        Assert.assertEquals("http://site", firm.getSite());
        Assert.assertEquals("address", firm.getAddress());
        Assert.assertEquals("telephone", firm.getTelephon());
        Assert.assertEquals("fax", firm.getFax());
        Assert.assertEquals("des", firm.getDescription());
        Assert.assertNull(firm.getDelete());

        Assert.assertEquals(1, firm.getPipols().size());
        EntityPipol pipol = firm.getPipols().get(0);
        Assert.assertEquals("fio", pipol.getFio());
        Assert.assertEquals("pemail", pipol.getEmail());
        Assert.assertEquals("rank", pipol.getRang());
        Assert.assertEquals("ptelephone", pipol.getTelephon());
        Assert.assertEquals("pdes", pipol.getDescription());

        Assert.assertEquals(1, pipol.getContacts().size());
        EntityContact contact = pipol.getContacts().get(0);
        Assert.assertNull(contact.delete);
        Assert.assertEquals("cdes", contact.description);

        verify(javaxEntityManager).persist(firm);
    }

    @Test
    public void showErrorIfEmptyContactDescription() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(eq(EntityUser.class), Matchers.any())).thenReturn(user);
        when(request.getParameter("firmname")).thenReturn("name");
        when(request.getParameter("firmemail")).thenReturn("email");
        when(request.getParameter("firmsite")).thenReturn("site");
        when(request.getParameter("firmaddress")).thenReturn("address");
        when(request.getParameter("firmtelephon")).thenReturn("telephone");
        when(request.getParameter("firmfax")).thenReturn("fax");
        when(request.getParameter("firmdescription")).thenReturn("des");
        when(request.getParameter("pipolfio")).thenReturn("fio");
        when(request.getParameter("pipoltelephon")).thenReturn("ptelephone");
        when(request.getParameter("pipolrank")).thenReturn("rank");
        when(request.getParameter("pipolemail")).thenReturn("pemail");
        when(request.getParameter("pipoldescription")).thenReturn("pdes");
        when(request.getParameter("contactdescription")).thenReturn("");

        EntitySection section = new EntitySection();
        when(entityManager.findNonStatic(eq(EntitySection.class), Matchers.any())).thenReturn(section);
        when(request.getParameter("sectionId")).thenReturn("1");

        EntityStatus status = new EntityStatus();
        when(entityManager.findNonStatic(eq(EntityStatus.class), Matchers.any())).thenReturn(status);
        when(request.getParameter("statusId")).thenReturn("0");

        when(entityManager.listNonStatic(anyString(), any())).thenReturn(new ArrayList<Object>());

        new FirmAddResultServlet().doPost(request, response);

        verify(request).setAttribute(eq("firm"), Matchers.any());
        verify(request).setAttribute("errors", Collections.singletonList(PageDetailError.CONTACT_DESCRIPTION_EMPTY));
        verify(request).getRequestDispatcher("/security/firmadd.jsp?sectionId=1");
        verify(dispatcher).forward(request, response);
        verifyZeroInteractions(javaxEntityManager);
    }

    @Test
    public void showErrorIfEmptyPipolFio() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(eq(EntityUser.class), Matchers.any())).thenReturn(user);
        when(request.getParameter("firmname")).thenReturn("name");
        when(request.getParameter("firmemail")).thenReturn("email");
        when(request.getParameter("firmsite")).thenReturn("site");
        when(request.getParameter("firmaddress")).thenReturn("address");
        when(request.getParameter("firmtelephon")).thenReturn("telephone");
        when(request.getParameter("firmfax")).thenReturn("fax");
        when(request.getParameter("firmdescription")).thenReturn("des");
        when(request.getParameter("pipolfio")).thenReturn("");
        when(request.getParameter("pipoltelephon")).thenReturn("ptelephone");
        when(request.getParameter("pipolrank")).thenReturn("rank");
        when(request.getParameter("pipolemail")).thenReturn("pemail");
        when(request.getParameter("pipoldescription")).thenReturn("pdes");
        when(request.getParameter("contactdescription")).thenReturn("");

        EntitySection section = new EntitySection();
        when(entityManager.findNonStatic(eq(EntitySection.class), Matchers.any())).thenReturn(section);
        when(request.getParameter("sectionId")).thenReturn("1");

        EntityStatus status = new EntityStatus();
        when(entityManager.findNonStatic(eq(EntityStatus.class), Matchers.any())).thenReturn(status);
        when(request.getParameter("statusId")).thenReturn("0");

        when(entityManager.listNonStatic(anyString(), any())).thenReturn(new ArrayList<Object>());

        new FirmAddResultServlet().doPost(request, response);

        verify(request).setAttribute(eq("firm"), Matchers.any());
        verify(request).setAttribute("errors", Collections.singletonList(PageDetailError.PIPOL_FIO_EMPTY));
        verify(request).getRequestDispatcher("/security/firmadd.jsp?sectionId=1");
        verify(dispatcher).forward(request, response);
        verifyZeroInteractions(javaxEntityManager);
    }

    @Test
    public void showErrorIfEmptyFirmName() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(eq(EntityUser.class), Matchers.any())).thenReturn(user);
        when(request.getParameter("firmname")).thenReturn("");
        when(request.getParameter("firmemail")).thenReturn("email");
        when(request.getParameter("firmsite")).thenReturn("site");
        when(request.getParameter("firmaddress")).thenReturn("address");
        when(request.getParameter("firmtelephon")).thenReturn("telephone");
        when(request.getParameter("firmfax")).thenReturn("fax");
        when(request.getParameter("firmdescription")).thenReturn("des");
        when(request.getParameter("pipolfio")).thenReturn("");
        when(request.getParameter("pipoltelephon")).thenReturn("ptelephone");
        when(request.getParameter("pipolrank")).thenReturn("rank");
        when(request.getParameter("pipolemail")).thenReturn("pemail");
        when(request.getParameter("pipoldescription")).thenReturn("pdes");
        when(request.getParameter("contactdescription")).thenReturn("");

        EntitySection section = new EntitySection();
        when(entityManager.findNonStatic(eq(EntitySection.class), Matchers.any())).thenReturn(section);
        when(request.getParameter("sectionId")).thenReturn("1");

        EntityStatus status = new EntityStatus();
        when(entityManager.findNonStatic(eq(EntityStatus.class), Matchers.any())).thenReturn(status);
        when(request.getParameter("statusId")).thenReturn("0");

        when(entityManager.listNonStatic(anyString(), any())).thenReturn(new ArrayList<Object>());

        new FirmAddResultServlet().doPost(request, response);

        verify(request).setAttribute(eq("firm"), Matchers.any());
        verify(request).setAttribute("errors", Collections.singletonList(PageDetailError.FIRM_NAME_EMPTY));
        verify(request).getRequestDispatcher("/security/firmadd.jsp?sectionId=1");
        verify(dispatcher).forward(request, response);
        verifyZeroInteractions(javaxEntityManager);
    }

    @Test
    public void ifNoFirmIdSpecifiedGotoMain() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(eq(EntityUser.class), Matchers.any())).thenReturn(user);

        new FirmAddResultServlet().doPost(request, response);

        verify(response).sendRedirect("/security/main.jsp");
        verifyZeroInteractions(javaxEntityManager);
    }

}
