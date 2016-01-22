package ua.com.testes.manager.web.servlet;

import org.junit.Test;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.web.page.PageLoginError;

import javax.servlet.ServletException;
import java.io.IOException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import static org.mockito.Mockito.*;

public class LoginResultServletTest extends ServletTest {

    @Test
    public void redirectToLoginPageIfNoLogin() throws IOException, ServletException {
        when(request.getParameter("password")).thenReturn("x");

        new LoginResultServlet().doPost(request, response);

        verify(response).sendRedirect("/login.jsp");
    }

    @Test
    public void redirectToLoginPageIfNoPassword() throws IOException, ServletException {
        when(request.getParameter("login")).thenReturn("x");

        new LoginResultServlet().doPost(request, response);

        verify(response).sendRedirect("/login.jsp");
    }

    @Test
    public void showLoginWithErrorIfWrongLoginPassword() throws IOException, ServletException {
        when(request.getParameter("login")).thenReturn("x");
        when(request.getParameter("password")).thenReturn("x");

        new LoginResultServlet().doPost(request, response);

        verify(request).setAttribute("error", PageLoginError.NOT_CURRENT);
        verify(request).getRequestDispatcher("/login.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void showLoginWithErrorIfUserDisabled() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        user.setPassword("x");
        user.setBlock(new Date(System.currentTimeMillis() + 10 * 1000));
        List users = Arrays.asList(user);
        when(entityManager.listNonStatic(anyString(), anyString())).thenReturn(users);

        when(request.getParameter("login")).thenReturn("x");
        when(request.getParameter("password")).thenReturn("x");

        new LoginResultServlet().doPost(request, response);

        verify(request).setAttribute("error", PageLoginError.BLOCK);
        verify(request).getRequestDispatcher("/login.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void login() throws IOException, ServletException {
        EntityUser user = new EntityUser();
        user.setPassword("x");
        List users = Arrays.asList(user);
        when(entityManager.listNonStatic(anyString(), anyString())).thenReturn(users);

        when(request.getParameter("originalUrl")).thenReturn("originalX");
        when(request.getParameter("login")).thenReturn("x");
        when(request.getParameter("password")).thenReturn("x");

        new LoginResultServlet().doPost(request, response);

        verify(response).sendRedirect("originalX");
    }

}
