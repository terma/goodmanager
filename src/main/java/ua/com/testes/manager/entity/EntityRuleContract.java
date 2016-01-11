package ua.com.testes.manager.entity;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public final class EntityRuleContract {

    @Column(name = "rule_contract_accept", nullable = false)
    public boolean accept;

    @Column(name = "rule_contract_create", nullable = false)
    public boolean create;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityRuleContract
 * JD-Core Version:    0.6.0
 */