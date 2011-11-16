package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.*;
import ua.com.testes.manager.entity.search.*;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


final class LogicSearchSourceFirmPipolContact implements LogicSearchSource {

    public void get(Map<EntitySearchSource, List<Serializable>> results, Map<EntitySearchSource, LogicSearchRule> rules) {

        boolean firmDeleteUse = false;

        boolean contactDeleteUse = false;

        boolean pipolDeleteUse = false;

        EntitySearchSource sourceFirm = null;

        EntitySearchSource sourcePipol = null;

        EntitySearchSource sourceContact = null;

        LogicSearchRule ruleContact = null;

        LogicSearchRule rulePipol = null;

        LogicSearchRule ruleFirm = null;

        for (EntitySearchSource entitySource : results.keySet()) {

            if ((entitySource instanceof EntitySearchSourceContact)) {

                sourceContact = entitySource;

                ruleContact = (LogicSearchRule) rules.get(sourceContact);

            } else if ((entitySource instanceof EntitySearchSourceContactWithDelete)) {

                contactDeleteUse = true;

                sourceContact = entitySource;

                ruleContact = rules.get(sourceContact);

            } else if ((entitySource instanceof EntitySearchSourceFirm)) {

                sourceFirm = entitySource;

                ruleFirm = rules.get(sourceFirm);

            } else if ((entitySource instanceof EntitySearchSourceFirmWithDelete)) {

                firmDeleteUse = true;

                sourceFirm = entitySource;

                ruleFirm = rules.get(sourceFirm);

            } else if ((entitySource instanceof EntitySearchSourcePipol)) {

                sourcePipol = entitySource;

                rulePipol = rules.get(sourcePipol);

            } else if ((entitySource instanceof EntitySearchSourcePipolWithDelete)) {

                pipolDeleteUse = true;

                sourcePipol = entitySource;

                rulePipol = rules.get(sourcePipol);

            }

        }


        List resultContacts = new ArrayList();

        List resultPipols = new ArrayList();

        List resultFirms = new ArrayList();


        List<EntitySection> sections = EntityManager.list("select section from ua.com.testes.manager.entity.EntitySection as section", new Object[0]);


        for (EntitySection section : sections) {

            for (EntityFirm firm : section.getFirms()) {

                if ((firmDeleteUse) || (firm.getDelete() == null)) {

                    if ((sourceFirm != null) && (
                            (ruleFirm == null) || (ruleFirm.accept(firm)))) {

                        resultFirms.add(firm);

                    }


                    if ((sourcePipol != null) || (sourceContact != null)) {

                        for (EntityPipol pipol : firm.getPipols()) {

                            if ((pipolDeleteUse) || (pipol.getDelete() == null)) {

                                if ((sourcePipol != null) && (
                                        (rulePipol == null) || (rulePipol.accept(pipol)))) {

                                    resultPipols.add(pipol);

                                }


                                if (sourceContact != null) {

                                    for (EntityContact contact : pipol.getContacts())

                                        if ((contactDeleteUse) || (contact.delete == null))
                                            if ((ruleContact == null) || (ruleContact.accept(contact)))
                                                resultContacts.add(contact);

                                }

                            }

                        }

                    }

                }

            }

        }

        results.put(sourceFirm, resultFirms);

        results.put(sourceContact, resultContacts);

        results.put(sourcePipol, resultPipols);

    }

}