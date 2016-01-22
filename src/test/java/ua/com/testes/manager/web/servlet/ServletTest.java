package ua.com.testes.manager.web.servlet;

import org.junit.Before;
import org.mockito.Mockito;
import ua.com.testes.manager.entity.EntityManager;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@SuppressWarnings("WeakerAccess")
public abstract class ServletTest {

    protected EntityManager entityManager;
    protected HttpServletRequest request;
    protected HttpServletResponse response;
    protected javax.persistence.EntityManager javaxEntityManager;
    protected RequestDispatcher dispatcher;

    @Before
    public void init() {
        entityManager = mock(EntityManager.class);
        EntityManager.setEntityManager(entityManager);

        javaxEntityManager = mock(javax.persistence.EntityManager.class);
        EntityManager.setTestTransaction(true);
        EntityManager.setTestJavaxEntityManager(javaxEntityManager);

        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);

        dispatcher = mock(RequestDispatcher.class);
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        HttpSession session = mock(HttpSession.class);
        when(request.getSession(Mockito.anyBoolean())).thenReturn(session);
    }


}
