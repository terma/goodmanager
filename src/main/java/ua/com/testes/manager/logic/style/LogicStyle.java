package ua.com.testes.manager.logic.style;

import ua.com.testes.manager.entity.EntityStyle;
import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.view.style.ViewStyle;

public final class LogicStyle {
    public static int create(String name, String description, boolean bold, boolean italy, boolean underline, boolean strikeout, int color, int userId) {

        EntityUser user = (EntityUser) ua.com.testes.manager.entity.EntityManager.find(EntityUser.class, Integer.valueOf(userId));

        if (user == null) throw new NullPointerException();

        final EntityStyle style = new EntityStyle();

        style.name = name;

        style.description = description;

        style.italic = italy;

        style.bold = bold;

        style.underline = underline;

        style.color = color;

        style.strikeout = strikeout;

        style.owner = user;

        if (style.description != null)
 style.description = style.description.trim();
        else {

            style.description = "";
        }

        if ((name == null) || (name.trim().length() == 0)) {

            style.name = "";

            throw new LogicStyleException(style, new LogicStyleError[]{LogicStyleError.NAME_EMPTY});
        }

        style.name = style.name.trim();

        if (!ViewStyle.getByName(style.name).isEmpty()) {

            throw new LogicStyleException(style, new LogicStyleError[]{LogicStyleError.NAME_NOT_UNIQUE});
        }

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {
            public Integer execute(javax.persistence.EntityManager manager) {

                manager.persist(style);

                return style.id;
            }
        });

        return style.id.intValue();
    }

    public static int edit(String name, String description, boolean bold, boolean italy, boolean underline, boolean strikeout, int color, int styleId, int userId) {

        EntityUser user = (EntityUser) ua.com.testes.manager.entity.EntityManager.find(EntityUser.class, Integer.valueOf(userId));

        if (user == null) {

            throw new NullPointerException();
        }

        EntityStyle style = (EntityStyle) ua.com.testes.manager.entity.EntityManager.find(EntityStyle.class, Integer.valueOf(styleId));

        if (style == null) {

            throw new NullPointerException();
        }

        if (user.getGroup().id.intValue() != 2) {

            throw new IllegalArgumentException();
        }

        boolean nameNotChange = style.name.equals(name);

        style.name = name;

        style.description = description;

        style.italic = italy;

        style.bold = bold;

        style.underline = underline;

        style.color = color;

        style.strikeout = strikeout;

        style.owner = user;

        if ((name == null) || (name.trim().length() == 0)) {

            throw new LogicStyleException(style, new LogicStyleError[]{LogicStyleError.NAME_EMPTY});
        }

        style.name = style.name.trim();

        if ((!nameNotChange) &&
       (!ViewStyle.getByName(style.name).isEmpty())) {

            throw new LogicStyleException(style, new LogicStyleError[]{LogicStyleError.NAME_NOT_UNIQUE});
        }


        if (style.description != null)
 style.description = style.description.trim();
        else {

            style.description = "";
        }

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {
            public Integer execute(javax.persistence.EntityManager manager) {

                return null;
            }
        });

        return style.id.intValue();
    }

    public static String getHtml(EntityStyle style, String text) {

        if (style == null) {

            return text;
        }

        StringBuffer buffer = new StringBuffer();

        if (style.bold) buffer.append("<b>");

        if (style.strikeout) buffer.append("<s>");

        if (style.italic) buffer.append("<i>");

        if (style.underline) buffer.append("<u>");

        buffer.append("<span style = \"color: #");

        buffer.append(Integer.toHexString(style.color));

        buffer.append("\">");

        buffer.append(text);

        buffer.append("</span>");

        if (style.underline) buffer.append("</u>");

        if (style.italic) buffer.append("</i>");

        if (style.strikeout) buffer.append("</s>");

        if (style.bold) buffer.append("</b>");

        return buffer.toString();
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.style.LogicStyle
 * JD-Core Version:    0.6.0
 */