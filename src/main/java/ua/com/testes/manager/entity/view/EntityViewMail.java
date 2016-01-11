package ua.com.testes.manager.entity.view;


import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;


@Embeddable
public final class EntityViewMail
        implements Serializable {


    @Column(nullable = false, name = "view_mail_show")
    public boolean show = true;


    @Column(name = "view_mail_count")
    public Integer count;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.view.EntityViewMail
 * JD-Core Version:    0.6.0
 */