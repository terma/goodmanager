package ua.com.testes.manager.entity.search;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import java.util.ArrayList;
import java.util.List;


@Entity

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@DiscriminatorValue("21")

@Table(name = "search_rule_contact_statuses")
public final class EntitySearchRuleContactStatus extends EntitySearchRuleContact {


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(mappedBy = "id.rule", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntitySearchRuleContactStatusItem> items = new ArrayList();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleContactStatus
 * JD-Core Version:    0.6.0
 */