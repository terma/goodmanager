package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.util.Date;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("6")
@Entity(name = "search_rule_firm_creates")
public final class EntitySearchRuleFirmCreate extends EntitySearchRuleFirm {

    @Temporal(TemporalType.DATE)
    @Column(name = "rule_firm_create_start")
    public Date start;

    @Temporal(TemporalType.DATE)
    @Column(name = "rule_firm_create_finish")
    public Date finish;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleFirmCreate
 * JD-Core Version:    0.6.0
 */