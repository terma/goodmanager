package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("41")
@Entity(name = "search_rule_firms")
public class EntitySearchRuleFirm extends EntitySearchRule {

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rule_parent_id")
    public EntitySearchRuleFirmComposite parent;
}