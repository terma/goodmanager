package ua.com.testes.manager.entity;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "contact_historys")
public final class EntityContactHistory
        implements Serializable {


    @Column(name = "history_description", nullable = false, length = 2000)
    public String description;


    @EmbeddedId
    public EntityContactHistoryId id = new EntityContactHistoryId();


    @Column(name = "history_repeat")

    @Temporal(TemporalType.TIMESTAMP)
    public Date repeat;


    @OneToOne(fetch = FetchType.LAZY)

    @JoinColumn(name = "id_status")
    public EntityStatus status;


    @OneToOne(fetch = FetchType.LAZY)

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "history_user_id", nullable = false)
    public EntityUser user;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityContactHistory
 * JD-Core Version:    0.6.0
 */