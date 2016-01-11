package ua.com.testes.manager.entity;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "contract_versions")
public final class EntityContractVersion
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_version")

    @SequenceGenerator(name = "generator_version", sequenceName = "generator_version", allocationSize = 1)

    @Column(name = "version_id")
    public Integer id;


    @ManyToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "version_contract_id", nullable = false)
    public EntityContract contract;


    @OneToOne(cascade = {javax.persistence.CascadeType.ALL})

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "version_resolution_id")
    public EntityVersionResolution resolution;


    @Temporal(TemporalType.TIMESTAMP)

    @Column(nullable = false, updatable = false, name = "version_create")
    public Date create = new Date();


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(mappedBy = "version", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntityVersionFile> files = new ArrayList();


    @OneToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "version_user_id", nullable = false)
    public EntityUser user;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityContractVersion
 * JD-Core Version:    0.6.0
 */