package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.util.Date;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("18")
@Entity(name = "search_rule_contact_creates")
public final class EntitySearchRuleContactCreate extends EntitySearchRuleContact {

    @Temporal(TemporalType.DATE)
    @Column(name = "rule_contact_create_start")
    public Date start;

    @Temporal(TemporalType.DATE)
    @Column(name = "rule_contact_create_finish")
    public Date finish;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleContactCreate
 * JD-Core Version:    0.6.0
 */