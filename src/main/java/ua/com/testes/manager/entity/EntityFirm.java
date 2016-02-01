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
public final class EntityFirm implements Serializable {

    @Column(nullable = false)
    private String name = "";

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "GENERATOR_FIRM")
    @SequenceGenerator(name = "GENERATOR_FIRM", sequenceName = "GENERATOR_FIRM", allocationSize = 1)
    private Integer id;

    @Column(name = "descriptions", nullable = false)
    private String description = "";

    @Column(nullable = false)
    private String address = "";

    @Column(nullable = false)
    private String telephon = "";

    @Column(nullable = false)
    private String fax = "";

    @Column(name = "e_mail", nullable = false, length = 500)
    private String email = "";

    @Column(name = "firm_site", length = 500, nullable = false)
    private String site = "";

    @Column(name = "create_date", nullable = false)
    private Date create = new Date();

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_style")
    private EntityStyle publicStyle;

    @OneToMany(cascade = {javax.persistence.CascadeType.ALL})
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_parent")
    private List<EntityPipol> pipols = new ArrayList<EntityPipol>();

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
    private List<EntityFirmHistory> historys = new ArrayList<EntityFirmHistory>();

    public String getSite() {
        if (this.site.startsWith("http://")) {
            return this.site;
        }
        return "http://" + this.site;
    }

    public void setSite(String site) {

        this.site = site;
    }

    public EntityContact lastContact() {
        EntityContact lastContact = null;
        for (EntityPipol pipol : getPipols()) {
            if (pipol.getDelete() == null) {
                for (EntityContact contact : pipol.getContacts()) {
                    if (contact.delete == null) {
                        if (lastContact == null) {
                            lastContact = contact;
                        } else {
                            if (lastContact.create.getTime() < contact.create.getTime())
                                lastContact = contact;
                        }
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

    @Override
    public String toString() {
        return "EntityFirm {" + "id=" + id + ", name='" + name + '\'' + '}';
    }

}