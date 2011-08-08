package ua.com.testes.manager.entity.mail;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Lob;

@Entity(name = "part_texts")
@DiscriminatorValue("TEXT")
public class EntityPartText extends EntityPart {

    @Lob
    @Column(name = "part_text", nullable = false)
    public String text;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.mail.EntityPartText
 * JD-Core Version:    0.6.0
 */