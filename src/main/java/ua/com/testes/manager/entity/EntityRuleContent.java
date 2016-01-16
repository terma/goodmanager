package ua.com.testes.manager.entity;


import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;


@Embeddable
public final class EntityRuleContent
        implements Serializable {


    @Column(name = "rule_content_edit", nullable = false)
    public boolean edit = false;


    @Column(name = "rule_content_view", nullable = false)
    public boolean view = false;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityRuleContent
 * JD-Core Version:    0.6.0
 */