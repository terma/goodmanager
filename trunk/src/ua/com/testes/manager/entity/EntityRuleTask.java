package ua.com.testes.manager.entity;


import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;


@Embeddable
public final class EntityRuleTask
        implements Serializable {


    @Column(name = "rule_task_create", nullable = false)
    public boolean create = false;


    @Column(name = "rule_task_view", nullable = false)
    public boolean view = false;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityRuleTask
 * JD-Core Version:    0.6.0
 */