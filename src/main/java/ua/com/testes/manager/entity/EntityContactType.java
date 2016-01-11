package ua.com.testes.manager.entity;


import javax.persistence.*;
import java.io.Serializable;


@Entity(name = "contact_types")
public class EntityContactType
        implements Serializable {


    @Id

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator_contract_type")

    @SequenceGenerator(name = "generator_contract_type", sequenceName = "generator_contract_type", allocationSize = 1)
    public Integer id;


    @Column(name = "type_name", length = 300, nullable = false, unique = true)
    public String name = "";

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.EntityContactType
 * JD-Core Version:    0.6.0
 */