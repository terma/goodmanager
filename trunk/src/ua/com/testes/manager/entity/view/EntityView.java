package ua.com.testes.manager.entity.view;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "views")
public final class EntityView
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_view")

    @SequenceGenerator(name = "generator_view", sequenceName = "generator_view", allocationSize = 1)

    @Column(name = "view_id")
    public Integer id;


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(mappedBy = "id.view", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntityViewUser> users = new ArrayList();


    @Embedded
    public EntityViewSort sort = new EntityViewSort();


    @Embedded
    public EntityViewHistory history = new EntityViewHistory();


    @Embedded
    public EntityViewMail mail = new EntityViewMail();


    @Embedded
    public EntityViewDelete delete = new EntityViewDelete();


    @Column(name = "view_locale")
    public String locale;


    @Column(name = "view_byme", nullable = false)
    public boolean byMe = false;


    @Column(name = "view_byme_total", nullable = false)
    public boolean byMeTotal = false;


    @Column(name = "view_byme_repeat", nullable = false)
    public boolean byMeRepeat = false;


    @Column(name = "view_byme_old", nullable = false)
    public boolean byMeOld = true;


    @Column(name = "view_rate_show", nullable = false)
    public boolean showRate = true;


    @Column(nullable = false, name = "view_flate_head")
    public boolean flateHead = true;


    @Column(nullable = false, name = "view_show_telephon")
    public boolean showTelephon = true;


    @Column(nullable = false, name = "view_show_fax")
    public boolean showFax = true;


    @Column(nullable = false, name = "view_show_web")
    public boolean showWeb = true;


    @Column(nullable = false, name = "view_show_owner")
    public boolean showOwner = true;


    @Column(nullable = false, name = "view_show_last_contact")
    public boolean showLastContact = true;


    @Column(nullable = false, name = "view_show_address")
    public boolean showAddress = true;


    @Column(nullable = false, name = "view_show_email")
    public boolean showEmail = true;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.view.EntityView
 * JD-Core Version:    0.6.0
 */