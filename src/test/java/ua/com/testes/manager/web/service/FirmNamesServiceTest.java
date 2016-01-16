package ua.com.testes.manager.web.service;

import junit.framework.Assert;
import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;
import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.EntitySection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.mockito.Mockito.*;

public class FirmNamesServiceTest {

    private WebContext webContext;
    private HttpServletRequest httpServletRequest;
    private EntityManager entityManager;

    @Before
    public void init() {
        entityManager = mock(EntityManager.class);
        EntityManager.setEntityManager(entityManager);

        WebContextFactory.WebContextBuilder webContextBuilder = mock(WebContextFactory.WebContextBuilder.class);
        WebContextFactory.setWebContextBuilder(webContextBuilder);

        webContext = mock(WebContext.class);
        when(webContextBuilder.get()).thenReturn(webContext);

        httpServletRequest = mock(HttpServletRequest.class);
        when(webContext.getHttpServletRequest()).thenReturn(httpServletRequest);
    }

    @Test
    public void ifNoSession() throws IOException, ServletException {
        Assert.assertEquals("", new FirmNamesService().findLike(""));
    }

    @Test
    public void ifNoLoginedUser() throws IOException, ServletException {
        HttpSession httpSession = mock(HttpSession.class);
        when(httpServletRequest.getSession(anyBoolean())).thenReturn(httpSession);

        Assert.assertEquals("", new FirmNamesService().findLike(""));
    }

    @Test
    public void nothingIfNoFirms() throws IOException, ServletException {
        HttpSession httpSession = mock(HttpSession.class);
        when(httpServletRequest.getSession(anyBoolean())).thenReturn(httpSession);

        when(httpSession.getAttribute("userId")).thenReturn("1");

        when(entityManager.listByNameNonStatic(Mockito.anyString(), Mockito.any(Object[].class))).thenReturn(new ArrayList<Object>());

        new FirmNamesService().findLike("");

        Mockito.verify(webContext).forwardToString("/security/likefirms.jsp");
        Mockito.verify(httpServletRequest).setAttribute("firms", new ArrayList());
    }

    @Test
    public void nothingIfCantMath() throws IOException, ServletException {
        HttpSession httpSession = mock(HttpSession.class);
        when(httpServletRequest.getSession(anyBoolean())).thenReturn(httpSession);

        when(httpSession.getAttribute("userId")).thenReturn("1");

        List sections = new ArrayList();
        EntitySection section = new EntitySection();
        sections.add(section);

        EntityFirm firm = new EntityFirm();
        firm.setName("XXX");
        section.getFirms().add(firm);

        when(entityManager.listByNameNonStatic(Mockito.anyString(), Mockito.any(Object[].class))).thenReturn(sections);

        new FirmNamesService().findLike("ddd");

        Mockito.verify(webContext).forwardToString("/security/likefirms.jsp");
        Mockito.verify(httpServletRequest).setAttribute("firms", new ArrayList());
    }

    @Test
    public void returnFirmIfContainsInName() throws IOException, ServletException {
        HttpSession httpSession = mock(HttpSession.class);
        when(httpServletRequest.getSession(anyBoolean())).thenReturn(httpSession);

        when(httpSession.getAttribute("userId")).thenReturn("1");

        List sections = new ArrayList();
        EntitySection section = new EntitySection();
        sections.add(section);

        EntityFirm firm = new EntityFirm();
        firm.setName("AdddB");
        section.getFirms().add(firm);

        when(entityManager.listByNameNonStatic(Mockito.anyString(), Mockito.any(Object[].class))).thenReturn(sections);

        new FirmNamesService().findLike("ddd");

        Mockito.verify(webContext).forwardToString("/security/likefirms.jsp");
        Mockito.verify(httpServletRequest).setAttribute("firms", Arrays.asList(firm));
    }

}
