package ua.com.testes.manager.entity.user;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.EntityGroup;
import ua.com.testes.manager.entity.mail.EntityMail;
import ua.com.testes.manager.entity.task.EntityTask;
import ua.com.testes.manager.entity.view.EntityView;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Entity(name = "users")
public final class EntityUser
        implements Serializable {

    @Column(length = 250, nullable = false)
 private String fio = "";

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_user")
    @SequenceGenerator(name = "generator_user", sequenceName = "generator_user", allocationSize = 1)
    private Integer id;

    @Lob
    @Column(name = "descriptions", nullable = false)
 private String description = "";

    @Column(name = "password1", length = 100, nullable = false)
 private String password = "";

    @Column(name = "ib_name", length = 100, nullable = false, unique = true)
 private String login = "";

    @Column(length = 250, nullable = false, name = "user_email")
 private String email = "";

    @ManyToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "id_group", nullable = false)
    private EntityGroup group;

    @Column(name = "user_disable")
    @Temporal(TemporalType.TIMESTAMP)
    private Date disable;

    @OneToMany(mappedBy = "user", cascade = {javax.persistence.CascadeType.ALL})
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
 private List<EntityFirm> firms = new ArrayList();

    @Column(name = "user_block")
    @Temporal(TemporalType.TIMESTAMP)
    private Date block;

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToMany(mappedBy = "owner")
 private List<EntityTask> dependTasks = new ArrayList();

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToMany(mappedBy = "owner", cascade = {javax.persistence.CascadeType.ALL})
 private List<EntityTask> ownerTasks = new ArrayList();

    @OneToOne(cascade = {javax.persistence.CascadeType.ALL}, fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "user_view_id")
 private EntityView defaultView = new EntityView();

    @OneToMany(mappedBy = "user", cascade = {javax.persistence.CascadeType.ALL})
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
 private List<EntityMail> mails = new ArrayList();

    @Embedded
 private EntityUser1c activeX1c = new EntityUser1c();

    public boolean isBlock() {

        return (getBlock() != null) && (System.currentTimeMillis() - getBlock().getTime() <= 0L);
    }

    public String getFio() {

        return this.fio;
    }

    public void setFio(String fio) {

        this.fio = fio;
    }

    public Integer getId() {

        return this.id;
    }

    public void setId(Integer id) {

        this.id = id;
    }

    public String getDescription() {

        return this.description;
    }

    public void setDescription(String description) {

        this.description = description;
    }

    public String getPassword() {

        return this.password;
    }

    public void setPassword(String password) {

        this.password = password;
    }

    public String getLogin() {

        return this.login;
    }

    public void setLogin(String login) {

        this.login = login;
    }

    public String getEmail() {

        return this.email;
    }

    public void setEmail(String email) {

        this.email = email;
    }

    public EntityGroup getGroup() {

        return this.group;
    }

    public void setGroup(EntityGroup group) {

        this.group = group;
    }

    public Date getDisable() {

        return this.disable;
    }

    public void setDisable(Date disable) {

        this.disable = disable;
    }

    public List<EntityFirm> getFirms() {

        return this.firms;
    }

    public void setFirms(List<EntityFirm> firms) {

        this.firms = firms;
    }

    public Date getBlock() {

        return this.block;
    }

    public void setBlock(Date block) {

        this.block = block;
    }

    public List<EntityTask> getDependTasks() {

        return this.dependTasks;
    }

    public void setDependTasks(List<EntityTask> dependTasks) {

        this.dependTasks = dependTasks;
    }

    public List<EntityTask> getOwnerTasks() {

        return this.ownerTasks;
    }

    public void setOwnerTasks(List<EntityTask> ownerTasks) {

        this.ownerTasks = ownerTasks;
    }

    public EntityView getDefaultView() {

        return this.defaultView;
    }

    public void setDefaultView(EntityView defaultView) {

        this.defaultView = defaultView;
    }

    public List<EntityMail> getMails() {

        return this.mails;
    }

    public void setMails(List<EntityMail> mails) {

        this.mails = mails;
    }

    public EntityUser1c getActiveX1c() {

        return this.activeX1c;
    }

    public void setActiveX1c(EntityUser1c activeX1c) {

        this.activeX1c = activeX1c;
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.user.EntityUser
 * JD-Core Version:    0.6.0
 */