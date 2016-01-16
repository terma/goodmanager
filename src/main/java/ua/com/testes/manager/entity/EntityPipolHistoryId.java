package ua.com.testes.manager.entity;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;


@Embeddable
public class EntityPipolHistoryId
        implements Serializable {


    @ManyToOne(fetch = FetchType.LAZY)

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "history_pipol_id", nullable = false)
    public EntityPipol pipol;


    @Column(name = "history_update", nullable = false)

    @Temporal(TemporalType.TIMESTAMP)
    public Date update = new Date();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityPipolHistoryId
 * JD-Core Version:    0.6.0
 */