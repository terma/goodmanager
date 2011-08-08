package ua.com.testes.manager.entity;

import javax.persistence.EntityManager;

public abstract interface EntityTransaction<T> {
    public abstract T execute(EntityManager paramEntityManager);
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityTransaction
 * JD-Core Version:    0.6.0
 */