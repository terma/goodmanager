package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Inheritance(strategy = InheritanceType.JOINED)
@DiscriminatorColumn(name = "rule_type", discriminatorType = DiscriminatorType.INTEGER)
@Entity(name = "search_rules")
public abstract class EntitySearchRule
        implements Serializable {

    @Id
    @Column(name = "rule_id")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_search_rule")
    @SequenceGenerator(name = "generator_search_rule", sequenceName = "generator_search_rule")
    public Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "rule_source_id")
    public EntitySearchSource source;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.search.EntitySearchRule
 * JD-Core Version:    0.6.0
 */