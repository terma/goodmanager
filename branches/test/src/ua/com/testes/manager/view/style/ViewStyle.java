package ua.com.testes.manager.view.style;


import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.EntityStyle;

import java.util.List;


public final class ViewStyle {

    public static List<EntityStyle> getByName(String styleName) {

        return EntityManager.list("select style from styles as style where style.name = :p0", new Object[]{styleName});

    }


    public static EntityStyle getById(int styleId) {

        return (EntityStyle) EntityManager.find(EntityStyle.class, Integer.valueOf(styleId));

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.view.style.ViewStyle
 * JD-Core Version:    0.6.0
 */