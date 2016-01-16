package ua.com.testes.manager.entity.view;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.Embeddable;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import java.io.Serializable;

@Embeddable
public final class EntityViewUserId
        implements Serializable {

    @JoinColumn(name = "view_user_id", nullable = false)
    public int userId;

    @ManyToOne
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "view_id", nullable = false)
    public EntityView view;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.view.EntityViewUserId
 * JD-Core Version:    0.6.0
 */