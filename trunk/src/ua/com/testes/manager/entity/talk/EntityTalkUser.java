package ua.com.testes.manager.entity.talk;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "talk_users")
public final class EntityTalkUser
        implements Serializable {


    @EmbeddedId
    public EntityTalkUserId id = new EntityTalkUserId();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.talk.EntityTalkUser
 * JD-Core Version:    0.6.0
 */