package ua.com.testes.manager.entity.view;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.Embeddable;
import javax.persistence.OneToMany;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


@Embeddable
public final class EntityViewSort
        implements Serializable {


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(mappedBy = "view", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntityFirmSort> firms = new ArrayList();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.view.EntityViewSort
 * JD-Core Version:    0.6.0
 */