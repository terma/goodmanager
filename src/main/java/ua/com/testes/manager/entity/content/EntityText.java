package ua.com.testes.manager.entity.content;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "texts")
public final class EntityText
        implements Serializable {


    @Lob

    @Column(name = "text_description", nullable = false)
    public String description = "";


    @Column(name = "text_name", nullable = false, unique = true, length = 255)
    public String name = "";


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_text")

    @SequenceGenerator(name = "generator_text", sequenceName = "generator_text")
    public Integer id;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.content.EntityText
 * JD-Core Version:    0.6.0
 */