package ua.com.testes.manager.web.filter;


import ua.com.testes.manager.entity.user.EntityUser;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.HashMap;
import java.util.Map;


public class SessionListener implements HttpSessionListener {

    private static final Map<String, HttpSession> sessions = new HashMap<String, HttpSession>();


    public static void disconnect(int userId) {
        for (HttpSession session : sessions.values()) {
            EntityUser user = (EntityUser) session.getAttribute("user");
            if (user != null && user.getId() == userId) session.setAttribute("user", null);
        }
    }


    public static boolean isConnect(int userId) {
        for (HttpSession session : sessions.values()) {
            EntityUser user = (EntityUser) session.getAttribute("user");
            if (user != null && user.getId() == userId) return true;
        }
        return false;
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        sessions.put(se.getSession().getId(), se.getSession());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        sessions.remove(se.getSession().getId());
    }

}