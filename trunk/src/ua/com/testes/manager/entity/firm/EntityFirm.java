package ua.com.testes.manager.entity.firm;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.EntityContact;
import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.EntitySection;
import ua.com.testes.manager.entity.EntityStyle;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "firms")
public final class EntityFirm
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_firm")

    @SequenceGenerator(name = "generator_firm", sequenceName = "generator_firm", allocationSize = 1)
    public Integer id;


    @Column(name = "create_date", nullable = false)
    public Date create = new Date();


    @OneToOne(fetch = FetchType.LAZY)

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "id_style")
    public EntityStyle publicStyle;


    @OneToMany(cascade = {javax.persistence.CascadeType.ALL})

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "id_parent")
    public List<EntityPipol> pipols = new ArrayList();


    @ManyToOne(fetch = FetchType.LAZY)

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "id_owner", nullable = false)
    public EntityUser user;


    @ManyToOne(fetch = FetchType.LAZY)

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "id_parent")
    public EntitySection section;


    @Column(name = "delete_date")
    public Date delete;


    @Column(name = "descriptions", nullable = false, length = 5000)
    public String description = "";


    @Column(nullable = false, name = "fax", length = 500)
    public String fax = "";


    @Column(name = "edrpoy", length = 8)
    public String edrpoy;


    @Column(name = "e_mail", nullable = false, length = 500)
    public String email = "";


    @Column(name = "firm_site", length = 500, nullable = false)
    public String site = "";


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(mappedBy = "id.firm", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntityFirmHistory> historys = new ArrayList();


    public String getSite() {

        if (this.site.startsWith("http://")) {

            return this.site;

        }

        return "http://" + this.site;

    }


    public EntityContact lastContact() {

        EntityContact lastContact = null;

        for (EntityPipol pipol : this.pipols) {

            if (pipol.getDelete() == null) {

                for (EntityContact contact : pipol.getContacts()) {

                    if (contact.getDelete() == null) {

                        if (lastContact == null) {

                            lastContact = contact;

                        } else if (lastContact.getCreate().getTime() < contact.getCreate().getTime())
                            lastContact = contact;

                    }

                }

            }

        }

        return lastContact;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.firm.EntityFirm
 * JD-Core Version:    0.6.0
 */