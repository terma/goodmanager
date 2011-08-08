package ua.com.testes.manager.entity;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "pipol_historys")
public final class EntityPipolHistory {


    @Column(nullable = false, name = "history_fio", length = 250)
    public String fio = "";


    @EmbeddedId
    public EntityPipolHistoryId id = new EntityPipolHistoryId();


    @Column(name = "history_descriptions", nullable = false, length = 1000)
    public String description = "";


    @Column(nullable = false, name = "history_telephon")
    public String telephon = "";


    @Column(nullable = false, name = "history_rank")
    public String rang = "";


    @Column(name = "history_e_mail", nullable = false)
    public String email = "";


    @OneToOne(fetch = FetchType.LAZY)

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "history_user_id", nullable = false)
    public EntityUser user;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityPipolHistory
 * JD-Core Version:    0.6.0
 */