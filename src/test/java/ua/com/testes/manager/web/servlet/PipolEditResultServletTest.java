package ua.com.testes.manager.web.servlet;

import junit.framework.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Matchers;
import org.mockito.Mockito;
import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.EntityPipolHistory;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

import static org.mockito.Mockito.*;

public class PipolEditResultServletTest {

    private EntityManager entityManager;
    private HttpServletRequest request;
    private HttpServletResponse response;
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

        HttpSession session = mock(HttpSession.class);
        when(request.getSession(Mockito.anyBoolean())).thenReturn(session);
    }

    @Test
    public void failsIfNoUser() throws IOException, ServletException {
        when(entityManager.findNonStatic(any(EntityUser.class.getClass()), Matchers.any())).thenReturn(null);

        new PipolEditResultServlet().doPost(request, response);

        verify(response).sendError(403, "No user!");
    }

    @Test
    public void saveEditedAddOldAsVersion() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(eq(EntityUser.class), Matchers.any())).thenReturn(user);
        when(request.getParameter("pipolid")).thenReturn("1");
        when(request.getParameter("pipolfio")).thenReturn("name");
        when(request.getParameter("pipolemail")).thenReturn("email");
        when(request.getParameter("pipolrank")).thenReturn("rank");
        when(request.getParameter("pipoltelephon")).thenReturn("telephone");
        when(request.getParameter("pipoldescription")).thenReturn("des");

        EntityFirm firm = new EntityFirm();
        EntityPipol pipol = new EntityPipol();
        pipol.setFirm(firm);
        when(entityManager.findNonStatic(eq(EntityPipol.class), Matchers.any())).thenReturn(pipol);

        when(entityManager.listNonStatic(anyString(), any())).thenReturn(new ArrayList<Object>());

        new PipolEditResultServlet().doPost(request, response);

        Assert.assertEquals(1, pipol.getHistorys().size());
        EntityPipolHistory pipolHistory = pipol.getHistorys().get(0);
        Assert.assertEquals("", pipolHistory.fio);
        Assert.assertEquals("", pipolHistory.email);
        Assert.assertEquals("", pipolHistory.rang);
        Assert.assertEquals("", pipolHistory.telephon);
        Assert.assertEquals("", pipolHistory.description);

        Assert.assertEquals("name", pipol.getFio());
        Assert.assertEquals("email", pipol.getEmail());
        Assert.assertEquals("rank", pipol.getRang());
        Assert.assertEquals("telephone", pipol.getTelephon());
        Assert.assertEquals("des", pipol.getDescription());
        Assert.assertNull(pipol.getDelete());

        verify(javaxEntityManager).persist(pipol);
    }

}
