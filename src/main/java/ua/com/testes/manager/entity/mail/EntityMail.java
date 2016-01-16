package ua.com.testes.manager.entity.mail;


import ua.com.testes.manager.entity.mail.server.EntityServer;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Entity(name = "mails")
public class EntityMail
        implements Serializable {


    @Temporal(TemporalType.TIMESTAMP)

    @Column(name = "mail_created", nullable = false)
    public Date created = new Date();


    @Temporal(TemporalType.TIMESTAMP)

    @Column(name = "mail_sended")
    public Date sended;


    @Temporal(TemporalType.TIMESTAMP)

    @Column(name = "mail_received")
    public Date received;


    @Column(name = "mail_theme", length = 2048)
    public String theme;


    @Column(name = "mail_to", length = 2048)
    public String to;


    @Column(name = "mail_from", length = 2048)
    public String from;


    @OneToMany(mappedBy = "mail", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntityPart> parts = new ArrayList();


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_mail")

    @SequenceGenerator(name = "generator_mail", sequenceName = "generator_mail")

    @Column(name = "mail_id", nullable = false)
    public Integer mailId;


    @ManyToOne

    @JoinColumn(name = "mail_user_id", nullable = false)
    public EntityUser user;


    @ManyToOne

    @JoinColumn(name = "mail_server_id", nullable = false)
    public EntityServer server;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.mail.EntityMail
 * JD-Core Version:    0.6.0
 */