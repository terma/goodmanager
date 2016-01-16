package ua.com.testes.manager.entity.task;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "tasks")
public final class EntityTask
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_task")

    @SequenceGenerator(name = "generator_task", sequenceName = "generator_task")

    @Column(name = "task_id")
    public Integer id;


    @Column(name = "task_name", nullable = false, length = 1000)
    public String name = "";


    @Lob

    @Column(nullable = false, name = "task_description")
    public String description = "";


    @Temporal(TemporalType.TIMESTAMP)

    @Column(name = "task_create", nullable = false, insertable = true, updatable = false)
    public Date create = new Date();


    @ManyToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "task_owner_id", nullable = false)
    public EntityUser owner;


    @OneToMany(cascade = {javax.persistence.CascadeType.ALL})

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    public List<EntityTaskExecutor> executors;


    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @ManyToOne

    @JoinColumn(name = "task_previous_id")
    public EntityTask previous;


    @OneToMany(cascade = {javax.persistence.CascadeType.ALL})

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    public List<EntityTask> nexts = new ArrayList();

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.task.EntityTask
 * JD-Core Version:    0.6.0
 */