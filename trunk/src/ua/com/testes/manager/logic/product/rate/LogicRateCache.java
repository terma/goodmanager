package ua.com.testes.manager.logic.product.rate;


import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import java.util.List;


final class LogicRateCache {
    private static final String CACHE_ITEM = "rateitem";
    private static final long CACHE_EXPRIRE_SECOND = 3600L;


    private Cache getCache() {

        Cache cache = CacheManager.getInstance().getCache("rateitem");

        if (cache == null) {

            cache = new Cache("rateitem", 10000, false, true, 3600L, 3600L, false, 0L);


            CacheManager.getInstance().addCache(cache);

        }

        return cache;

    }


    public List<LogicRateItem> get() {

        Element cacheElement = getCache().get("rateitem");

        if (cacheElement == null) return null;

        return (List) cacheElement.getObjectValue();

    }


    public void put(List<LogicRateItem> items) {

        Element cacheElement = new Element("rateitem", items);

        getCache().put(cacheElement);

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.rate.LogicRateCache
 * JD-Core Version:    0.6.0
 */