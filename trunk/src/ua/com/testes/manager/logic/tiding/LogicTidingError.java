package ua.com.testes.manager.logic.tiding;


import java.util.HashSet;
import java.util.Set;


public enum LogicTidingError {
    /*  8 */   NAME_EMPTY, CATEGORY_NOT_SET;


    public static Set<LogicTidingError> toSet(LogicTidingError[] errorArray) {

        Set errors = new HashSet(errorArray.length);

        for (LogicTidingError error : errorArray) {

            errors.add(error);

        }

        return errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.tiding.LogicTidingError
 * JD-Core Version:    0.6.0
 */