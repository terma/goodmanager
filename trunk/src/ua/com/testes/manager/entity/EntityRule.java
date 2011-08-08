package ua.com.testes.manager.entity;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "rules")
public final class EntityRule
        implements Serializable {


    @EmbeddedId
    public EntityRuleKey id = new EntityRuleKey();


    @Column(name = "rule_statistic", nullable = false)
    public boolean statistic;


    @Embedded
    public EntityRuleContent content = new EntityRuleContent();


    @Embedded
    public EntityRuleContract contract = new EntityRuleContract();


    @Embedded
    public EntityRuleTiding tiding = new EntityRuleTiding();


    @Embedded
    public EntityRuleTask task = new EntityRuleTask();


    public final String toString() {

        return new StringBuilder().append("rule with group ").append(this.id.owner.id).append(" to ").append(this.id.depend.id).append(" have ").append(this.statistic ? "statistic" : "").toString();

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityRule
 * JD-Core Version:    0.6.0
 */