package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.search.EntitySearch;
import ua.com.testes.manager.entity.search.EntitySearchSource;
import ua.com.testes.manager.view.search.ViewSearch;

import java.io.Serializable;
import java.util.*;


public class LogicSearch {

    public static void park(int searchId) {
        final EntitySearch search = ua.com.testes.manager.entity.EntityManager.find(EntitySearch.class, Integer.valueOf(searchId));

        if (search == null) {
            throw new NullPointerException();
        }

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public Void execute(javax.persistence.EntityManager manager) {
                search.park = true;
                return null;
            }

        });
    }


    public static void delete(int searchId) {
        final EntitySearch search = ua.com.testes.manager.entity.EntityManager.find(EntitySearch.class, Integer.valueOf(searchId));

        if (search == null) {
            throw new NullPointerException();
        }

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public Void execute(javax.persistence.EntityManager manager) {
                manager.remove(search);
                return null;
            }

        });
    }

    public static void create(final EntitySearch search) {
        final List<EntitySearch> searchs = ViewSearch.getByUse(search.user.getId().intValue());
        Collections.sort(searchs, new Comparator<EntitySearch>() {
            public final int compare(EntitySearch o1, EntitySearch o2) {
                return o1.use.compareTo(o2.use);
            }
        });

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public Void execute(javax.persistence.EntityManager manager) {
                manager.persist(search);
                while (searchs.size() > 10) {
                    manager.remove(searchs.remove(0));
                }
                return null;
            }
        });

    }

    public static Map<EntitySearchSource, List<Serializable>> execute(EntitySearch entitySearch) {
        if (entitySearch == null) throw new NullPointerException("Can't execute search by null!");

        Map results = new HashMap();
        for (EntitySearchSource entitySource : entitySearch.sources) {
            results.put(entitySource, new ArrayList());
        }

        Map rules = new HashMap();
        for (EntitySearchSource entitySource : entitySearch.sources) {
            LogicSearchRule logicRule = LogicSearchRuleFactory.get(entitySource.rule);
            if (logicRule != null) {
                rules.put(entitySource, logicRule);
            }
        }

        for (LogicSearchSource logicSearchSource : LogicSearchSourceFactory.create(entitySearch)) {
            logicSearchSource.get(results, rules);
        }
        return results;
    }

}