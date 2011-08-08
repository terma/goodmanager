package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("11")
@Entity(name = "search_rule_contact_des")
public final class EntitySearchRuleContactDescription extends EntitySearchRuleContact {

    @Column(name = "rule_contact_description", nullable = false)
    public String description;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleContactDescription
 * JD-Core Version:    0.6.0
 */