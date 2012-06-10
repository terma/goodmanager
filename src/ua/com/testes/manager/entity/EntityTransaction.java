package ua.com.testes.manager.entity;

import javax.persistence.EntityManager;

public interface EntityTransaction<T> {

    T execute(EntityManager paramEntityManager);

}