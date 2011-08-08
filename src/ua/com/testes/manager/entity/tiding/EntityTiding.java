package ua.com.testes.manager.entity.tiding;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "tidings")
public final class EntityTiding
        implements Serializable {


    @Column(name = "tiding_name", nullable = false, length = 500)
    public String name = "";


    @Lob

    @Column(name = "tiding_description", nullable = false)
    public String description = "";


    @Temporal(TemporalType.TIMESTAMP)

    @Column(nullable = false, updatable = false, name = "tiding_create")
    public Date create = new Date();


    @Temporal(TemporalType.TIMESTAMP)

    @Column(nullable = false, updatable = false, name = "tiding_start")
    public Date start;


    @Temporal(TemporalType.TIMESTAMP)

    @Column(nullable = false, updatable = false, name = "tiding_finish")
    public Date finish;


    @Id

    @Column(name = "tiding_id")

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_tiding")

    @SequenceGenerator(name = "generator_tiding", sequenceName = "generator_tiding", allocationSize = 1)
    public Integer id;


    @ManyToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(nullable = false, name = "tiding_category_id")
    public EntityTidingCategory category;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.tiding.EntityTiding
 * JD-Core Version:    0.6.0
 */