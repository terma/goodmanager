package ua.com.testes.manager.entity;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "version_resolutions")
public final class EntityVersionResolution
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_resolution")

    @SequenceGenerator(name = "generator_resolution", sequenceName = "generator_resolution", allocationSize = 1)
    public Integer id;


    @Column(nullable = false, updatable = false, name = "resolution_create")
    public Date create = new Date();


    @Column(name = "resolution_ok", nullable = false)
    public boolean ok = false;


    @ManyToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "resolution_version_id", nullable = false)
    public EntityContractVersion version;


    @OneToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "resolution_user_id", nullable = false)
    public EntityUser user;


    @Lob

    @Column(name = "resolution_text")
    public String description = "";

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityVersionResolution
 * JD-Core Version:    0.6.0
 */