package ua.com.testes.manager.entity.view;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "firm_sorts")

@Table(uniqueConstraints = {@javax.persistence.UniqueConstraint(columnNames = {"sort_view_id", "sort_order"})})
public final class EntityFirmSort
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_firm_sort")

    @SequenceGenerator(name = "generator_firm_sort", sequenceName = "generator_firm_sort", allocationSize = 1)

    @Column(name = "sort_id")
    public Integer id;


    @ManyToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(nullable = false, name = "sort_view_id")
    public EntityView view;


    @Column(nullable = false, name = "sort_order")
    public int order;


    @Enumerated(EnumType.ORDINAL)

    @Column(nullable = false, name = "sort_field")
    public Field field;


    @Column(nullable = false, name = "sort_inverse")
    public boolean inverse = false;


    public static enum Field {
        NAME, TELEPHON, FAX, EMAIL, ADDRESS, SITE, DESCRIPTION, ID;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.view.EntityFirmSort
 * JD-Core Version:    0.6.0
 */