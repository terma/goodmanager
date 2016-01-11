package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("15")
@Entity(name = "search_rule_pipol_others")
public final class EntitySearchRulePipolOther extends EntitySearchRulePipol {

    @Column(name = "rule_pipol_other", nullable = false)
    public String text;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRulePipolOther
 * JD-Core Version:    0.6.0
 */