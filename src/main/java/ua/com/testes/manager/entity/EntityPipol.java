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
/*  18 */ private String fio = "";

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "GENERATOR_PIPOL")
    @SequenceGenerator(name = "GENERATOR_PIPOL", sequenceName = "GENERATOR_PIPOL", allocationSize = 1)
    private Integer id;

    @Column(name = "descriptions", nullable = false)
/*  26 */ private String description = "";

    @Column(nullable = false)
/*  29 */ private String telephon = "";

    @Column(nullable = false)
/*  32 */ private String rang = "";

    @Column(name = "e_mail", nullable = false)
/*  35 */ private String email = "";

    @Column(name = "create_date", nullable = false)
/*  38 */ private Date create = new Date();

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
/*  56 */ private List<EntityContact> contacts = new ArrayList();

    @Column(name = "delete_date")
    private Date delete;

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToMany(mappedBy = "id.pipol", cascade = {javax.persistence.CascadeType.ALL})
/*  64 */ private List<EntityPipolHistory> historys = new ArrayList();

    public String getFio() {
/*  69 */
        return this.fio;
    }

    public void setFio(String fio) {
/*  73 */
        this.fio = fio;
    }

    public Integer getId() {
/*  77 */
        return this.id;
    }

    public void setId(Integer id) {
/*  81 */
        this.id = id;
    }

    public String getDescription() {
/*  85 */
        return this.description;
    }

    public void setDescription(String description) {
/*  89 */
        this.description = description;
    }

    public String getTelephon() {
/*  93 */
        return this.telephon;
    }

    public void setTelephon(String telephon) {
/*  97 */
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