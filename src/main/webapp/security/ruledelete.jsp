<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id == 2) {
        final int dependGroupId = Integer.parseInt(request.getParameter("dependGroupId"));
        final int ownerGroupId = Integer.parseInt(request.getParameter("ownerGroupId"));
        final EntityRuleKey ruleId = new EntityRuleKey();
        ruleId.depend = EntityManager.find(EntityGroup.class, dependGroupId);
        ruleId.owner = EntityManager.find(EntityGroup.class, ownerGroupId);
        final EntityRule rule = EntityManager.find(EntityRule.class, ruleId);
        final String ruleString = request.getParameter("rule");
        if ("statistic".equalsIgnoreCase(ruleString)) {
            rule.statistic = false;
        }
        if ("contractaccept".equalsIgnoreCase(ruleString)) {
            rule.contract.accept = false;
        }
        if ("contractcreate".equalsIgnoreCase(ruleString)) {
            rule.contract.create = false;
        }
        if (rule != null) {
            EntityManager.execute(new EntityTransaction() {

                public Object execute(javax.persistence.EntityManager manager) {
                    manager.persist(rule);
                    return null;
                }

            });
        }
    }
    response.sendRedirect("/security/rule.jsp");
%>