package ua.com.testes.manager.logic.style;


import ua.com.testes.manager.entity.EntityStyle;

import java.util.Collections;
import java.util.Set;


public class LogicStyleException extends RuntimeException {
    public final Set<LogicStyleError> errors;
    public final String name;
    public final String description;
    public final boolean bold;
    public final boolean italy;
    public final boolean underline;
    public final boolean strukeout;
    public final int color;


    public LogicStyleException(EntityStyle style, LogicStyleError[] errorArray) {

        this.errors = Collections.unmodifiableSet(LogicStyleError.toSet(errorArray));

        this.bold = style.bold;

        this.underline = style.underline;

        this.strukeout = style.strikeout;

        this.italy = style.italic;

        this.color = style.color;

        this.name = style.name;

        this.description = style.description;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.style.LogicStyleException
 * JD-Core Version:    0.6.0
 */