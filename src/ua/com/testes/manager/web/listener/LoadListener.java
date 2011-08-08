package ua.com.testes.manager.web.listener;


import net.sf.ehcache.CacheManager;
import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.logic.activeX1c.LogicActiveX1c;
import ua.com.testes.manager.logic.mail.MailFacade;
import ua.com.testes.manager.logic.mail.MailProviderFactoryGeneral;
import ua.com.testes.manager.logic.product.rate.LogicRate;
import ua.com.testes.manager.util.activex1c.UtilActiveX1c;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;


public class LoadListener
        implements ServletContextListener {

    public void contextInitialized(ServletContextEvent context) {

        ServletContext servletContext = context.getServletContext();

        try {

            EntityManager.configuration(servletContext.getInitParameter("databaselogin"), servletContext.getInitParameter("databasepassword"), servletContext.getInitParameter("databasedriver"), servletContext.getInitParameter("databaseurl"), servletContext.getInitParameter("databasedialect"));


            String mailUrl = servletContext.getInitParameter("mailurl");

            if (mailUrl != null) {

                MailFacade.setProviderFactory(new MailProviderFactoryGeneral(mailUrl));

            }

            LogicRate.setUse("true".equalsIgnoreCase(servletContext.getInitParameter("rateuse")));

            LogicActiveX1c.setUse1c(servletContext.getInitParameter("1curl"));

        } catch (Exception exception) {

            System.err.println(exception.getMessage());

            exception.printStackTrace();

            throw new RuntimeException(exception);

        }

    }


    public void contextDestroyed(ServletContextEvent context) {

        UtilActiveX1c.shutdown();

        CacheManager.getInstance().shutdown();

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.listener.LoadListener
 * JD-Core Version:    0.6.0
 */