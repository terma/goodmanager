package ua.com.testes.manager.entity;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;


@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

@Entity(name = "version_files")
public final class EntityVersionFile
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_file")

    @SequenceGenerator(name = "generator_file", sequenceName = "generator_file", allocationSize = 1)

    @Column(name = "file_id")
    public Integer id;


    @Column(nullable = false, name = "file_name")
    public String name = "";


    @Column(nullable = false, name = "file_path")
    public String path = "";


    @Lob

    @Column(name = "file_data", nullable = false)
    public byte[] data = new byte[0];


    @ManyToOne

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

    @JoinColumn(name = "file_version_id", nullable = false)
    public EntityContractVersion version;

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityVersionFile
 * JD-Core Version:    0.6.0
 */