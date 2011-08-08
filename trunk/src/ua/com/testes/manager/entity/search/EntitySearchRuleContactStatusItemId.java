package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;

@Embeddable
public final class EntitySearchRuleContactStatusItemId
        implements Serializable {

    @Column(nullable = false, name = "item_status_id")
    public int statusId;

    @ManyToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "item_rule_id", nullable = false)
    public EntitySearchRuleContactStatus rule;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleContactStatusItemId
 * JD-Core Version:    0.6.0
 */