package ua.com.testes.manager.entity;

import org.hibernate.ejb.Ejb3Configuration;
import ua.com.testes.manager.entity.content.EntityImage;
import ua.com.testes.manager.entity.content.EntityText;
import ua.com.testes.manager.entity.mail.EntityMail;
import ua.com.testes.manager.entity.mail.EntityPart;
import ua.com.testes.manager.entity.mail.EntityPartFile;
import ua.com.testes.manager.entity.mail.EntityPartText;
import ua.com.testes.manager.entity.mail.server.EntityServer;
import ua.com.testes.manager.entity.mail.server.rule.EntityServerRule;
import ua.com.testes.manager.entity.mail.server.rule.EntityServerRuleAll;
import ua.com.testes.manager.entity.product.EntityCategory;
import ua.com.testes.manager.entity.product.EntityCurrency;
import ua.com.testes.manager.entity.product.EntityProduct;
import ua.com.testes.manager.entity.product.EntityProductPrice;
import ua.com.testes.manager.entity.search.*;
import ua.com.testes.manager.entity.task.EntityTask;
import ua.com.testes.manager.entity.task.EntityTaskExecutor;
import ua.com.testes.manager.entity.tiding.EntityTiding;
import ua.com.testes.manager.entity.tiding.EntityTidingCategory;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.entity.view.EntityFirmSort;
import ua.com.testes.manager.entity.view.EntityView;
import ua.com.testes.manager.entity.view.EntityViewUser;

import javax.persistence.EntityManagerFactory;
import javax.persistence.FlushModeType;
import javax.persistence.Query;
import java.util.List;
import java.util.Properties;

public class EntityManager {
    /*  35 */   private static EntityManagerFactory factory = null;
    /*  36 */   private static final ThreadLocal<javax.persistence.EntityManager> managers = new ThreadLocal();

    public static void configuration(String login, String password, String driver, String url, String dialect) {
/*  40 */
        Properties properties = new Properties();
/*  41 */
        properties.setProperty("hibernate.dialect", dialect);

/*  43 */
        properties.setProperty("hibernate.connection.url", url);

/*  46 */
        properties.setProperty("hibernate.connection.driver_class", driver);
/*  47 */
        properties.setProperty("hibernate.connection.username", login);
/*  48 */
        properties.setProperty("hibernate.connection.password", password);
/*  49 */
        properties.setProperty("hibernate.connection.autocommit", "false");
/*  50 */
        properties.setProperty("hibernate.cache.use_second_level_cache", "true");
/*  51 */
        properties.setProperty("hibernate.cache.use_query_cache", "true");
/*  52 */
        properties.setProperty("hibernate.connection.release_mode", "on_close");
/*  53 */
        properties.setProperty("hibernate.generate_statistics", "false");
/*  54 */
        properties.setProperty("hibernate.bytecode.use_reflection_optimizer", "false");
/*  55 */
        properties.setProperty("hibernate.cglib.use_reflection_optimizer", "false");

/*  57 */
        properties.setProperty("hibernate.cache.provider_class", "org.hibernate.cache.EhCacheProvider");
/*  58 */
        properties.setProperty("hibernate.hbm2ddl.auto", "update");
/*  59 */
        Ejb3Configuration configuration = new Ejb3Configuration().addProperties(properties);
/*  60 */
        configuration.addPackage(EntityManager.class.getPackage().getName());
/*  61 */
        configuration.addAnnotatedClass(EntityImage.class);

/*  63 */
        configuration.addAnnotatedClass(EntityFirm.class);
/*  64 */
        configuration.addAnnotatedClass(EntitySection.class);
/*  65 */
        configuration.addAnnotatedClass(EntityRank.class);
/*  66 */
        configuration.addAnnotatedClass(EntityUser.class);
/*  67 */
        configuration.addAnnotatedClass(EntityPipol.class);
/*  68 */
        configuration.addAnnotatedClass(EntityStatus.class);
/*  69 */
        configuration.addAnnotatedClass(EntityContact.class);
/*  70 */
        configuration.addAnnotatedClass(EntityContactHistory.class);
/*  71 */
        configuration.addAnnotatedClass(EntityGroup.class);
/*  72 */
        configuration.addAnnotatedClass(EntityRule.class);
/*  73 */
        configuration.addAnnotatedClass(EntityStyle.class);
/*  74 */
        configuration.addAnnotatedClass(EntityFirmHistory.class);
/*  75 */
        configuration.addAnnotatedClass(EntityPipolHistory.class);
/*  76 */
        configuration.addAnnotatedClass(EntityContract.class);
/*  77 */
        configuration.addAnnotatedClass(EntityContractVersion.class);
/*  78 */
        configuration.addAnnotatedClass(EntityVersionFile.class);
/*  79 */
        configuration.addAnnotatedClass(EntityVersionResolution.class);
/*  80 */
        configuration.addAnnotatedClass(EntityTask.class);
/*  81 */
        configuration.addAnnotatedClass(EntityView.class);
/*  82 */
        configuration.addAnnotatedClass(EntityFirmSort.class);
/*  83 */
        configuration.addAnnotatedClass(EntityViewUser.class);
/*  84 */
        configuration.addAnnotatedClass(EntityText.class);
/*  85 */
        configuration.addAnnotatedClass(EntityProduct.class);
/*  86 */
        configuration.addAnnotatedClass(EntityProductPrice.class);
/*  87 */
        configuration.addAnnotatedClass(EntityCurrency.class);
/*  88 */
        configuration.addAnnotatedClass(EntityCategory.class);
/*  89 */
        configuration.addAnnotatedClass(EntityTidingCategory.class);
/*  90 */
        configuration.addAnnotatedClass(EntityTiding.class);
/*  91 */
        configuration.addAnnotatedClass(EntitySearch.class);
/*  92 */
        configuration.addAnnotatedClass(EntitySearchRule.class);
/*  93 */
        configuration.addAnnotatedClass(EntitySearchSource.class);

/*  95 */
        configuration.addAnnotatedClass(EntitySearchRuleFirmSection.class);
/*  96 */
        configuration.addAnnotatedClass(EntitySearchRuleFirmSectionItem.class);
/*  97 */
        configuration.addAnnotatedClass(EntitySearchRuleFirmUser.class);
/*  98 */
        configuration.addAnnotatedClass(EntitySearchRuleFirmUserItem.class);
/*  99 */
        configuration.addAnnotatedClass(EntitySearchRuleFirmName.class);

        configuration.addAnnotatedClass(EntitySearchSourceFirm.class);

        configuration.addAnnotatedClass(EntitySearchRuleFirmOther.class);

        configuration.addAnnotatedClass(EntitySearchRuleFirmCreate.class);

        configuration.addAnnotatedClass(EntitySearchRuleFirmDelete.class);

        configuration.addAnnotatedClass(EntitySearchRuleFirmComposite.class);

        configuration.addAnnotatedClass(EntitySearchRuleFirm.class);


        configuration.addAnnotatedClass(EntitySearchRulePipolComposite.class);

        configuration.addAnnotatedClass(EntitySearchSourcePipol.class);

        configuration.addAnnotatedClass(EntitySearchRulePipolFio.class);

        configuration.addAnnotatedClass(EntitySearchRulePipolOther.class);

        configuration.addAnnotatedClass(EntitySearchRulePipolDelete.class);

        configuration.addAnnotatedClass(EntitySearchRulePipolCreate.class);

        configuration.addAnnotatedClass(EntitySearchRulePipolUser.class);

        configuration.addAnnotatedClass(EntitySearchRulePipolUserItem.class);

        configuration.addAnnotatedClass(EntitySearchRulePipol.class);


        configuration.addAnnotatedClass(EntitySearchRuleContactComposite.class);

        configuration.addAnnotatedClass(EntitySearchSourceContact.class);

        configuration.addAnnotatedClass(EntitySearchRuleContactDescription.class);

        configuration.addAnnotatedClass(EntitySearchRuleContactCreate.class);

        configuration.addAnnotatedClass(EntitySearchRuleContactRepeat.class);

        configuration.addAnnotatedClass(EntitySearchRuleContactDelete.class);

        configuration.addAnnotatedClass(EntitySearchRuleContactUser.class);

        configuration.addAnnotatedClass(EntitySearchRuleContactUserItem.class);

        configuration.addAnnotatedClass(EntitySearchRuleContactStatus.class);

        configuration.addAnnotatedClass(EntitySearchRuleContactStatusItem.class);

        configuration.addAnnotatedClass(EntitySearchRuleContact.class);


        configuration.addAnnotatedClass(EntityMail.class);

        configuration.addAnnotatedClass(EntityPart.class);

        configuration.addAnnotatedClass(EntityPartFile.class);

        configuration.addAnnotatedClass(EntityPartText.class);

        configuration.addAnnotatedClass(EntityServer.class);

        configuration.addAnnotatedClass(EntityServerRule.class);

        configuration.addAnnotatedClass(EntityServerRuleAll.class);


        configuration.addAnnotatedClass(EntityTask.class);

        configuration.addAnnotatedClass(EntityTaskExecutor.class);

        configuration.buildMappings();
        try {

            factory = configuration.createEntityManagerFactory();
        } catch (Throwable exception) {

            System.err.println("Initial SessionFactory creation failed." + exception);

            throw new ExceptionInInitializerError(exception);
        }
    }

    public static <T> List<T> list(String hql, Object... parameters) {

        Query query = managers.get().createQuery(hql);

        for (int i = 0; i < parameters.length; i++) {

            query.setParameter("p" + i, parameters[i]);
        }

        return query.getResultList();
    }

    public static <T> List<T> listByName(String hqlQueryName, Object[] parameters) {

        Query query = managers.get().createNamedQuery(hqlQueryName);

        for (int i = 0; i < parameters.length; i++) {

            query.setParameter("p" + i, parameters[i]);
        }

        return query.getResultList();
    }

    public static <T> T find(Class<T> entityClass, Object id) {

        return ((javax.persistence.EntityManager) managers.get()).find(entityClass, id);
    }

    public static javax.persistence.EntityManager get() {

        return (javax.persistence.EntityManager) managers.get();
    }

    public static <T> T one(String hql, Object[] parameters) {

        Query query = ((javax.persistence.EntityManager) managers.get()).createQuery(hql);

        for (int i = 0; i < parameters.length; i++) {

            query.setParameter("p" + i, parameters[i]);
        }

        return (T) query.getSingleResult();
    }

    public static void execute(EntityTransaction transaction) {

        ((javax.persistence.EntityManager) managers.get()).setFlushMode(FlushModeType.COMMIT);


        ((javax.persistence.EntityManager) managers.get()).getTransaction().begin();
        try {

            transaction.execute((javax.persistence.EntityManager) managers.get());


            ((javax.persistence.EntityManager) managers.get()).getTransaction().commit();
        } catch (RuntimeException exception) {

            ((javax.persistence.EntityManager) managers.get()).getTransaction().rollback();

            throw exception;
        }
    }

    public static javax.persistence.EntityManager getNew() {

        return factory.createEntityManager();
    }

    public static void start() {

        managers.set(factory.createEntityManager());
    }

    public static void finish(boolean commit) {

        if (factory == null) {

            throw new NullPointerException("EntityManager factory not initialize use configuration()!");
        }

        if (managers.get() == null) {

            throw new NullPointerException("EntityManager not set filter!");
        }

        managers.get().close();

        managers.set(null);
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityManager
 * JD-Core Version:    0.6.0
 */