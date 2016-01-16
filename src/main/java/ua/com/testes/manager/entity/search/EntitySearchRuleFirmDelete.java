package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.util.Date;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("16")
@Entity(name = "search_rule_firm_deletes")
public final class EntitySearchRuleFirmDelete extends EntitySearchRuleFirm {

    @Temporal(TemporalType.DATE)
    @Column(name = "rule_firm_delete_start")
    public Date start;

    @Temporal(TemporalType.DATE)
    @Column(name = "rule_firm_delete_finish")
    public Date finish;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleFirmDelete
 * JD-Core Version:    0.6.0
 */