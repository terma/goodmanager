package ua.com.testes.manager.entity.mail.server.rule;

import ua.com.testes.manager.entity.mail.server.EntityServer;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;

@Inheritance(strategy = InheritanceType.JOINED)
@DiscriminatorColumn(name = "rule_type", discriminatorType = DiscriminatorType.STRING, length = 20)
@Entity(name = "server_rules")
public abstract class EntityServerRule
        implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_server_rule")
    @SequenceGenerator(name = "generator_server_rule", sequenceName = "generator_server_rule")
    @Column(name = "rule_id", nullable = false)
    public Integer ruleId;

    @ManyToOne
    @JoinColumn(name = "rule_server_id", nullable = false)
    public EntityServer server;

    @OneToOne
    @JoinColumn(name = "rule_user_id", nullable = false)
    public EntityUser user;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.mail.server.rule.EntityServerRule
 * JD-Core Version:    0.6.0
 */