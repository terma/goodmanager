package ua.com.testes.manager.entity.search;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "rule_contact_status_items")
public final class EntitySearchRuleContactStatusItem
        implements Serializable {


    @EmbeddedId
    public EntitySearchRuleContactStatusItemId id = new EntitySearchRuleContactStatusItemId();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleContactStatusItem
 * JD-Core Version:    0.6.0
 */