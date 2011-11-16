package ua.com.testes.manager.entity.view;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "view_users")
public class EntityViewUser
        implements Serializable {


    @EmbeddedId
    public EntityViewUserId id = new EntityViewUserId();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.view.EntityViewUser
 * JD-Core Version:    0.6.0
 */