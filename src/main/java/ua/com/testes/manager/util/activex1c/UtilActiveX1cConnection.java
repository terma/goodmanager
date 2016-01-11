package ua.com.testes.manager.util.activex1c;


public final class UtilActiveX1cConnection {
    public final String url;
    public final String login;
    public final String password;


    public UtilActiveX1cConnection(String url, String login, String password) {

        this.url = url;

        this.login = login;

        this.password = password;

    }


    public int hashCode() {

        return this.url.hashCode() + 10 * this.login.hashCode() + 100 * this.password.hashCode();

    }


    public boolean equals(Object object) {

        if (object == null) {

            return false;

        }

        if (object.getClass() == UtilActiveX1cConnection.class) {

            return hashCode() == object.hashCode();

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.util.activex1c.UtilActiveX1cConnection
 * JD-Core Version:    0.6.0
 */