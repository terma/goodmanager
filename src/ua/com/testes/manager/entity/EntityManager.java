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

    private static final ThreadLocal<javax.persistence.EntityManager> managers
            = new ThreadLocal<javax.persistence.EntityManager>();
    private static EntityManagerFactory factory = null;

    public static void configuration(String login, String password, String driver, String url, String dialect) {
        final Properties properties = new Properties();
        properties.setProperty("hibernate.dialect", dialect);
        properties.setProperty("hibernate.connection.url", url);
        properties.setProperty("hibernate.connection.driver_class", driver);
        properties.setProperty("hibernate.connection.username", login);
        properties.setProperty("hibernate.connection.password", password);
        properties.setProperty("hibernate.connection.autocommit", "false");
        properties.setProperty("hibernate.cache.use_second_level_cache", "true");
        properties.setProperty("hibernate.cache.use_query_cache", "true");
        properties.setProperty("hibernate.connection.release_mode", "on_close");
        properties.setProperty("hibernate.generate_statistics", "false");
        properties.setProperty("hibernate.bytecode.use_reflection_optimizer", "false");
        properties.setProperty("hibernate.cglib.use_reflection_optimizer", "false");
        properties.setProperty("hibernate.cache.provider_class", "org.hibernate.cache.EhCacheProvider");
        properties.setProperty("hibernate.hbm2ddl.auto", "update");

        final Ejb3Configuration configuration = new Ejb3Configuration().addProperties(properties);
        configuration.addPackage(EntityManager.class.getPackage().getName());
        configuration.addAnnotatedClass(EntityImage.class);
        configuration.addAnnotatedClass(EntityFirm.class);
        configuration.addAnnotatedClass(EntitySection.class);
        configuration.addAnnotatedClass(EntityRank.class);
        configuration.addAnnotatedClass(EntityUser.class);
        configuration.addAnnotatedClass(EntityPipol.class);
        configuration.addAnnotatedClass(EntityStatus.class);
        configuration.addAnnotatedClass(EntityContact.class);
        configuration.addAnnotatedClass(EntityContactHistory.class);
        configuration.addAnnotatedClass(EntityGroup.class);
        configuration.addAnnotatedClass(EntityRule.class);
        configuration.addAnnotatedClass(EntityStyle.class);
        configuration.addAnnotatedClass(EntityFirmHistory.class);
        configuration.addAnnotatedClass(EntityPipolHistory.class);
        configuration.addAnnotatedClass(EntityContract.class);
        configuration.addAnnotatedClass(EntityContractVersion.class);
        configuration.addAnnotatedClass(EntityVersionFile.class);
        configuration.addAnnotatedClass(EntityVersionResolution.class);
        configuration.addAnnotatedClass(EntityTask.class);
        configuration.addAnnotatedClass(EntityView.class);
        configuration.addAnnotatedClass(EntityFirmSort.class);
        configuration.addAnnotatedClass(EntityViewUser.class);
        configuration.addAnnotatedClass(EntityText.class);
        configuration.addAnnotatedClass(EntityProduct.class);
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
            //noinspection deprecation
            factory = configuration.createEntityManagerFactory();
        } catch (Throwable exception) {
            System.err.println("Initial SessionFactory creation failed." + exception);
            throw new ExceptionInInitializerError(exception);
        }
    }

    @SuppressWarnings({"unchecked"})
    public static <T> List<T> list(String hql, Object... parameters) {

        Query query = managers.get().createQuery(hql);

        for (int i = 0; i < parameters.length; i++) {

            query.setParameter("p" + i, parameters[i]);
        }

        return query.getResultList();
    }

    @SuppressWarnings({"unchecked"})
    public static <T> List<T> listByName(String hqlQueryName, Object[] parameters) {

        Query query = managers.get().createNamedQuery(hqlQueryName);

        for (int i = 0; i < parameters.length; i++) {

            query.setParameter("p" + i, parameters[i]);
        }

        return query.getResultList();
    }

    public static <T> T find(Class<T> entityClass, Object id) {
        return managers.get().find(entityClass, id);
    }

    public static javax.persistence.EntityManager get() {
        return managers.get();
    }

    @SuppressWarnings({"unchecked"})
    public static <T> T one(String hql, Object[] parameters) {

        Query query = managers.get().createQuery(hql);

        for (int i = 0; i < parameters.length; i++) {

            query.setParameter("p" + i, parameters[i]);
        }

        return (T) query.getSingleResult();
    }

    public static void execute(EntityTransaction transaction) {
        final javax.persistence.EntityManager entityManager = managers.get();
        entityManager.setFlushMode(FlushModeType.COMMIT);
        entityManager.getTransaction().begin();
        try {
            transaction.execute(entityManager);
            entityManager.getTransaction().commit();
        } catch (RuntimeException exception) {
            entityManager.getTransaction().rollback();
            throw exception;
        }
    }

    public static void start() {
        managers.set(factory.createEntityManager());
    }

    public static void finish() {
        if (factory == null) {
            throw new NullPointerException("EntityManager factory not initialize use configuration()!");
        }

        if (managers.get() == null) {
            throw new NullPointerException("EntityManager not set filter!");
        }

        managers.get().close();
        managers.remove();
    }
}