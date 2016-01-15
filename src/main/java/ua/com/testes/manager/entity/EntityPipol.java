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
@Entity(name = "pipols")
public final class EntityPipol
        implements Serializable {

    @Column(nullable = false, length = 250)
 private String fio = "";

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "GENERATOR_PIPOL")
    @SequenceGenerator(name = "GENERATOR_PIPOL", sequenceName = "GENERATOR_PIPOL", allocationSize = 1)
    private Integer id;

    @Column(name = "descriptions", nullable = false)
 private String description = "";

    @Column(nullable = false)
 private String telephon = "";

    @Column(nullable = false)
 private String rang = "";

    @Column(name = "e_mail", nullable = false)
 private String email = "";

    @Column(name = "create_date", nullable = false)
 private Date create = new Date();

    @ManyToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_parent")
    private EntityFirm firm;

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_style")
    private EntityStyle publicStyle;

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_owner")
    private EntityUser user;

    @OneToMany(cascade = {javax.persistence.CascadeType.ALL})
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_parent")
 private List<EntityContact> contacts = new ArrayList();

    @Column(name = "delete_date")
    private Date delete;

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToMany(mappedBy = "id.pipol", cascade = {javax.persistence.CascadeType.ALL})
 private List<EntityPipolHistory> historys = new ArrayList();

    public String getFio() {

        return this.fio;
    }

    public void setFio(String fio) {

        this.fio = fio;
    }

    public Integer getId() {

        return this.id;
    }

    public void setId(Integer id) {

        this.id = id;
    }

    public String getDescription() {

        return this.description;
    }

    public void setDescription(String description) {

        this.description = description;
    }

    public String getTelephon() {

        return this.telephon;
    }

    public void setTelephon(String telephon) {

        this.telephon = telephon;
    }

    public String getRang() {

        return this.rang;
    }

    public void setRang(String rang) {

        this.rang = rang;
    }

    public String getEmail() {

        return this.email;
    }

    public void setEmail(String email) {

        this.email = email;
    }

    public Date getCreate() {

        return this.create;
    }

    public void setCreate(Date create) {

        this.create = create;
    }

    public EntityFirm getFirm() {

        return this.firm;
    }

    public void setFirm(EntityFirm firm) {

        this.firm = firm;
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

    public List<EntityContact> getContacts() {

        return this.contacts;
    }

    public void setContacts(List<EntityContact> contacts) {

        this.contacts = contacts;
    }

    public Date getDelete() {

        return this.delete;
    }

    public void setDelete(Date delete) {

        this.delete = delete;
    }

    public List<EntityPipolHistory> getHistorys() {

        return this.historys;
    }

    public void setHistorys(List<EntityPipolHistory> historys) {

        this.historys = historys;
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityPipol
 * JD-Core Version:    0.6.0
 */