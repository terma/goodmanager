package ua.com.testes.manager.entity.search;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@DiscriminatorValue("1")
public class EntitySearchSourceFirm extends EntitySearchSource {
}