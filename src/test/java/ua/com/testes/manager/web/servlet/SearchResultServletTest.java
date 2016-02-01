package ua.com.testes.manager.web.servlet;

import junit.framework.Assert;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import ua.com.testes.manager.entity.EntityContact;
import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.EntitySection;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.servlet.ServletException;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.*;

public class SearchResultServletTest extends ServletTest {

    @Test
    public void failsIfNoUser() throws IOException, ServletException {
        when(entityManager.findNonStatic(any(EntityUser.class.getClass()), any())).thenReturn(null);

        new SearchResultServlet().service(request, response);

        verify(response).sendError(403, "No user!");
    }

    @Test
    public void searchNothingIfNoData() throws IOException, ServletException {
        setupUser();

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());

        Assert.assertEquals(0, argument.getValue().size());
    }

    @Test
    public void searchForwardToRenderPage() throws IOException, ServletException {
        setupUser();

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());

        verify(request).getRequestDispatcher("/WEB-INF/jsp/searchresult.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void searchNothingIfNoSearchWord() throws IOException, ServletException {
        setupUser();

        setupSectionWithFirm();

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());

        Assert.assertEquals(0, argument.getValue().size());
    }

    @Test
    public void searchFirmByPartOfName() throws IOException, ServletException {
        setupUser();

        EntitySection section = new EntitySection();
        final List sections = Arrays.asList(section);

        EntityFirm firm1 = new EntityFirm();
        firm1.setName("ARA");
        section.getFirms().add(firm1);

        EntityFirm firm2 = new EntityFirm();
        firm2.setName("BAB");
        section.getFirms().add(firm2);

        when(entityManager.listNonStatic(anyString())).thenReturn(sections);

        when(request.getParameter("text")).thenReturn("R");
        when(request.getParameter("firm")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());

        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchFirmByIgnoreCase() throws IOException, ServletException {
        setupUser();

        EntitySection section = new EntitySection();
        final List sections = Arrays.asList(section);

        EntityFirm firm1 = new EntityFirm();
        firm1.setName("a");
        section.getFirms().add(firm1);

        EntityFirm firm2 = new EntityFirm();
        firm2.setName("A");
        section.getFirms().add(firm2);

        when(entityManager.listNonStatic(anyString())).thenReturn(sections);

        when(request.getParameter("text")).thenReturn("a");
        when(request.getParameter("firm")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());

        Assert.assertEquals(2, argument.getValue().size());
    }

    @Test
    public void searchFirmByAddressPatternIgnoreCase() throws IOException, ServletException {
        setupUser();
        setupSectionWithFirm().setAddress("pacific Ocean");
        when(request.getParameter("text")).thenReturn("ocEa");
        when(request.getParameter("firm")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchFirmByTelephonePatternIgnoreCase() throws IOException, ServletException {
        setupUser();
        setupSectionWithFirm().setTelephon("902-901-22-22");
        when(request.getParameter("text")).thenReturn("22");
        when(request.getParameter("firm")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchFirmByFaxPatternIgnoreCase() throws IOException, ServletException {
        setupUser();
        setupSectionWithFirm().setFax("902-901-22-22");
        when(request.getParameter("text")).thenReturn("22");
        when(request.getParameter("firm")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchFirmByEmailPatternIgnoreCase() throws IOException, ServletException {
        setupUser();
        setupSectionWithFirm().setEmail("superman@yandex.ru");
        when(request.getParameter("text")).thenReturn("yandex");
        when(request.getParameter("firm")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchFirmByDescriptionPatternIgnoreCase() throws IOException, ServletException {
        setupUser();
        setupSectionWithFirm().setDescription("description");
        when(request.getParameter("text")).thenReturn("tio");
        when(request.getParameter("firm")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchFirmBySitePatternIgnoreCase() throws IOException, ServletException {
        setupUser();
        setupSectionWithFirm().setSite("http://yo.com");
        when(request.getParameter("text")).thenReturn("yo.");
        when(request.getParameter("firm")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchFirmByIdPatternIgnoreCase() throws IOException, ServletException {
        setupUser();
        setupSectionWithFirm().setId(901);
        when(request.getParameter("text")).thenReturn("01");
        when(request.getParameter("firm")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchPeopleByFioPatternIgnoreCase() throws IOException, ServletException {
        setupUser();
        setupPeopleWithFirmAndSection().setFio("FIO");
        when(request.getParameter("text")).thenReturn("i");
        when(request.getParameter("pipol")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchPeopleByDescriptionPatternIgnoreCase() throws IOException, ServletException {
        setupUser();
        setupPeopleWithFirmAndSection().setDescription("I'm Here");
        when(request.getParameter("text")).thenReturn("her");
        when(request.getParameter("pipol")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchPeopleByTelephonePatternIgnoreCase() throws IOException, ServletException {
        setupUser();
        setupPeopleWithFirmAndSection().setTelephon("201-111-22-33");
        when(request.getParameter("text")).thenReturn("111");
        when(request.getParameter("pipol")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchPeopleByIdPattern() throws IOException, ServletException {
        setupUser();
        setupPeopleWithFirmAndSection().setId(823432);
        when(request.getParameter("text")).thenReturn("34");
        when(request.getParameter("pipol")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchContactByDescription() throws IOException, ServletException {
        setupUser();
        setupContactWithPeopleAndFirmAndSection().description = "ContAct DeScRiPtiOn";
        when(request.getParameter("text")).thenReturn("eScr");
        when(request.getParameter("contact")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
    }

    @Test
    public void searchResultShouldBeSortedByType() throws IOException, ServletException {
        setupUser();

        EntitySection section = new EntitySection();
        final List sections = Arrays.asList(section);
        when(entityManager.listNonStatic(anyString())).thenReturn(sections);

        EntityFirm firm = new EntityFirm();
        section.getFirms().add(firm);
        firm.setName("1");

        EntityPipol pipol = new EntityPipol();
        firm.getPipols().add(pipol);
        pipol.setFio("x");

        EntityContact contact = new EntityContact();
        pipol.getContacts().add(contact);
        contact.description = "x";

        EntityFirm firm2 = new EntityFirm();
        section.getFirms().add(firm2);
        firm2.setName("x");

        when(request.getParameter("text")).thenReturn("x");
        when(request.getParameter("firm")).thenReturn("b");
        when(request.getParameter("pipol")).thenReturn("b");
        when(request.getParameter("contact")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(3, argument.getValue().size());
        Assert.assertEquals(firm2, argument.getValue().get(0));
        Assert.assertEquals(pipol, argument.getValue().get(1));
        Assert.assertEquals(contact, argument.getValue().get(2));
    }

    @Test
    public void searchResultShouldBeSortedByNameWhenAllFirm() throws IOException, ServletException {
        setupUser();

        EntitySection section = new EntitySection();
        final List sections = Arrays.asList(section);
        when(entityManager.listNonStatic(anyString())).thenReturn(sections);

        EntityFirm firm1 = new EntityFirm();
        section.getFirms().add(firm1);
        firm1.setName("x2");

        EntityFirm firm2 = new EntityFirm();
        section.getFirms().add(firm2);
        firm2.setName("x1");

        when(request.getParameter("text")).thenReturn("x");
        when(request.getParameter("firm")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(2, argument.getValue().size());
        Assert.assertEquals(firm2, argument.getValue().get(0));
        Assert.assertEquals(firm1, argument.getValue().get(1));
    }

    @Test
    public void searchResultShouldBeSortedByNameWhenAllPipol() throws IOException, ServletException {
        setupUser();

        EntitySection section = new EntitySection();
        final List sections = Arrays.asList(section);
        when(entityManager.listNonStatic(anyString())).thenReturn(sections);

        EntityFirm firm = new EntityFirm();
        section.getFirms().add(firm);

        EntityPipol pipol1 = new EntityPipol();
        firm.getPipols().add(pipol1);
        pipol1.setFio("x2");

        EntityPipol pipol2 = new EntityPipol();
        firm.getPipols().add(pipol2);
        pipol2.setFio("x1");

        when(request.getParameter("text")).thenReturn("x");
        when(request.getParameter("pipol")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(2, argument.getValue().size());
        Assert.assertEquals(pipol2, argument.getValue().get(0));
        Assert.assertEquals(pipol1, argument.getValue().get(1));
    }

    @Test
    public void searchOnlyFirmIfSpecified() throws IOException, ServletException {
        setupUser();
        setupNamedContactNameFirm("des", "des", "des");

        when(request.getParameter("text")).thenReturn("des");
        when(request.getParameter("firm")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
        Assert.assertEquals(EntityFirm.class, argument.getValue().get(0).getClass());
    }

    @Test
    public void searchOnlyPipolIfSpecified() throws IOException, ServletException {
        setupUser();
        setupNamedContactNameFirm("des", "des", "des");

        when(request.getParameter("text")).thenReturn("des");
        when(request.getParameter("pipol")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
        Assert.assertEquals(EntityPipol.class, argument.getValue().get(0).getClass());
    }

    @Test
    public void searchOnlyContactIfSpecified() throws IOException, ServletException {
        setupUser();
        setupNamedContactNameFirm("des", "des", "des");

        when(request.getParameter("text")).thenReturn("des");
        when(request.getParameter("contact")).thenReturn("b");

        new SearchResultServlet().service(request, response);

        final ArgumentCaptor<List> argument = ArgumentCaptor.forClass(List.class);
        verify(request).setAttribute(eq("result"), argument.capture());
        Assert.assertEquals(1, argument.getValue().size());
        Assert.assertEquals(EntityContact.class, argument.getValue().get(0).getClass());
    }

}
