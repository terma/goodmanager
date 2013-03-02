package ua.com.testes.manager.logic.style;

import ua.com.testes.manager.entity.EntityStyle;
import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.view.style.ViewStyle;

public final class LogicStyle {
    public static int create(String name, String description, boolean bold, boolean italy, boolean underline, boolean strikeout, int color, int userId) {
/*  14 */
        EntityUser user = (EntityUser) ua.com.testes.manager.entity.EntityManager.find(EntityUser.class, Integer.valueOf(userId));
/*  15 */
        if (user == null) throw new NullPointerException();
/*  16 */
        final EntityStyle style = new EntityStyle();
/*  17 */
        style.name = name;
/*  18 */
        style.description = description;
/*  19 */
        style.italic = italy;
/*  20 */
        style.bold = bold;
/*  21 */
        style.underline = underline;
/*  22 */
        style.color = color;
/*  23 */
        style.strikeout = strikeout;
/*  24 */
        style.owner = user;
/*  25 */
        if (style.description != null)
/*  26 */ style.description = style.description.trim();
        else {
/*  28 */
            style.description = "";
        }
/*  30 */
        if ((name == null) || (name.trim().length() == 0)) {
/*  31 */
            style.name = "";
/*  32 */
            throw new LogicStyleException(style, new LogicStyleError[]{LogicStyleError.NAME_EMPTY});
        }
/*  34 */
        style.name = style.name.trim();
/*  35 */
        if (!ViewStyle.getByName(style.name).isEmpty()) {
/*  36 */
            throw new LogicStyleException(style, new LogicStyleError[]{LogicStyleError.NAME_NOT_UNIQUE});
        }
/*  38 */
        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {
            public Integer execute(javax.persistence.EntityManager manager) {
/*  41 */
                manager.persist(style);
/*  42 */
                return style.id;
            }
        });
/*  46 */
        return style.id.intValue();
    }

    public static int edit(String name, String description, boolean bold, boolean italy, boolean underline, boolean strikeout, int color, int styleId, int userId) {
/*  53 */
        EntityUser user = (EntityUser) ua.com.testes.manager.entity.EntityManager.find(EntityUser.class, Integer.valueOf(userId));
/*  54 */
        if (user == null) {
/*  55 */
            throw new NullPointerException();
        }
/*  57 */
        EntityStyle style = (EntityStyle) ua.com.testes.manager.entity.EntityManager.find(EntityStyle.class, Integer.valueOf(styleId));
/*  58 */
        if (style == null) {
/*  59 */
            throw new NullPointerException();
        }
/*  61 */
        if (user.getGroup().id.intValue() != 2) {
/*  62 */
            throw new IllegalArgumentException();
        }
/*  64 */
        boolean nameNotChange = style.name.equals(name);
/*  65 */
        style.name = name;
/*  66 */
        style.description = description;
/*  67 */
        style.italic = italy;
/*  68 */
        style.bold = bold;
/*  69 */
        style.underline = underline;
/*  70 */
        style.color = color;
/*  71 */
        style.strikeout = strikeout;
/*  72 */
        style.owner = user;
/*  73 */
        if ((name == null) || (name.trim().length() == 0)) {
/*  74 */
            throw new LogicStyleException(style, new LogicStyleError[]{LogicStyleError.NAME_EMPTY});
        }
/*  76 */
        style.name = style.name.trim();
/*  77 */
        if ((!nameNotChange) &&
/*  78 */       (!ViewStyle.getByName(style.name).isEmpty())) {
/*  79 */
            throw new LogicStyleException(style, new LogicStyleError[]{LogicStyleError.NAME_NOT_UNIQUE});
        }

/*  82 */
        if (style.description != null)
/*  83 */ style.description = style.description.trim();
        else {
/*  85 */
            style.description = "";
        }
/*  87 */
        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {
            public Integer execute(javax.persistence.EntityManager manager) {
/*  90 */
                return null;
            }
        });
/*  94 */
        return style.id.intValue();
    }

    public static String getHtml(EntityStyle style, String text) {
/*  98 */
        if (style == null) {
/*  99 */
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