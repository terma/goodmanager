package ua.com.testes.manager.entity.firm;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity

@Table(name = "firms")
public final class EntityFirmOld
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_firm")

    @SequenceGenerator(name = "generator_firm", sequenceName = "generator_firm", allocationSize = 1)
    public Integer id;


    @Column(name = "descriptions", nullable = false, length = 5000)
    public String description = "";


    @Column(nullable = false, name = "fax", length = 500)
    public String fax = "";


    @Column(name = "edrpoy", length = 8)
    public String edrpoy;


    @Column(name = "e_mail", nullable = false, length = 500)
    public String email = "";


    @Column(name = "firm_site", length = 500, nullable = false)
    public String site = "";


    @Column(length = 400, nullable = false, name = "name")
    public String name = "";


    @Column(nullable = false, name = "address", length = 1000)
    public String address = "";


    @Column(nullable = false, name = "telephon", length = 1000)
    public String telephon = "";

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.firm.EntityFirmOld
 * JD-Core Version:    0.6.0
 */