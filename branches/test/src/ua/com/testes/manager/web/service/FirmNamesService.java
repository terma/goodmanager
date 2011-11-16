package ua.com.testes.manager.web.service;


import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.EntitySection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@RemoteProxy
public class FirmNamesService {

    @RemoteMethod
    public String findLike(String firmName)
            throws IOException, ServletException {

        WebContext webContext = WebContextFactory.get();

        HttpSession httpSession = webContext.getHttpServletRequest().getSession(false);


        if ((httpSession == null) || (httpSession.getAttribute("userId") == null)) {

            return "";

        }


        String firmNameInLowerCase = firmName.toLowerCase();

        List<EntitySection> sections = EntityManager.listByName("sections.all", new Object[0]);

        List firms = new ArrayList();

        for (EntitySection section : sections) {

            for (EntityFirm firm : section.getFirms()) {

                if (firm.getName().toLowerCase().contains(firmNameInLowerCase)) {

                    firms.add(firm);

                }

            }

        }


        webContext.getHttpServletRequest().setAttribute("firms", firms);

        return webContext.forwardToString("/security/likefirms.jsp");

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.service.FirmNamesService
 * JD-Core Version:    0.6.0
 */