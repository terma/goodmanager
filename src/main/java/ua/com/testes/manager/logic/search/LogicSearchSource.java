package ua.com.testes.manager.logic.search;

import ua.com.testes.manager.entity.search.EntitySearchSource;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

abstract interface LogicSearchSource {
    public abstract void get(Map<EntitySearchSource, List<Serializable>> paramMap, Map<EntitySearchSource, LogicSearchRule> paramMap1);
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchSource
 * JD-Core Version:    0.6.0
 */