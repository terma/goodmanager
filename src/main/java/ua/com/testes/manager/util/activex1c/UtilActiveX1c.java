package ua.com.testes.manager.util.activex1c;


import com.jacob.activeX.ActiveXComponent;
import com.jacob.com.Variant;

import java.util.*;


public class UtilActiveX1c {
    private static final Map<UtilActiveX1cConnection, ActiveXComponent> activeXs = new HashMap();


    public static void execute(String url, String login, String password, UtilActiveX1cTransaction utilActiveX1cTransaction) {

        ActiveXComponent activeX1cComponent = getCacheOrNew(url, login, password);


        utilActiveX1cTransaction.execute(activeX1cComponent);

    }


    public static void shutdown() {

        synchronized (activeXs) {

            for (ActiveXComponent activeX : activeXs.values()) {

                activeX.safeRelease();

            }

            activeXs.clear();

        }

    }


    public static List<UtilActiveX1cConnection> getActive() {

        synchronized (activeXs) {

            return Collections.unmodifiableList(new ArrayList(activeXs.keySet()));

        }

    }


    private static ActiveXComponent getCacheOrNew(String url, String login, String password) {

        synchronized (activeXs) {

            UtilActiveX1cConnection connection = new UtilActiveX1cConnection(url, login, password);

            ActiveXComponent activeX = (ActiveXComponent) activeXs.get(connection);

            if (activeX == null) {

                activeX = getNew(url, login, password);

                activeXs.put(connection, activeX);

            }

            return activeX;

        }

    }


    private static ActiveXComponent getNew(String url, String login, String password) {

        ActiveXComponent activeX = new ActiveXComponent("V77.Application");

        Variant[] initParameter = new Variant[3];

        initParameter[1] = new Variant("/D" + url + " /N" + login + " /P" + password);

        initParameter[2] = new Variant("NO_SPLASH_SHOW");

        activeX.invoke("initialize", initParameter);

        return activeX;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.util.activex1c.UtilActiveX1c
 * JD-Core Version:    0.6.0
 */