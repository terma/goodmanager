package ua.com.testes.manager.logic.mail;


import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.entity.view.EntityView;
import ua.com.testes.manager.logic.view.LogicView;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


public final class MailFacade {
    private static final MailCache cache = new MailCache();
    private static MailProviderFactory providerFactory = null;


    public static void setProviderFactory(MailProviderFactory providerFactory) {

        if (providerFactory == null) {

            throw new NullPointerException();

        }

        providerFactory = providerFactory;

    }


    public static boolean isUse(EntityUser user) {

        if (user == null) {

            throw new NullPointerException("Can't get use mail by null user!");

        }

        if (user.getId() == null) {

            throw new NullPointerException("Can't get use mail by new user!");

        }

        EntityView view = LogicView.get(user);

        return (providerFactory != null) && (view.mail.show);

    }


    private static List<MailItem> getTrimItems(EntityUser user, List<MailItem> mailItems) {

        EntityView view = LogicView.get(user);

        if (view.mail.count == null) return mailItems;

        if (view.mail.count.intValue() >= mailItems.size()) return mailItems;

        Collections.sort(mailItems, new MailComparator());

        List trimMailItems = new ArrayList();

        for (int i = 1; (i <= mailItems.size()) &&
                (i <= view.mail.count.intValue()); i++) {

            trimMailItems.add(mailItems.get(i - 1));

        }

        return trimMailItems;

    }


    private static List<MailItem> getItemsInternal(EntityUser user, boolean mustRefresh) throws MailException {

        List mailItems = cache.getItems(user.getId().intValue());

        if ((!mustRefresh) && (mailItems != null)) {

            return mailItems;

        }

        MailProvider provider = providerFactory.getProvider(user.getLogin(), user.getPassword());

        mailItems = provider.getMessages();

        cache.put(user.getId().intValue(), mailItems);

        return mailItems;

    }


    public static List<MailItem> getItems(EntityUser user, boolean mustRefresh) throws MailException {

        if (!isUse(user)) {

            throw new IllegalStateException("Can't get mail for user " + user.getId());

        }

        return getTrimItems(user, getItemsInternal(user, mustRefresh));

    }


    public static int getCount(EntityUser user, boolean mustRefresh) throws MailException {

        return getItemsInternal(user, mustRefresh).size();

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailFacade
 * JD-Core Version:    0.6.0
 */