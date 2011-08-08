package ua.com.testes.manager.entity.product;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "currencys")
public final class EntityCurrency
        implements Serializable {


    @Column(name = "currency_name", nullable = false, length = 500)
    public String name = "";


    @Column(name = "currency_label", nullable = false, unique = true, length = 3)
    public String label = "";


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_currentcy")

    @SequenceGenerator(name = "generator_currentcy", sequenceName = "generator_currentcy", allocationSize = 1)
    public Integer id;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.product.EntityCurrency
 * JD-Core Version:    0.6.0
 */