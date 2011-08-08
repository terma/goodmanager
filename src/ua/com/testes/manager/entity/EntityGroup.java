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
/*  26 */ public String name = "";

    @OneToMany(mappedBy = "id.owner", cascade = {javax.persistence.CascadeType.ALL})
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
/*  29 */ public List<EntityRule> rules = new ArrayList();

    @OneToMany(mappedBy = "group", cascade = {javax.persistence.CascadeType.ALL})
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
/*  33 */ public List<EntityUser> users = new ArrayList();

    public List<EntityUser> allowStatistic(List<EntityUser> users) {
/*  45 */
        if (users == null) {
/*  46 */
            throw new NullPointerException("Can't get correct user list by null list!");
        }
/*  48 */
        if (this.id.intValue() == 2) {
/*  49 */
            return new ArrayList(users);
        }
/*  51 */
        List allowUsers = new ArrayList();
/*  52 */
        for (EntityUser user : users) {
/*  53 */
            if (allowStatistic(user)) {
/*  54 */
                allowUsers.add(user);
            }
        }
/*  57 */
        return allowUsers;
    }

    public EntityRule findRule(EntityGroup group) {
/*  61 */
        if (group == null) {
/*  62 */
            throw new NullPointerException("Can't find rule for null group!");
        }
/*  64 */
        for (EntityRule rule : this.rules) {
/*  65 */
            if (rule.id.depend.id == group.id) {
/*  66 */
                return rule;
            }
        }
/*  69 */
        return null;
    }

    public boolean allowStatistic(EntityUser user) {
/*  73 */
        if (user == null) {
/*  74 */
            throw new NullPointerException("Can't get correct user statistic by null user!");
        }
/*  76 */
        if (this.id.intValue() == 2) {
/*  77 */
            return true;
        }

/*  80 */
        for (EntityRule rule : this.rules) {
/*  81 */
            if ((rule.id.depend.id == user.getGroup().id) &&
/*  82 */         (rule.statistic)) {
/*  83 */
                return true;
            }
        }

/*  87 */
        return false;
    }

    public boolean allowContractAccept(EntityUser user) {
/*  91 */
        if (user == null) {
/*  92 */
            throw new NullPointerException("Can't get correct user contract accept by null user!");
        }
/*  94 */
        if (this.id.intValue() == 2) {
/*  95 */
            return true;
        }

/*  98 */
        for (EntityRule rule : this.rules) {
/*  99 */
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