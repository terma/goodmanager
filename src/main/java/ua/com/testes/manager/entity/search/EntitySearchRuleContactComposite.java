package ua.com.testes.manager.entity.search;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@DiscriminatorValue("33")

@Entity(name = "search_rule_contact_composites")
public final class EntitySearchRuleContactComposite extends EntitySearchRulePipol {


    @Enumerated

    @Column(name = "composite_type", nullable = false)
    public Type type = Type.AND;


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(mappedBy = "parent", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntitySearchRuleContact> rules = new ArrayList();


    public void addRule(EntitySearchRuleContact rule) {

        if (rule == null) {

            throw new NullPointerException();

        }

        rule.parent = this;

        this.rules.add(rule);

    }


    public static enum Type {
        OR, AND;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleContactComposite
 * JD-Core Version:    0.6.0
 */