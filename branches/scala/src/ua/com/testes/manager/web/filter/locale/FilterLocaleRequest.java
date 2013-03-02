package ua.com.testes.manager.web.filter.locale;


import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.entity.view.EntityView;
import ua.com.testes.manager.logic.view.LogicView;
import ua.com.testes.manager.util.locale.UtilLocale;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpSession;
import java.util.Locale;


public final class FilterLocaleRequest extends HttpServletRequestWrapper {
    private final Locale locale;


    private static Locale byCookie(HttpServletRequest request) {

        if (request.getCookies() != null) {

            for (Cookie cookie : request.getCookies()) {

                if ("LOCALE_COOKIE_PARAMETER".equals(cookie.getName())) {

                    return UtilLocale.toLocale(cookie.getValue());

                }

            }

        }

        return null;

    }


    private static Locale bySession(HttpServletRequest request) {

        HttpSession session = request.getSession(true);

        Locale sessionLocale = (Locale) session.getAttribute("LOCALE_SESSION_PARAMETER");

        if (sessionLocale != null) {

            return sessionLocale;

        }

        return null;

    }


    private static Locale byUser(HttpServletRequest request) {

        HttpSession session = request.getSession(true);

        Integer userId = (Integer) session.getAttribute("userId");

        if (userId != null) {

            EntityUser user = (EntityUser) EntityManager.find(EntityUser.class, userId);

            EntityView view = LogicView.get(user);

            if (view.locale != null) return UtilLocale.toLocale(view.locale);

        }

        return null;

    }


    public FilterLocaleRequest(HttpServletRequest request) {

        super(request);

        Locale tempLocale = byUser(request);

        if (tempLocale == null) {

            tempLocale = bySession(request);

            if (tempLocale == null) {

                tempLocale = byCookie(request);

                if (tempLocale == null) {

                    tempLocale = request.getLocale();

                }

            }

        }

        this.locale = tempLocale;

    }


    public Locale getLocale() {

        return this.locale;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.locale.FilterLocaleRequest
 * JD-Core Version:    0.6.0
 */