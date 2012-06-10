package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("1")
@Entity(name = "search_rule_firm_names")
public final class EntitySearchRuleFirmName extends EntitySearchRuleFirm {

    @Column(name = "rule_firm_name", nullable = false)
    public String name;

}