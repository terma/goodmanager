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
@Entity(name = "contacts")
public final class EntityContact implements Serializable {

    @Column(name = "note", nullable = false)
    private String description = "";

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "GENERATOR_CONTACT")
    @SequenceGenerator(name = "GENERATOR_CONTACT", sequenceName = "GENERATOR_CONTACT")
    private Integer id;

    @Column(name = "create_date", nullable = false)
    private Date create = new Date();

    @Column(name = "repeat_date")
    private Date repeat;

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_style")
    private EntityStyle publicStyle;

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_owner", nullable = false)
    private EntityUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_parent", nullable = false)
    private EntityPipol pipol;

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_status", nullable = false)
    private EntityStatus status;

    @Column(name = "delete_date")
    private Date delete;

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToMany(mappedBy = "id.contact", cascade = {javax.persistence.CascadeType.ALL})
    private List<EntityContactHistory> historys = new ArrayList();

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Date getCreate() {
        return this.create;
    }

    public void setCreate(Date create) {
        this.create = create;
    }

    public Date getRepeat() {
        return this.repeat;
    }

    public void setRepeat(Date repeat) {
        this.repeat = repeat;
    }

    public EntityStyle getPublicStyle() {
        return this.publicStyle;
    }

    public void setPublicStyle(EntityStyle publicStyle) {
        this.publicStyle = publicStyle;
    }

    public EntityUser getUser() {
        return this.user;
    }

    public void setUser(EntityUser user) {
        this.user = user;
    }

    public EntityPipol getPipol() {
        return this.pipol;
    }

    public void setPipol(EntityPipol pipol) {
        this.pipol = pipol;
    }

    public EntityStatus getStatus() {
        return this.status;
    }

    public void setStatus(EntityStatus status) {
        this.status = status;
    }

    public Date getDelete() {
        return this.delete;
    }

    public void setDelete(Date delete) {
        this.delete = delete;
    }

    public List<EntityContactHistory> getHistorys() {
        return this.historys;
    }

    public void setHistorys(List<EntityContactHistory> historys) {
        this.historys = historys;
    }

}
