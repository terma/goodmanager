package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("2")
@Entity(name = "search_rule_pipol_fios")
public final class EntitySearchRulePipolFio extends EntitySearchRulePipol {

    @Column(name = "rule_pipol_fios", nullable = false)
    public String fio;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRulePipolFio
 * JD-Core Version:    0.6.0
 */