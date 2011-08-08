package ua.com.testes.manager.entity;


import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;


@Embeddable
public final class EntityRuleTiding
        implements Serializable {


    @Column(name = "rule_tiding_add", nullable = false)
    public boolean edit = false;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityRuleTiding
 * JD-Core Version:    0.6.0
 */