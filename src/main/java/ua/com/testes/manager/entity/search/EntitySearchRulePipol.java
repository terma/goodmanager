package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("42")
@Entity(name = "search_rule_pipols")
public class EntitySearchRulePipol extends EntitySearchRule {

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rule_parent_id")
    public EntitySearchRulePipolComposite parent;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRulePipol
 * JD-Core Version:    0.6.0
 */