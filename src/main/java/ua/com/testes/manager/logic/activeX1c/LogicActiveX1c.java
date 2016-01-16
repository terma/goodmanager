package ua.com.testes.manager.logic.activeX1c;


import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.util.activex1c.UtilActiveX1c;
import ua.com.testes.manager.util.activex1c.UtilActiveX1cTransaction;


public class LogicActiveX1c {
    private static String url1c;


    public static void execute(EntityUser user, UtilActiveX1cTransaction utilActiveX1cTransaction) {

        if (url1c != null) {

            String activeX1cLogin = user.getActiveX1c().login;

            String activeX1cPassword = user.getActiveX1c().password;

            if (activeX1cLogin == null) {

                activeX1cLogin = user.getLogin();

            }

            if (activeX1cPassword == null) {

                activeX1cPassword = user.getPassword();

            }

            UtilActiveX1c.execute(url1c, activeX1cLogin, activeX1cPassword, utilActiveX1cTransaction);

        }

    }


    public static boolean isUse() {

        return url1c != null;

    }


    public static void setUse1c(String url1c) {

        url1c = url1c;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.activeX1c.LogicActiveX1c
 * JD-Core Version:    0.6.0
 */