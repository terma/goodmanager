package ua.com.testes.manager.entity.tiding;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "tiding_categorys")
public final class EntityTidingCategory
        implements Serializable {


    @Column(name = "category_name", nullable = false, length = 500)
    public String name = "";


    @Id

    @Column(name = "category_id")

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_tiding_category")

    @SequenceGenerator(name = "generator_tiding_category", sequenceName = "generator_tiding_category", allocationSize = 1)
    public Integer id;


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(cascade = {javax.persistence.CascadeType.ALL}, mappedBy = "category")
    public List<EntityTiding> tidings = new ArrayList();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.tiding.EntityTidingCategory
 * JD-Core Version:    0.6.0
 */