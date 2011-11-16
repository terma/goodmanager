package ua.com.testes.manager.entity.product;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Entity(name = "categorys")
public final class EntityCategory {

    @Column(name = "category_name", nullable = false, length = 500)
    public String name = "";

    @Id
    @Column(name = "category_id")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_category")
    @SequenceGenerator(name = "generator_category", sequenceName = "generator_category", allocationSize = 1)
    public Integer id;

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToMany(cascade = {javax.persistence.CascadeType.ALL}, mappedBy = "category")
    public List<EntityProduct> products = new ArrayList();

    @ManyToOne
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "category_parent_id")
    public EntityCategory parent;

    @OneToMany(cascade = {javax.persistence.CascadeType.ALL}, mappedBy = "parent")
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    public List<EntityCategory> childs = new ArrayList();

}