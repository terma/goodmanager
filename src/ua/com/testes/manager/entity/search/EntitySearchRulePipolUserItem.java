package ua.com.testes.manager.entity.search;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "rule_pipol_user_items")
public final class EntitySearchRulePipolUserItem
        implements Serializable {


    @EmbeddedId
    public EntitySearchRulePipolUserItemId id = new EntitySearchRulePipolUserItemId();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRulePipolUserItem
 * JD-Core Version:    0.6.0
 */