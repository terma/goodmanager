package ua.com.testes.manager.entity.view;


import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;


@Embeddable
public final class EntityViewDelete
        implements Serializable {


    @Column(nullable = false, name = "view_delete_firm")
    public boolean firm = false;


    @Column(nullable = false, name = "view_delete_pipol")
    public boolean pipol = false;


    @Column(nullable = false, name = "view_delete_contact")
    public boolean contact = false;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.view.EntityViewDelete
 * JD-Core Version:    0.6.0
 */