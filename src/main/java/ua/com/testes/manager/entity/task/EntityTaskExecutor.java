package ua.com.testes.manager.entity.task;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;


@Entity(name = "task_executors")

@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class EntityTaskExecutor
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_executor")

    @SequenceGenerator(name = "generator_executor", sequenceName = "generator_executor")

    @Column(name = "executor_id")
    public Integer id;


    @ManyToOne

    @JoinColumn(name = "executor_task_id", nullable = false)
    public EntityTask task;


    @OneToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "executor_user_id", nullable = false)
    public EntityUser user;


    @Temporal(TemporalType.TIMESTAMP)

    @Column(name = "executor_accept")
    public Date accept;


    @Temporal(TemporalType.TIMESTAMP)

    @Column(name = "executor_must")
    public Date must;


    @Lob

    @Column(nullable = false, name = "executor_description")
    public String description = "";

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.task.EntityTaskExecutor
 * JD-Core Version:    0.6.0
 */