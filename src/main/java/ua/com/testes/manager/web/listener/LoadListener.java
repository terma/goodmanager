package ua.com.testes.manager.web.listener;


import net.sf.ehcache.CacheManager;
import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.util.activex1c.UtilActiveX1c;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import java.util.logging.Logger;


public class LoadListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getAnonymousLogger();

    @Override
    public void contextInitialized(final ServletContextEvent context) {
        final String configPath = System.getProperty("config");
        if (configPath == null) {
            throw new IllegalArgumentException("Please provide config system property!");
        }
        LOGGER.info(configPath);

        final Properties properties = new Properties();
        try {
            properties.load(new FileInputStream(configPath));
        } catch (final IOException exception) {
            throw new RuntimeException(exception);
        }

//        ServletContext servletContext = context.getServletContext();
        try {
            EntityManager.configuration(properties.getProperty("database"));
//            String mailUrl = servletContext.getInitParameter("mailurl");
//            if (mailUrl != null) {
//                MailFacade.setProviderFactory(new MailProviderFactoryGeneral(mailUrl));
//            }
//            LogicRate.setUse("true".equalsIgnoreCase(servletContext.getInitParameter("rateuse")));
//            LogicActiveX1c.setUse1c(servletContext.getInitParameter("1curl"));
        } catch (Exception exception) {
            System.err.println(exception.getMessage());
            exception.printStackTrace();
            throw new RuntimeException(exception);
        }
    }

    @Override
    public void contextDestroyed(final ServletContextEvent context) {
        UtilActiveX1c.shutdown();
        CacheManager.getInstance().shutdown();
    }

}