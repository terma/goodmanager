package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.search.*;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;


class LogicSearchRuleFactory {
    private static final Map<Class, Class> registered = new HashMap();

    static {
        registered(LogicSearchRulePipolComposite.class, EntitySearchRulePipolComposite.class);
        registered(LogicSearchRulePipolFio.class, EntitySearchRulePipolFio.class);
        registered(LogicSearchRulePipolOther.class, EntitySearchRulePipolOther.class);
        registered(LogicSearchRulePipolUser.class, EntitySearchRulePipolUser.class);
        registered(LogicSearchRulePipolDelete.class, EntitySearchRulePipolDelete.class);
        registered(LogicSearchRulePipolCreate.class, EntitySearchRulePipolCreate.class);
        registered(LogicSearchRuleFirmComposite.class, EntitySearchRuleFirmComposite.class);
        registered(LogicSearchRuleFirmName.class, EntitySearchRuleFirmName.class);
        registered(LogicSearchRuleFirmOther.class, EntitySearchRuleFirmOther.class);
        registered(LogicSearchRuleFirmUser.class, EntitySearchRuleFirmUser.class);
        registered(LogicSearchRuleFirmSection.class, EntitySearchRuleFirmSection.class);
        registered(LogicSearchRuleFirmCreate.class, EntitySearchRuleFirmCreate.class);
        registered(LogicSearchRuleFirmDelete.class, EntitySearchRuleFirmDelete.class);
        registered(LogicSearchRuleContactComposite.class, EntitySearchRuleContactComposite.class);
        registered(LogicSearchRuleContactCreate.class, EntitySearchRuleContactCreate.class);
        registered(LogicSearchRuleContactDelete.class, EntitySearchRuleContactDelete.class);
        registered(LogicSearchRuleContactDescription.class, EntitySearchRuleContactDescription.class);
        registered(LogicSearchRuleContactRepeat.class, EntitySearchRuleContactRepeat.class);
        registered(LogicSearchRuleContactUser.class, EntitySearchRuleContactUser.class);
        registered(LogicSearchRuleContactStatus.class, EntitySearchRuleContactStatus.class);
    }

    public static void registered(Class logicSearchRule, Class entitySearchRule) {

        registered.put(entitySearchRule, logicSearchRule);

    }

    public static LogicSearchRule get(EntitySearchRule entityRule) {

        Class logicRuleClass = (Class) registered.get(entityRule.getClass());

        if (logicRuleClass != null) {

            try {

                Constructor constructor = logicRuleClass.getDeclaredConstructor(new Class[]{EntitySearchRule.class});


                return (LogicSearchRule) constructor.newInstance(new Object[]{entityRule});

            } catch (InstantiationException exception) {

                throw new RuntimeException(exception);

            } catch (IllegalAccessException exception) {

                throw new RuntimeException(exception);

            } catch (NoSuchMethodException exception) {

                throw new RuntimeException(exception);

            } catch (InvocationTargetException exception) {

                throw new RuntimeException(exception);

            }

        }

        throw new IllegalArgumentException("Can't find rule by entity rule " + entityRule);

    }

}