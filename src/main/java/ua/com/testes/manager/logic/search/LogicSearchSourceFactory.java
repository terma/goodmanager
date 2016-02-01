package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.search.*;

import java.util.*;


final class LogicSearchSourceFactory {

    private static final Map<Class, Class> registered = new HashMap();

    static {
        registered(LogicSearchSourceFirmPipolContact.class, EntitySearchSourceFirm.class);
        registered(LogicSearchSourceFirmPipolContact.class, EntitySearchSourcePipol.class);
        registered(LogicSearchSourceFirmPipolContact.class, EntitySearchSourceContact.class);
        registered(LogicSearchSourceFirmPipolContact.class, EntitySearchSourceFirmWithDelete.class);
        registered(LogicSearchSourceFirmPipolContact.class, EntitySearchSourcePipolWithDelete.class);
        registered(LogicSearchSourceFirmPipolContact.class, EntitySearchSourceContactWithDelete.class);
    }

    public static void registered(Class logicSource, Class entitySource) {
        registered.put(entitySource, logicSource);
    }

    public static Collection<LogicSearchSource> create(EntitySearch entitySearch) {
        if (entitySearch == null) throw new NullPointerException();
        Set logicSources = new HashSet();
        Set logicSourceClasses = new HashSet();
        for (EntitySearchSource entitySource : entitySearch.sources) {
            LogicSearchSource logicSource = instance(entitySource);
            if (!logicSourceClasses.contains(logicSource.getClass())) {
                logicSourceClasses.add(logicSource.getClass());
                logicSources.add(logicSource);
            }
        }
        return logicSources;
    }

    private static LogicSearchSource instance(EntitySearchSource entitySource) {
        Class logicSourceClass = (Class) registered.get(entitySource.getClass());
        if (logicSourceClass != null) {
            try {
                return (LogicSearchSource) logicSourceClass.newInstance();
            } catch (InstantiationException exception) {
                throw new RuntimeException(exception);
            } catch (IllegalAccessException exception) {
                throw new RuntimeException(exception);
            }
        }
        throw new IllegalArgumentException("Can't find logic class for entity source " + entitySource);
    }

}