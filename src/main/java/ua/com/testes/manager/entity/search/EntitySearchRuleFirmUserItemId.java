package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;

@Embeddable
public final class EntitySearchRuleFirmUserItemId
        implements Serializable {

    @Column(nullable = false, name = "item_user_id")
    public int userId;

    @ManyToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "item_rule_id", nullable = false)
    public EntitySearchRuleFirmUser rule;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleFirmUserItemId
 * JD-Core Version:    0.6.0
 */