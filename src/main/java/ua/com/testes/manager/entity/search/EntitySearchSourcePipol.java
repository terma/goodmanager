package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("3")
public class EntitySearchSourcePipol extends EntitySearchSource {
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchSourcePipol
 * JD-Core Version:    0.6.0
 */