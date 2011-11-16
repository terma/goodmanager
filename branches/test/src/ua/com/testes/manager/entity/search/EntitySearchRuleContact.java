package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("43")
@Entity(name = "search_rule_contacts")
public abstract class EntitySearchRuleContact extends EntitySearchRule {

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rule_parent_id")
    public EntitySearchRuleContactComposite parent;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleContact
 * JD-Core Version:    0.6.0
 */