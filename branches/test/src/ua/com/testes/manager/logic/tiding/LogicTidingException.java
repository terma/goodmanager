package ua.com.testes.manager.logic.tiding;


import ua.com.testes.manager.entity.tiding.EntityTiding;

import java.util.Collections;
import java.util.Set;


public class LogicTidingException extends RuntimeException {
    private final EntityTiding tiding;
    private final Set<LogicTidingError> errors;


    public LogicTidingException(EntityTiding tiding, LogicTidingError[] errorArray) {

        this.errors = Collections.unmodifiableSet(LogicTidingError.toSet(errorArray));

        this.tiding = tiding;

    }


    public EntityTiding getTiding() {

        return this.tiding;

    }


    public Set<LogicTidingError> getErrors() {

        return this.errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.tiding.LogicTidingException
 * JD-Core Version:    0.6.0
 */