package ua.com.testes.manager.entity.user;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Entity(name = "user_sessions")
public final class EntityUserSession
        implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_session")
    @SequenceGenerator(name = "generator_session", sequenceName = "generator_session", allocationSize = 1)
    @Column(name = "session_id")
    public Integer id;

    @Column(name = "session_start")
    @Temporal(TemporalType.TIMESTAMP)
    public Date start;

    @ManyToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "session_user_id", nullable = false)
    public EntityUser user;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.user.EntityUserSession
 * JD-Core Version:    0.6.0
 */