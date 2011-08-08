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
@Entity(name = "FIRMS")
public final class EntityFirm
        implements Serializable {
    /*  18 */   private String name = "";

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "GENERATOR_FIRM")
    @SequenceGenerator(name = "GENERATOR_FIRM", sequenceName = "GENERATOR_FIRM", allocationSize = 1)
    private Integer id;

    @Column(name = "descriptions", nullable = false)
/*  25 */ private String description = "";

    @Column(nullable = false)
/*  28 */ private String address = "";

    @Column(nullable = false)
/*  31 */ private String telephon = "";

    @Column(nullable = false)
/*  34 */ private String fax = "";

    @Column(name = "e_mail", nullable = false, length = 500)
/*  37 */ private String email = "";

    @Column(name = "firm_site", length = 500, nullable = false)
/*  40 */ private String site = "";

    @Column(name = "create_date", nullable = false)
/*  43 */ private Date create = new Date();

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_style")
    private EntityStyle publicStyle;

    @OneToMany(cascade = {javax.persistence.CascadeType.ALL})
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_parent")
/*  51 */ private List<EntityPipol> pipols = new ArrayList();

    @ManyToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_owner", nullable = false)
    private EntityUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_parent")
    private EntitySection section;

    @Column(name = "delete_date")
    private Date delete;

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToMany(mappedBy = "id.firm", cascade = {javax.persistence.CascadeType.ALL})
/*  69 */ private List<EntityFirmHistory> historys = new ArrayList();

    public String getSite() {
/*  74 */
        if (this.site.startsWith("http://")) {
/*  75 */
            return this.site;
        }
/*  77 */
        return "http://" + this.site;
    }

    public EntityContact lastContact() {
/*  86 */
        EntityContact lastContact = null;
/*  87 */
        for (EntityPipol pipol : getPipols()) {
/*  88 */
            if (pipol.getDelete() == null) {
/*  89 */
                for (EntityContact contact : pipol.getContacts()) {
/*  90 */
                    if (contact.getDelete() == null) {
/*  91 */
                        if (lastContact == null) {
/*  92 */
                            lastContact = contact;
                        }
/*  94 */
                        else if (lastContact.getCreate().getTime() < contact.getCreate().getTime())
/*  95 */ lastContact = contact;
                    }
                }
            }
        }

        return lastContact;
    }

    public String getName() {

        return this.name;
    }

    public void setName(String name) {

        this.name = name;
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

    public String getAddress() {

        return this.address;
    }

    public void setAddress(String address) {

        this.address = address;
    }

    public String getTelephon() {

        return this.telephon;
    }

    public void setTelephon(String telephon) {

        this.telephon = telephon;
    }

    public String getFax() {

        return this.fax;
    }

    public void setFax(String fax) {

        this.fax = fax;
    }

    public String getEmail() {

        return this.email;
    }

    public void setEmail(String email) {

        this.email = email;
    }

    public void setSite(String site) {

        this.site = site;
    }

    public Date getCreate() {

        return this.create;
    }

    public void setCreate(Date create) {

        this.create = create;
    }

    public EntityStyle getPublicStyle() {

        return this.publicStyle;
    }

    public void setPublicStyle(EntityStyle publicStyle) {

        this.publicStyle = publicStyle;
    }

    public List<EntityPipol> getPipols() {

        return this.pipols;
    }

    public void setPipols(List<EntityPipol> pipols) {

        this.pipols = pipols;
    }

    public EntityUser getUser() {

        return this.user;
    }

    public void setUser(EntityUser user) {

        this.user = user;
    }

    public EntitySection getSection() {

        return this.section;
    }

    public void setSection(EntitySection section) {

        this.section = section;
    }

    public Date getDelete() {

        return this.delete;
    }

    public void setDelete(Date delete) {

        this.delete = delete;
    }

    public List<EntityFirmHistory> getHistorys() {

        return this.historys;
    }

    public void setHistorys(List<EntityFirmHistory> historys) {

        this.historys = historys;
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityFirm
 * JD-Core Version:    0.6.0
 */