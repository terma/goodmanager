package ua.com.testes.manager.entity.search;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "rule_contact_user_items")
public final class EntitySearchRuleContactUserItem
        implements Serializable {


    @EmbeddedId
    public EntitySearchRuleContactUserItemId id = new EntitySearchRuleContactUserItemId();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleContactUserItem
 * JD-Core Version:    0.6.0
 */