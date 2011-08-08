package ua.com.testes.manager.entity.user;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;

@Embeddable
public final class EntityUser1c
        implements Serializable {

    @Column(name = "user_1c_login")
    public String login;

    @Column(name = "user_1c_password")
    public String password;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.entity.user.EntityUser1c
 * JD-Core Version:    0.6.0
 */