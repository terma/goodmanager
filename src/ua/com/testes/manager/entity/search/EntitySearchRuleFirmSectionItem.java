package ua.com.testes.manager.entity.search;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "rule_firm_section_items")
public final class EntitySearchRuleFirmSectionItem
        implements Serializable {


    @EmbeddedId
    public EntitySearchRuleFirmSectionItemId id = new EntitySearchRuleFirmSectionItemId();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRuleFirmSectionItem
 * JD-Core Version:    0.6.0
 */