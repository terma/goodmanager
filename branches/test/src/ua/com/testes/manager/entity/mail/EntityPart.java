package ua.com.testes.manager.entity.mail;

import javax.persistence.*;
import java.io.Serializable;

@Inheritance(strategy = InheritanceType.JOINED)
@DiscriminatorColumn(name = "part_type", discriminatorType = DiscriminatorType.STRING, length = 20)
@Entity(name = "parts")
public abstract class EntityPart
        implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_part")
    @SequenceGenerator(name = "generator_part", sequenceName = "generator_part")
    @Column(name = "part_id", nullable = false)
    public Integer partId;

    @ManyToOne
    @JoinColumn(name = "part_mail_id", nullable = false)
    public EntityMail mail;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.mail.EntityPart
 * JD-Core Version:    0.6.0
 */