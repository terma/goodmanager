package ua.com.testes.manager.entity.search;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "searchs")
public final class EntitySearch
        implements Serializable {


    @Id

    @Column(name = "search_id")

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_search")

    @SequenceGenerator(name = "generator_search", sequenceName = "generator_search", allocationSize = 1)
    public Integer id;


    @Temporal(TemporalType.TIMESTAMP)

    @Column(name = "search_create", nullable = false)
    public Date create = new Date();


    @Temporal(TemporalType.TIMESTAMP)

    @Column(nullable = false, name = "search_use")
    public Date use = new Date();


    @Column(nullable = false, name = "search_park")
    public boolean park;


    @OneToOne(fetch = FetchType.LAZY)

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "search_user_id", nullable = false)
    public EntityUser user;


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(mappedBy = "search", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntitySearchSource> sources = new ArrayList();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearch
 * JD-Core Version:    0.6.0
 */