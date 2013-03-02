package ua.com.testes.manager.entity;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "firm_historys")
public final class EntityFirmHistory implements Serializable {

    @Column(name = "history_name", nullable = false, length = 150)
    public String name = "";

    @EmbeddedId
    public EntityFirmHistoryId id = new EntityFirmHistoryId();

    @Column(name = "history_descriptions", nullable = false, length = 1000)
    public String description = "";

    @Column(nullable = false, name = "history_address")
    public String address = "";

    @Column(nullable = false, name = "history_telephon")
    public String telephon = "";

    @Column(nullable = false, name = "history_fax")
    public String fax = "";

    @Column(name = "history_e_mail", nullable = false, length = 500)
    public String email = "";

    @Column(name = "history_site", length = 500, nullable = false)
    public String site = "";

    @ManyToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "history_user_id", nullable = false)
    public EntityUser user;

    public String getSite() {
        if (this.site.startsWith("http://")) {
            return this.site;
        }
        return "http://" + this.site;
    }

}