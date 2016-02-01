package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "source_type", discriminatorType = DiscriminatorType.INTEGER)
@Entity(name = "search_sources")
public abstract class EntitySearchSource implements Serializable {

    @Id
    @Column(name = "source_id")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_search_source")
    @SequenceGenerator(name = "generator_search_source", sequenceName = "generator_search_source")
    public Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "source_search_id", nullable = false)
    public EntitySearch search;

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToOne(cascade = {javax.persistence.CascadeType.ALL}, mappedBy = "source")
    public EntitySearchRule rule;
}