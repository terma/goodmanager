package ua.com.testes.manager.entity;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "contracts")
public final class EntityContract
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_contract")

    @SequenceGenerator(name = "generator_contract", sequenceName = "generator_contract", allocationSize = 1)

    @Column(name = "contract_id")
    public Integer id;


    @Column(name = "contract_name", length = 300, nullable = false)
    public String name = "";


    @OneToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(nullable = false, name = "contract_user_id")
    public EntityUser user;


    @Column(name = "contract_description", nullable = false)
    public String description = "";


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(mappedBy = "contract", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntityContractVersion> versions = new ArrayList();


    public EntityContractVersion getResolutionVersion() {

        EntityContractVersion lastVersion = null;

        for (EntityContractVersion version : this.versions) {

            if ((version.resolution != null) && ((lastVersion == null) || (lastVersion.create.before(version.create)))) {

                lastVersion = version;

            }

        }

        return lastVersion;

    }


    public EntityContractVersion getLastVersion() {

        EntityContractVersion lastVersion = null;

        for (EntityContractVersion version : this.versions) {

            if ((lastVersion == null) || (lastVersion.id.intValue() < version.id.intValue())) {

                lastVersion = version;

            }

        }

        return lastVersion;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityContract
 * JD-Core Version:    0.6.0
 */