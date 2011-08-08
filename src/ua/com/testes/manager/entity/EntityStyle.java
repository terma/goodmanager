package ua.com.testes.manager.entity;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.util.Date;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "styles")
public final class EntityStyle {


    @Column(nullable = false, unique = true, length = 300)
    public String name;


    @Id

    @Column(name = "id", nullable = false)

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "GENERATOR_STYLE")

    @SequenceGenerator(name = "GENERATOR_STYLE", sequenceName = "GENERATOR_STYLE", allocationSize = 1)
    public Integer id;


    @Column(name = "descriptions", nullable = false)
    public String description;


    @Column(nullable = false)
    public boolean bold;


    @Column(name = "italy", nullable = false)
    public boolean italic;


    @Column(nullable = false)
    public boolean strikeout;


    @Column(nullable = false)
    public boolean underline;


    @Column(nullable = false)
    public int color;


    @Temporal(TemporalType.TIMESTAMP)

    @Column(name = "create_date", nullable = false, updatable = false)
    public Date create = new Date();


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @ManyToOne(fetch = FetchType.LAZY)

    @JoinColumn(name = "id_owner", nullable = false)
    public EntityUser owner;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityStyle
 * JD-Core Version:    0.6.0
 */