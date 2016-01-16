package ua.com.testes.manager.entity;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.io.Serializable;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Entity(name = "statuses")
public final class EntityStatus implements Serializable {

    @Column(name = "descriptions")
    public String description;
    public String name;

    @Id
    public Integer id;

    @Column(name = "status_order", nullable = false, unique = true)
    public int order;
}