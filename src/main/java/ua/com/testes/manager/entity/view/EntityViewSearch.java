package ua.com.testes.manager.entity.view;


import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;


@Embeddable
public final class EntityViewSearch
        implements Serializable {


    @Column(nullable = false, name = "view_search_source")
    public Source source = Source.APPLICATION;


    @Column(name = "view_search_show")
    public boolean show = true;


    public static enum Source {
        GOOGLE, YANDEX, RAMBLER, APPLICATION;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.view.EntityViewSearch
 * JD-Core Version:    0.6.0
 */