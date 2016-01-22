package ua.com.testes.manager.entity;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import ua.com.testes.manager.entity.user.EntityUser;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@NamedQuery(name = "sections.all", query = "select section from ua.com.testes.manager.entity.EntitySection as section")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Entity(name = "sections")
public final class EntitySection implements Serializable {

    @Column(nullable = false, length = 300)
    private String name;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "GENERATOR_SECTION")
    @SequenceGenerator(name = "GENERATOR_SECTION", sequenceName = "GENERATOR_SECTION", allocationSize = 1)
    private Integer id;

    @Column(name = "descriptions", nullable = false)
    private String description;

    @OneToMany(mappedBy = "parent", cascade = {javax.persistence.CascadeType.ALL})
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    private List<EntitySection> children = new ArrayList<EntitySection>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_parent")
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    private EntitySection parent;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_owner")
    private EntityUser owner;

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToMany(cascade = {javax.persistence.CascadeType.ALL})
    @JoinColumn(name = "id_parent")
    private List<EntityFirm> firms = new ArrayList<EntityFirm>();

    @OneToOne(fetch = FetchType.LAZY)
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @JoinColumn(name = "section_style_id")
    private EntityStyle style;

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
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

    public List<EntitySection> getChildren() {
        return this.children;
    }

    public void setChildren(List<EntitySection> children) {
        this.children = children;
    }

    public EntitySection getParent() {
        return this.parent;
    }

    public void setParent(EntitySection parent) {
        this.parent = parent;
    }

    public EntityUser getOwner() {
        return this.owner;
    }

    public void setOwner(EntityUser owner) {
        this.owner = owner;
    }

    public List<EntityFirm> getFirms() {
        return this.firms;
    }

    public void setFirms(List<EntityFirm> firms) {
        this.firms = firms;
    }

    public EntityStyle getStyle() {
        return this.style;
    }

    public void setStyle(EntityStyle style) {
        this.style = style;
    }

}