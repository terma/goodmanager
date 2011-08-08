package ua.com.testes.manager.entity.talk;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "talks")
public final class EntityTalk
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_talk")

    @SequenceGenerator(name = "generator_talk", sequenceName = "generator_talk", allocationSize = 1)
    public Integer id;


    @Column(name = "talk_create", nullable = false)
    public Date create = new Date();


    @ManyToOne(fetch = FetchType.LAZY)

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "talk_user_id", nullable = false)
    public EntityUser user;


    @Lob

    @Column(name = "talk_description", nullable = false)
    public String description;


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @OneToMany(mappedBy = "talk", cascade = {javax.persistence.CascadeType.ALL})
    public List<EntityTalkUser> recipients = new ArrayList();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.talk.EntityTalk
 * JD-Core Version:    0.6.0
 */