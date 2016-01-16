package ua.com.testes.manager.web.servlet;

import junit.framework.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Matchers;
import org.mockito.Mockito;
import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.EntityFirmHistory;
import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

import static org.mockito.Mockito.*;

public class FirmEditResultServletTest {

    private EntityManager entityManager;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private javax.persistence.EntityManager javaxEntityManager;

    @Before
    public void init() {
        entityManager = mock(EntityManager.class);
        EntityManager.setEntityManager(entityManager);

        javaxEntityManager = mock(javax.persistence.EntityManager.class);
        EntityManager.setTestTransaction(true);
        EntityManager.setTestJavaxEntityManager(javaxEntityManager);

        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);

        session = mock(HttpSession.class);
        when(request.getSession(Mockito.anyBoolean())).thenReturn(session);
    }

    @Test
    public void failsIfNoUser() throws IOException, ServletException {
        when(entityManager.findNonStatic(any(EntityUser.class.getClass()), Matchers.any())).thenReturn(null);

        new FirmEditResultServlet().doPost(request, response);

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

        when(entityManager.listNonStatic(anyString(), any())).thenReturn(new ArrayList<Object>());

        new FirmEditResultServlet().doPost(request, response);

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
    public void ifNoFirmIdSpecifiedGotoMain() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(eq(EntityUser.class), Matchers.any())).thenReturn(user);

        new FirmEditResultServlet().doPost(request, response);

        verify(response).sendRedirect("/security/main.jsp");
        verifyZeroInteractions(javaxEntityManager);
    }

}
