package ua.com.testes.manager.web.servlet;

import org.apache.commons.lang3.StringUtils;
import ua.com.testes.manager.entity.*;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class SearchResultServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        final HttpSession session = request.getSession(true);

        final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
        if (user == null) {
            response.sendError(403, "No user!");
            return;
        }

        final String text = StringUtils.trimToEmpty(request.getParameter("text")).toLowerCase();
        final boolean searchFirm = request.getParameter("firm") != null;
        final boolean searchPipol = request.getParameter("pipol") != null;
        final boolean searchContact = request.getParameter("contact") != null;

        final List<Object> result = new ArrayList<Object>();

        if (text.length() > 0) {
            final List<EntitySection> sections = EntityManager.list("select section from sections as section");
            for (final EntitySection section : sections) {
                for (final EntityFirm firm : section.getFirms()) {
                    if (searchFirm) testFirm(text, result, firm);

                    for (EntityPipol people : firm.getPipols()) {
                        if (searchPipol) testPeople(text, result, people);

                        for (EntityContact contact : people.getContacts()) {
                            if (searchContact) testContact(text, result, contact);
                        }
                    }
                }
            }
        }

        Collections.sort(result, new SearchResultComparator());

        request.setAttribute("result", result);
        request.getRequestDispatcher("/WEB-INF/jsp/searchresult.jsp").forward(request, response);
    }

    private void testContact(String text, List<Object> result, EntityContact contact) {
        if (contact.description.toLowerCase().contains(text)) {
            result.add(contact);
        }
    }

    private void testPeople(String text, List<Object> result, EntityPipol pipol) {
        if (pipol.getId() != null && pipol.getId().toString().contains(text)) {
            result.add(pipol);
        } else if (pipol.getFio().toLowerCase().contains(text)) {
            result.add(pipol);
        } else if (pipol.getTelephon().toLowerCase().contains(text)) {
            result.add(pipol);
        } else if (pipol.getDescription().toLowerCase().contains(text)) {
            result.add(pipol);
        }
    }

    private void testFirm(String text, List<Object> result, EntityFirm firm) {
        if (firm.getId() != null && firm.getId().toString().contains(text)) {
            result.add(firm);
        } else if (firm.getName().toLowerCase().contains(text)) {
            result.add(firm);
        } else if (firm.getAddress() != null && firm.getAddress().toLowerCase().contains(text)) {
            result.add(firm);
        } else if (firm.getTelephon() != null && firm.getTelephon().toLowerCase().contains(text)) {
            result.add(firm);
        } else if (firm.getFax() != null && firm.getFax().toLowerCase().contains(text)) {
            result.add(firm);
        } else if (firm.getEmail() != null && firm.getEmail().toLowerCase().contains(text)) {
            result.add(firm);
        } else if (firm.getSite() != null && firm.getSite().toLowerCase().contains(text)) {
            result.add(firm);
        } else if (firm.getDescription() != null && firm.getDescription().toLowerCase().contains(text)) {
            result.add(firm);
        }
    }

    private static class SearchResultComparator implements Comparator<Object> {

        private static Integer compareByType(boolean o1IsClass, boolean o2IsClass) {
            if (o1IsClass && o2IsClass) return 0;
            else if (o1IsClass) return -1;
            else if (o2IsClass) return 1;
            return null;
        }

        private static Integer compareIfType(Object o1, Object o2, Class clazz) {
            boolean o1IsClass = o1 != null && o1.getClass() == clazz;
            boolean o2IsClass = o2 != null && o2.getClass() == clazz;
            return compareByType(o1IsClass, o2IsClass);
        }

        @Override
        public int compare(Object o1, Object o2) {
            Integer x = compareIfType(o1, o2, EntityFirm.class);
            if (x != null) {
                if (x == 0) return ((EntityFirm) o1).getName().compareToIgnoreCase(((EntityFirm) o2).getName());
                else return x;
            }

            x = compareIfType(o1, o2, EntityPipol.class);
            if (x != null) {
                if (x == 0) return ((EntityPipol) o1).getFio().compareToIgnoreCase(((EntityPipol) o2).getFio());
                else return x;
            }

            return 0;
        }

    }
}
