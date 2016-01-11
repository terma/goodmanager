package ua.com.testes.manager.logic.mail;


import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import java.util.List;


class MailCache {
    private static final String CACHE_MAIL_ITEM = "mailitem";
    private static final long CACHE_EXPRIRE_SECOND = 600L;


    private Cache getCache() {

        Cache cache = CacheManager.getInstance().getCache("mailitem");

        if (cache == null) {

            cache = new Cache("mailitem", 10000, false, true, 600L, 600L, false, 0L);


            CacheManager.getInstance().addCache(cache);

        }

        return cache;

    }


    public List<MailItem> getItems(long userId) {

        Element cacheElement = getCache().get(Long.valueOf(userId));

        if (cacheElement == null) return null;

        return (List) cacheElement.getObjectValue();

    }


    public void put(long userId, List<MailItem> items) {

        Element cacheElement = new Element(Long.valueOf(userId), items);

        getCache().put(cacheElement);

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailCache
 * JD-Core Version:    0.6.0
 */