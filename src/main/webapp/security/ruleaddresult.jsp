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
        EntityRule rule = EntityManager.find(EntityRule.class, ruleId);
        if (rule == null) {
            rule = new EntityRule();
            rule.id = ruleId;
        }
        if (rule.contract == null) {
            rule.contract = new EntityRuleContract();
        }
        if ("statistic".equalsIgnoreCase(request.getParameter("rule"))) {
            rule.statistic = true;
        }
        if ("contractaccept".equalsIgnoreCase(request.getParameter("rule"))) {
            rule.contract.accept = true;
        }
        if ("contractcreate".equalsIgnoreCase(request.getParameter("rule"))) {
            rule.contract.create = true;
        }
        final EntityRule tempRule = rule;
        EntityManager.execute(new EntityTransaction() {

            public Object execute(javax.persistence.EntityManager manager) {
                manager.persist(tempRule);
                if (!tempRule.id.owner.rules.contains(tempRule)) {
                    tempRule.id.owner.rules.add(tempRule);
                }
                return null;
            }

        });
    }
    response.sendRedirect("/security/rule.jsp");
%>