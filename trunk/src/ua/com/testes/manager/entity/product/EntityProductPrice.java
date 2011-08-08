package ua.com.testes.manager.entity.product;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "product_prices")
public final class EntityProductPrice
        implements Serializable {


    @Temporal(TemporalType.TIMESTAMP)

    @Column(nullable = false, updatable = false, name = "price_create")
    public Date create = new Date();


    @Column(nullable = false, name = "price_value")
    public float value = 0.0F;


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_price")

    @SequenceGenerator(name = "generator_price", sequenceName = "generator_price", allocationSize = 1)
    public Integer id;


    @ManyToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(nullable = false, name = "price_product_id")
    public EntityProduct product;


    @OneToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(nullable = false, name = "price_currency_id")
    public EntityCurrency currency;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.product.EntityProductPrice
 * JD-Core Version:    0.6.0
 */