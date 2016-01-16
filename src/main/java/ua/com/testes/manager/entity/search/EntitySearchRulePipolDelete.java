package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.util.Date;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("23")
@Entity(name = "search_rule_pipol_deletes")
public final class EntitySearchRulePipolDelete extends EntitySearchRulePipol {

    @Temporal(TemporalType.DATE)
    @Column(name = "rule_pipol_delete_start")
    public Date start;

    @Temporal(TemporalType.DATE)
    @Column(name = "rule_pipol_delete_finish")
    public Date finish;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRulePipolDelete
 * JD-Core Version:    0.6.0
 */