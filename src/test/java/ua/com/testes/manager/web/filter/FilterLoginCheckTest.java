package ua.com.testes.manager.web.filter;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Matchers;
import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.web.page.PageLoginError;

import javax.servlet.FilterChain;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;

import static org.mockito.Mockito.*;

public class FilterLoginCheckTest {

    private HttpServletRequest request;
    private HttpServletResponse response;
    private FilterChain chain;
    private HttpSession session;
    private RequestDispatcher dispatcher;

    private EntityManager entityManager;

    @Before
    public void init() {
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        dispatcher = mock(RequestDispatcher.class);

        chain = mock(FilterChain.class);
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        session = mock(HttpSession.class);
        when(request.getSession(true)).thenReturn(session);

        entityManager = mock(EntityManager.class);
        EntityManager.setEntityManager(entityManager);
    }

    @Test
    public void sendToLoginIfNoUserInSession() throws IOException, ServletException {
        when(request.getRequestURL()).thenReturn(new StringBuffer("/test"));

        new FilterLoginCheck().doFilter(request, response, null);

        verify(request).setAttribute("originalUrl", "/test");
        verify(request).getRequestDispatcher("/login.jsp");
        verify(dispatcher).forward(request, response);
        verifyZeroInteractions(chain);
    }

    @Test
    public void passIfUserPresentInSession() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(any(EntityUser.class.getClass()), Matchers.any())).thenReturn(user);

        when(session.getAttribute("userId")).thenReturn(1);

        new FilterLoginCheck().doFilter(request, response, chain);

        verify(chain).doFilter(request, response);
        verifyZeroInteractions(dispatcher);
    }

    @Test
    public void showBlockIfUserBlockedInFuture() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        user.setBlock(new Date(System.currentTimeMillis() + 60 * 1000));
        when(entityManager.findNonStatic(any(EntityUser.class.getClass()), Matchers.any())).thenReturn(user);

        when(session.getAttribute("userId")).thenReturn(1);

        new FilterLoginCheck().doFilter(request, response, chain);

        verify(request).setAttribute("error", PageLoginError.BLOCK);
        verify(request).getRequestDispatcher("/login.jsp");
        verify(dispatcher).forward(request, response);
        verifyZeroInteractions(chain);
    }

}
