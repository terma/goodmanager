package ua.com.testes.manager.util.activex1c;


public final class UtilActiveX1cConnection {

    public final String url;
    public final String login;
    public final String password;

    UtilActiveX1cConnection(String url, String login, String password) {
        this.url = url;
        this.login = login;
        this.password = password;
    }

    @Override
    public int hashCode() {
        return this.url.hashCode() + 10 * this.login.hashCode() + 100 * this.password.hashCode();
    }

    @Override
    public boolean equals(Object object) {
        return object != null && object.getClass() == UtilActiveX1cConnection.class && hashCode() == object.hashCode();

    }

}