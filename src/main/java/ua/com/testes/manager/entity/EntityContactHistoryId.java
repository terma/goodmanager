package ua.com.testes.manager.entity;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;


@Embeddable
public final class EntityContactHistoryId
        implements Serializable {


    @ManyToOne(fetch = FetchType.LAZY)

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(nullable = false, name = "history_contact_id")
    public EntityContact contact;


    @Temporal(TemporalType.TIMESTAMP)

    @Column(nullable = false, name = "history_update")
    public Date update = new Date();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityContactHistoryId
 * JD-Core Version:    0.6.0
 */