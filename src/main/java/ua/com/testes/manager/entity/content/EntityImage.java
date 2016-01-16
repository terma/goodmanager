package ua.com.testes.manager.entity.content;


import javax.persistence.*;


@Entity(name = "images")
public class EntityImage {


    @Lob

    @Column(name = "image_data", nullable = false)
    public byte[] data;


    @Column(name = "image_alt")
    public String alt = "";


    @Column(name = "image_extend", nullable = false, length = 255)
    public String extend = "";


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_image")

    @SequenceGenerator(name = "generator_image", sequenceName = "generator_image")
    public Integer id;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.content.EntityImage
 * JD-Core Version:    0.6.0
 */