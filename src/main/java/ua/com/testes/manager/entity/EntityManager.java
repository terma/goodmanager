package ua.com.testes.manager.entity;

import javax.persistence.EntityManagerFactory;
import javax.persistence.FlushModeType;
import javax.persistence.Persistence;
import javax.persistence.Query;
import java.util.List;
import java.util.Properties;

public class EntityManager {

    private static final ThreadLocal<javax.persistence.EntityManager> managers = new ThreadLocal<javax.persistence.EntityManager>();
    private static EntityManagerFactory factory = null;

    private static EntityManager entityManager;

    public static EntityManager getEntityManager() {
        return entityManager;
    }

    public static void setEntityManager(EntityManager newEntityManager) {
        entityManager = newEntityManager;
    }

    @SuppressWarnings({"deprecation"})
    public static void configuration(String url) {
        setEntityManager(new EntityManager());

        final Properties properties = new Properties();
        properties.setProperty("hibernate.connection.url", url);

        factory = Persistence.createEntityManagerFactory("persistence-unit", properties);
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
        return entityManager.listByNameNonStatic(hqlQueryName, parameters);
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

    // todo remove all static methods on non static
    public <T> List<T> listByNameNonStatic(String hqlQueryName, Object[] parameters) {
        Query query = managers.get().createNamedQuery(hqlQueryName);
        for (int i = 0; i < parameters.length; i++) {
            query.setParameter("p" + i, parameters[i]);
        }
        return query.getResultList();
    }
}