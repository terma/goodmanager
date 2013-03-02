package ua.com.testes.manager.entity.mail;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Lob;

@Entity(name = "part_files")
@DiscriminatorValue("FILE")
public class EntityPartFile extends EntityPart {

    @Lob
    @Column(name = "part_data", nullable = false)
    public byte[] data;

    @Column(name = "part_name", nullable = false, length = 1024)
    public String name;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.mail.EntityPartFile
 * JD-Core Version:    0.6.0
 */