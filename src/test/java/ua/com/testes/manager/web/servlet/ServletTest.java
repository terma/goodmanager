package ua.com.testes.manager.web.servlet;

import org.junit.Before;
import org.mockito.Mockito;
import ua.com.testes.manager.entity.*;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.List;

import static org.mockito.Matchers.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@SuppressWarnings("WeakerAccess")
public abstract class ServletTest {

    protected EntityManager entityManager;
    protected HttpServletRequest request;
    protected HttpServletResponse response;
    protected javax.persistence.EntityManager javaxEntityManager;
    protected RequestDispatcher dispatcher;

    protected void setupUser() {
        EntityUser user = new EntityUser();
        when(entityManager.findNonStatic(eq(EntityUser.class), any())).thenReturn(user);
    }

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

    protected EntityFirm setupSectionWithFirm() {
        EntitySection section = new EntitySection();
        final List sections = Arrays.asList(section);
        when(entityManager.listNonStatic(anyString())).thenReturn(sections);

        EntityFirm firm = new EntityFirm();
        section.getFirms().add(firm);

        return firm;
    }

    protected EntityPipol setupPeopleWithFirmAndSection() {
        EntityFirm firm = setupSectionWithFirm();

        EntityPipol pipol = new EntityPipol();
        firm.getPipols().add(pipol);
        return pipol;
    }

    protected EntityContact setupContactWithPeopleAndFirmAndSection() {
        EntityPipol pipol = setupPeopleWithFirmAndSection();

        EntityContact contact = new EntityContact();
        pipol.getContacts().add(contact);
        return contact;
    }

    public void setupNamedContactNameFirm(String firmName, String pipolFio, String contactDescription) {
        EntitySection section = new EntitySection();
        final List sections = Arrays.asList(section);
        when(entityManager.listNonStatic(anyString())).thenReturn(sections);

        EntityFirm firm = new EntityFirm();
        firm.setName(firmName);
        section.getFirms().add(firm);

        EntityPipol pipol = new EntityPipol();
        firm.getPipols().add(pipol);
        pipol.setFio(pipolFio);

        EntityContact contact = new EntityContact();
        pipol.getContacts().add(contact);
        contact.description = contactDescription;
    }

}
