package ua.com.testes.manager.logic.style;


import java.util.HashSet;
import java.util.Set;


public enum LogicStyleError {
    /*  8 */   NAME_EMPTY, NAME_NOT_UNIQUE;


    public static Set<LogicStyleError> toSet(LogicStyleError[] errorArray) {

        Set errors = new HashSet(errorArray.length);

        for (LogicStyleError error : errorArray) {

            errors.add(error);

        }

        return errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.style.LogicStyleError
 * JD-Core Version:    0.6.0
 */