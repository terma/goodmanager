<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.search.*" %>
<%@ page import="ua.com.testes.manager.logic.search.LogicSearch" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));

    final EntitySearchRuleFirmComposite ruleFirmAnd = new EntitySearchRuleFirmComposite();
    ruleFirmAnd.type = EntitySearchRuleFirmComposite.Type.AND;

    final EntitySearchRulePipolComposite rulePipolAnd = new EntitySearchRulePipolComposite();
    rulePipolAnd.type = EntitySearchRulePipolComposite.Type.AND;
    ruleFirmAnd.addRule(rulePipolAnd);

    final EntitySearchRuleContactComposite ruleContactAnd = new EntitySearchRuleContactComposite();
    ruleContactAnd.type = EntitySearchRuleContactComposite.Type.AND;
    rulePipolAnd.addRule(ruleContactAnd);

    final EntitySearchRuleFirmName ruleFirmName = new EntitySearchRuleFirmName();
    ruleFirmName.name = request.getParameter("firmname");
    if (!ruleFirmName.name.trim().isEmpty()) {
        ruleFirmAnd.addRule(ruleFirmName);
    }

    final EntitySearchRuleFirmOther ruleFirmOther = new EntitySearchRuleFirmOther();
    ruleFirmOther.text = request.getParameter("firmother");
    if (!ruleFirmOther.text.trim().isEmpty()) {
        ruleFirmAnd.addRule(ruleFirmOther);
    }

    final EntitySearchRulePipolOther rulePipolOther = new EntitySearchRulePipolOther();
    rulePipolOther.text = request.getParameter("pipolother");
    if (!rulePipolOther.text.trim().isEmpty()) {
        rulePipolAnd.addRule(rulePipolOther);
    }

    final EntitySearchRulePipolFio rulePipolFio = new EntitySearchRulePipolFio();
    rulePipolFio.fio = request.getParameter("pipolfio");
    if (!rulePipolFio.fio.trim().isEmpty()) {
        rulePipolAnd.addRule(rulePipolFio);
    }

    final EntitySearchRuleContactDescription ruleContactDescription = new EntitySearchRuleContactDescription();
    ruleContactDescription.description = request.getParameter("contactdescription");
    if (!ruleContactDescription.description.trim().isEmpty()) {
        ruleContactAnd.addRule(ruleContactDescription);
    }

    // Если нужно отрабатывать дату создание фирмы
    if (request.getParameter("firmcreatestart") != null || request.getParameter("firmcreatefinish") != null) {
        GregorianCalendar calendar = new GregorianCalendar();
        try {
            final EntitySearchRuleFirmCreate ruleFirmCreate = new EntitySearchRuleFirmCreate();
            if (request.getParameter("firmcreatestart") != null) {
                int startYear = Integer.parseInt(request.getParameter("firmcreatestartyear"));
                int startMonth = Integer.parseInt(request.getParameter("firmcreatestartmonth"));
                int startDay = Integer.parseInt(request.getParameter("firmcreatestartday"));
                calendar.set(startYear, startMonth, startDay, 0, 0, 0);
                ruleFirmCreate.start = calendar.getTime();
            }
            if (request.getParameter("firmcreatefinish") != null) {
                int finishYear = Integer.parseInt(request.getParameter("firmcreatefinishyear"));
                int finishMonth = Integer.parseInt(request.getParameter("firmcreatefinishmonth"));
                int finishDay = Integer.parseInt(request.getParameter("firmcreatefinishday"));
                calendar.set(finishYear, finishMonth, finishDay, 0, 0, 0);
                ruleFirmCreate.finish = calendar.getTime();
            }
            ruleFirmAnd.addRule(ruleFirmCreate);
        } catch (Exception exception) {
        }
    }

    // Если нужно отрабатывать дату удаления фирмы
    if (request.getParameter("firmdeletestart") != null || request.getParameter("firmdeletefinish") != null) {
        GregorianCalendar calendar = new GregorianCalendar();
        try {
            final EntitySearchRuleFirmDelete ruleFirmDelete = new EntitySearchRuleFirmDelete();
            if (request.getParameter("firmdeletestart") != null) {
                int startYear = Integer.parseInt(request.getParameter("firmdeletestartyear"));
                int startMonth = Integer.parseInt(request.getParameter("firmdeletestartmonth"));
                int startDay = Integer.parseInt(request.getParameter("firmdeletestartday"));
                calendar.set(startYear, startMonth, startDay, 0, 0, 0);
                ruleFirmDelete.start = calendar.getTime();
            }
            if (request.getParameter("firmdeletefinish") != null) {
                int finishYear = Integer.parseInt(request.getParameter("firmdeletefinishyear"));
                int finishMonth = Integer.parseInt(request.getParameter("firmdeletefinishmonth"));
                int finishDay = Integer.parseInt(request.getParameter("firmdeletefinishday"));
                calendar.set(finishYear, finishMonth, finishDay, 0, 0, 0);
                ruleFirmDelete.finish = calendar.getTime();
            }
            ruleFirmAnd.addRule(ruleFirmDelete);
        } catch (Exception exception) {
        }
    }

    // Если нужно отрабатывать дату создание сотрудника
    if (request.getParameter("pipolcreatestart") != null || request.getParameter("pipolcreatefinish") != null) {
        GregorianCalendar calendar = new GregorianCalendar();
        try {
            final EntitySearchRulePipolCreate rulePipolCreate = new EntitySearchRulePipolCreate();
            if (request.getParameter("pipolcreatestart") != null) {
                int startYear = Integer.parseInt(request.getParameter("pipolcreatestartyear"));
                int startMonth = Integer.parseInt(request.getParameter("pipolcreatestartmonth"));
                int startDay = Integer.parseInt(request.getParameter("pipolcreatestartday"));
                calendar.set(startYear, startMonth, startDay, 0, 0, 0);
                rulePipolCreate.start = calendar.getTime();
            }
            if (request.getParameter("pipolcreatefinish") != null) {
                int finishYear = Integer.parseInt(request.getParameter("pipolcreatefinishyear"));
                int finishMonth = Integer.parseInt(request.getParameter("pipolcreatefinishmonth"));
                int finishDay = Integer.parseInt(request.getParameter("pipolcreatefinishday"));
                calendar.set(finishYear, finishMonth, finishDay, 0, 0, 0);
                rulePipolCreate.finish = calendar.getTime();
            }
            rulePipolAnd.addRule(rulePipolCreate);
        } catch (Exception exception) {
        }
    }

    // Если нужно отрабатывать дату удаления сотрудника
    if (request.getParameter("pipoldeletestart") != null || request.getParameter("pipoldeletefinish") != null) {
        GregorianCalendar calendar = new GregorianCalendar();
        try {
            final EntitySearchRulePipolDelete rulePipolDelete = new EntitySearchRulePipolDelete();
            if (request.getParameter("pipoldeletestart") != null) {
                int startYear = Integer.parseInt(request.getParameter("pipoldeletestartyear"));
                int startMonth = Integer.parseInt(request.getParameter("pipoldeletestartmonth"));
                int startDay = Integer.parseInt(request.getParameter("pipoldeletestartday"));
                calendar.set(startYear, startMonth, startDay, 0, 0, 0);
                rulePipolDelete.start = calendar.getTime();
            }
            if (request.getParameter("pipoldeletefinish") != null) {
                int finishYear = Integer.parseInt(request.getParameter("pipoldeletefinishyear"));
                int finishMonth = Integer.parseInt(request.getParameter("pipoldeletefinishmonth"));
                int finishDay = Integer.parseInt(request.getParameter("pipoldeletefinishday"));
                calendar.set(finishYear, finishMonth, finishDay, 0, 0, 0);
                rulePipolDelete.finish = calendar.getTime();
            }
            rulePipolAnd.addRule(rulePipolDelete);
        } catch (Exception exception) {
        }
    }

    // Если нужно отрабатывать дату создание контакта
    if (request.getParameter("contactcreatestart") != null || request.getParameter("contactcreatefinish") != null) {
        GregorianCalendar calendar = new GregorianCalendar();
        try {
            final EntitySearchRuleContactCreate ruleContactCreate = new EntitySearchRuleContactCreate();
            if (request.getParameter("contactcreatestart") != null) {
                int startYear = Integer.parseInt(request.getParameter("contactcreatestartyear"));
                int startMonth = Integer.parseInt(request.getParameter("contactcreatestartmonth"));
                int startDay = Integer.parseInt(request.getParameter("contactcreatestartday"));
                calendar.set(startYear, startMonth, startDay, 0, 0, 0);
                ruleContactCreate.start = calendar.getTime();
            }
            if (request.getParameter("contactcreatefinish") != null) {
                int finishYear = Integer.parseInt(request.getParameter("contactcreatefinishyear"));
                int finishMonth = Integer.parseInt(request.getParameter("contactcreatefinishmonth"));
                int finishDay = Integer.parseInt(request.getParameter("contactcreatefinishday"));
                calendar.set(finishYear, finishMonth, finishDay, 0, 0, 0);
                ruleContactCreate.finish = calendar.getTime();
            }
            ruleContactAnd.addRule(ruleContactCreate);
        } catch (Exception exception) {
        }
    }

    // Если нужно отрабатывать дату удаления контакта
    if (request.getParameter("contactdeletestart") != null || request.getParameter("contactdeletefinish") != null) {
        GregorianCalendar calendar = new GregorianCalendar();
        try {
            final EntitySearchRuleContactDelete ruleContactDelete = new EntitySearchRuleContactDelete();
            if (request.getParameter("contactdeletestart") != null) {
                int startYear = Integer.parseInt(request.getParameter("contactdeletestartyear"));
                int startMonth = Integer.parseInt(request.getParameter("contactdeletestartmonth"));
                int startDay = Integer.parseInt(request.getParameter("contactdeletestartday"));
                calendar.set(startYear, startMonth, startDay, 0, 0, 0);
                ruleContactDelete.start = calendar.getTime();
            }
            if (request.getParameter("contactdeletefinish") != null) {
                int finishYear = Integer.parseInt(request.getParameter("contactdeletefinishyear"));
                int finishMonth = Integer.parseInt(request.getParameter("contactdeletefinishmonth"));
                int finishDay = Integer.parseInt(request.getParameter("contactdeletefinishday"));
                calendar.set(finishYear, finishMonth, finishDay, 0, 0, 0);
                ruleContactDelete.finish = calendar.getTime();
            }
            ruleContactAnd.addRule(ruleContactDelete);
        } catch (Exception exception) {
        }
    }

    // Если нужно отрабатывать дату повтора контакта
    if (request.getParameter("contactrepeatstart") != null || request.getParameter("contactrepeatfinish") != null) {
        GregorianCalendar calendar = new GregorianCalendar();
        try {
            final EntitySearchRuleContactRepeat ruleContactRepeat = new EntitySearchRuleContactRepeat();
            if (request.getParameter("contactrepeatstart") != null) {
                int startYear = Integer.parseInt(request.getParameter("contactrepeatstartyear"));
                int startMonth = Integer.parseInt(request.getParameter("contactrepeatstartmonth"));
                int startDay = Integer.parseInt(request.getParameter("contactrepeatstartday"));
                calendar.set(startYear, startMonth, startDay, 0, 0, 0);
                ruleContactRepeat.start = calendar.getTime();
            }
            if (request.getParameter("contactrepeatfinish") != null) {
                int finishYear = Integer.parseInt(request.getParameter("contactrepeatfinishyear"));
                int finishMonth = Integer.parseInt(request.getParameter("contactrepeatfinishmonth"));
                int finishDay = Integer.parseInt(request.getParameter("contactrepeatfinishday"));
                calendar.set(finishYear, finishMonth, finishDay, 0, 0, 0);
                ruleContactRepeat.finish = calendar.getTime();
            }
            ruleContactAnd.addRule(ruleContactRepeat);
        } catch (Exception exception) {
        }
    }

    // Смотрим нужен ли фильтр по пользователям для фирм
    final String[] userStringIds = request.getParameterValues("firmuser");
    if (userStringIds != null && userStringIds.length > 0) {
        final EntitySearchRuleFirmUser ruleFirmUser = new EntitySearchRuleFirmUser();
        for (final String userStringId : userStringIds) {
            try {
                final EntitySearchRuleFirmUserItem firmRuleUserItem = new EntitySearchRuleFirmUserItem();
                firmRuleUserItem.id.userId = Integer.parseInt(userStringId);
                firmRuleUserItem.id.rule = ruleFirmUser;
                ruleFirmUser.items.add(firmRuleUserItem);
            } catch (NumberFormatException exception) {
            }
        }
        ruleFirmAnd.rules.add(ruleFirmUser);
        ruleFirmUser.parent = ruleFirmAnd;
    }

    // Смотрим нужен ли фильтр по пользователям для сотрудников
    final String[] pipolUserStringIds = request.getParameterValues("pipoluser");
    if (pipolUserStringIds != null && pipolUserStringIds.length > 0) {
        final EntitySearchRulePipolUser rulePipolUser = new EntitySearchRulePipolUser();
        for (final String pipolUserStringId : pipolUserStringIds) {
            try {
                final EntitySearchRulePipolUserItem pipolRuleUserItem = new EntitySearchRulePipolUserItem();
                pipolRuleUserItem.id.userId = Integer.parseInt(pipolUserStringId);
                pipolRuleUserItem.id.rule = rulePipolUser;
                rulePipolUser.items.add(pipolRuleUserItem);
            } catch (NumberFormatException exception) {
            }
        }
        rulePipolAnd.addRule(rulePipolUser);
    }

    // Смотрим нужен ли фильтр по пользователям для контактам
    final String[] contactUserStringIds = request.getParameterValues("contactuser");
    if (contactUserStringIds != null && contactUserStringIds.length > 0) {
        final EntitySearchRuleContactUser ruleContactUser = new EntitySearchRuleContactUser();
        for (final String contactUserStringId : contactUserStringIds) {
            try {
                final EntitySearchRuleContactUserItem contactRuleUserItem = new EntitySearchRuleContactUserItem();
                contactRuleUserItem.id.userId = Integer.parseInt(contactUserStringId);
                contactRuleUserItem.id.rule = ruleContactUser;
                ruleContactUser.items.add(contactRuleUserItem);
            } catch (NumberFormatException exception) {
            }
        }
        ruleContactAnd.addRule(ruleContactUser);
    }

    // Смотрим нужен ли фильтр по статусу для контактов
    final String[] contactStatusStringIds = request.getParameterValues("contactstatus");
    if (contactStatusStringIds != null && contactStatusStringIds.length > 0) {
        final EntitySearchRuleContactStatus ruleContactStatus = new EntitySearchRuleContactStatus();
        for (final String contactUserStringId : contactStatusStringIds) {
            try {
                final EntitySearchRuleContactStatusItem contactRuleStatusItem = new EntitySearchRuleContactStatusItem();
                contactRuleStatusItem.id.statusId = Integer.parseInt(contactUserStringId);
                contactRuleStatusItem.id.rule = ruleContactStatus;
                ruleContactStatus.items.add(contactRuleStatusItem);
            } catch (NumberFormatException exception) {
            }
        }
        ruleContactAnd.addRule(ruleContactStatus);
    }

    final String[] sectionStringIds = request.getParameterValues("firmsection");
    if (sectionStringIds != null && sectionStringIds.length > 0) {
        final EntitySearchRuleFirmSection ruleFirmSection = new EntitySearchRuleFirmSection();
        for (final String sectionStringId : sectionStringIds) {
            try {
                final EntitySearchRuleFirmSectionItem firmRuleSectionItem = new EntitySearchRuleFirmSectionItem();
                firmRuleSectionItem.id.sectionId = Integer.parseInt(sectionStringId);
                firmRuleSectionItem.id.rule = ruleFirmSection;
                ruleFirmSection.items.add(firmRuleSectionItem);
            } catch (NumberFormatException exception) {
            }
        }
        ruleFirmAnd.rules.add(ruleFirmSection);
        ruleFirmSection.parent = ruleFirmAnd;
    }

    EntitySearchSource sourceFirm;
    if (request.getParameter("firmdelete") != null) {
        sourceFirm = new EntitySearchSourceFirmWithDelete();
    } else {
        sourceFirm = new EntitySearchSourceFirm();
    }
    sourceFirm.rule = ruleFirmAnd;
    ruleFirmAnd.source = sourceFirm;

    final EntitySearch search = new EntitySearch();
    search.sources.add(sourceFirm);
    search.user = user;
    sourceFirm.search = search;
    LogicSearch.create(search);
    response.sendRedirect("/security/search/searchadvanceresult.jsp?searchId=" + search.id);
%>