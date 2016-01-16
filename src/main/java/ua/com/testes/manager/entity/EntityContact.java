package ua.com.testes.manager.entity;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Entity(name = "contacts")
public final class EntityContact {

    @Column(name = "note", nullable = false)
    public String description = "";

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "GENERATOR_CONTACT")
    @SequenceGenerator(name = "GENERATOR_CONTACT", sequenceName = "GENERATOR_CONTACT")
    public Integer id;

    @Column(name = "create_date", nullable = false, updatable = false)
    public Date create = new Date();

    @Column(name = "repeat_date")
    public Date repeat;

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_style")
    public EntityStyle publicStyle;

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_owner", nullable = false)
    public EntityUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_parent", nullable = false)
    public EntityPipol pipol;

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_status", nullable = false)
    public EntityStatus status;

    @Column(name = "delete_date")
    public Date delete;

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToMany(mappedBy = "id.contact", cascade = {CascadeType.ALL})
    public List<EntityContactHistory> historys = new ArrayList<EntityContactHistory>();

}
