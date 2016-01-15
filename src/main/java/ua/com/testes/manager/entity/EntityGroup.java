package ua.com.testes.manager.entity;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Entity(name = "user_groups")
public final class EntityGroup
        implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_group")
    @SequenceGenerator(name = "generator_group", sequenceName = "generator_group", allocationSize = 1)
    public Integer id;

    @Column(length = 250, nullable = false, unique = true, name = "group_name")
 public String name = "";

    @OneToMany(mappedBy = "id.owner", cascade = {javax.persistence.CascadeType.ALL})
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
 public List<EntityRule> rules = new ArrayList();

    @OneToMany(mappedBy = "group", cascade = {javax.persistence.CascadeType.ALL})
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
 public List<EntityUser> users = new ArrayList();

    public List<EntityUser> allowStatistic(List<EntityUser> users) {

        if (users == null) {

            throw new NullPointerException("Can't get correct user list by null list!");
        }

        if (this.id.intValue() == 2) {

            return new ArrayList(users);
        }

        List allowUsers = new ArrayList();

        for (EntityUser user : users) {

            if (allowStatistic(user)) {

                allowUsers.add(user);
            }
        }

        return allowUsers;
    }

    public EntityRule findRule(EntityGroup group) {

        if (group == null) {

            throw new NullPointerException("Can't find rule for null group!");
        }

        for (EntityRule rule : this.rules) {

            if (rule.id.depend.id == group.id) {

                return rule;
            }
        }

        return null;
    }

    public boolean allowStatistic(EntityUser user) {

        if (user == null) {

            throw new NullPointerException("Can't get correct user statistic by null user!");
        }

        if (this.id.intValue() == 2) {

            return true;
        }


        for (EntityRule rule : this.rules) {

            if ((rule.id.depend.id == user.getGroup().id) &&
         (rule.statistic)) {

                return true;
            }
        }


        return false;
    }

    public boolean allowContractAccept(EntityUser user) {

        if (user == null) {

            throw new NullPointerException("Can't get correct user contract accept by null user!");
        }

        if (this.id.intValue() == 2) {

            return true;
        }


        for (EntityRule rule : this.rules) {

            if ((rule.id.depend.id == user.getGroup().id) &&
                    (rule.contract.accept)) {

                return true;
            }
        }


        return false;
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityGroup
 * JD-Core Version:    0.6.0
 */