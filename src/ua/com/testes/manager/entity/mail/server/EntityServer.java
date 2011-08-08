package ua.com.testes.manager.entity.mail.server;


import ua.com.testes.manager.entity.mail.EntityMail;
import ua.com.testes.manager.entity.mail.server.rule.EntityServerRule;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


@Entity(name = "servers")
public class EntityServer
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_server")

    @SequenceGenerator(name = "generator_server", sequenceName = "generator_server")

    @Column(name = "server_id", nullable = false)
    public Integer serverId;


    @Column(name = "server_url", nullable = false, length = 500)
    public String url;


    @Column(name = "server_login", length = 500)
    public String login;


    @Column(name = "server_password", length = 500)
    public String password;


    @Enumerated(EnumType.STRING)

    @Column(name = "server_type", nullable = false, length = 20)
    public EntityServerType type;


    @OneToMany(mappedBy = "server", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntityServerRule> rules = new ArrayList();


    @OneToMany(mappedBy = "server")
    public List<EntityMail> mails = new ArrayList();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.mail.server.EntityServer
 * JD-Core Version:    0.6.0
 */