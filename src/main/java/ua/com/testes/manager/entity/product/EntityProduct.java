package ua.com.testes.manager.entity.product;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "products")
public final class EntityProduct {


    @Column(name = "product_name", nullable = false, length = 500)
    public String name = "";


    @Lob

    @Column(nullable = false, name = "product_description")
    public String description = "";


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(cascade = {javax.persistence.CascadeType.ALL}, mappedBy = "product")
    public List<EntityProductPrice> prices = new ArrayList();


    @Id

    @Column(name = "product_id")

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_product")

    @SequenceGenerator(name = "generator_product", sequenceName = "generator_product", allocationSize = 1)
    public Integer id;


    @ManyToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(nullable = false, name = "product_category_id")
    public EntityCategory category;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.product.EntityProduct
 * JD-Core Version:    0.6.0
 */