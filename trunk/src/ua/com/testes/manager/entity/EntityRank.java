package ua.com.testes.manager.entity;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Entity(name = "rank")
public final class EntityRank {
    public String name;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_rank")
    @SequenceGenerator(name = "generator_rank", sequenceName = "generator_rank", allocationSize = 1)
    public Integer id;
    public String description;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityRank
 * JD-Core Version:    0.6.0
 */