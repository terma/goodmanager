package ua.com.testes.manager.entity.search;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import java.util.ArrayList;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@DiscriminatorValue("8")

@Entity(name = "search_rule_firm_sections")
public final class EntitySearchRuleFirmSection extends EntitySearchRuleFirm {


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(mappedBy = "id.rule", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntitySearchRuleFirmSectionItem> items = new ArrayList();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleFirmSection
 * JD-Core Version:    0.6.0
 */