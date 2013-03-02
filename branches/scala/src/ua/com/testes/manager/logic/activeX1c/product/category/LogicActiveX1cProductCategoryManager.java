package ua.com.testes.manager.logic.activeX1c.product.category;


import com.jacob.activeX.ActiveXComponent;
import com.jacob.com.Variant;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.logic.activeX1c.LogicActiveX1c;
import ua.com.testes.manager.util.activex1c.UtilActiveX1cTransaction;

import java.util.ArrayList;
import java.util.List;


public class LogicActiveX1cProductCategoryManager {

    public static List<LogicActiveX1cProductCategory> getRoot(EntityUser user) {

        final List logicActiveX1cProductCategories = new ArrayList();


        LogicActiveX1c.execute(user, new UtilActiveX1cTransaction() {

            public void execute(ActiveXComponent activeX1cComponent) {

                Variant categorys = activeX1cComponent.invoke("getCategoryRoot");

                try {

                    ActiveXComponent categorysComponent = new ActiveXComponent(categorys.getDispatch());

                    try {

                        int categoryCount = Integer.parseInt(categorysComponent.invoke("LinesCnt").toString());


                        for (int i = 1; i <= categoryCount; i++) {

                            categorysComponent.invoke("getLineByNumber", new Variant(i));

                            LogicActiveX1cProductCategory logicActiveX1cProductCategory = new LogicActiveX1cProductCategory();


                            logicActiveX1cProductCategory.categoryName = categorysComponent.getProperty("categoryName").getString();


                            logicActiveX1cProductCategory.categoryId = categorysComponent.getProperty("categoryId").getString();


                            logicActiveX1cProductCategories.add(logicActiveX1cProductCategory);

                        }

                    } finally {

                        categorysComponent.safeRelease();

                    }

                } finally {

                    categorys.safeRelease();

                }

            }

        });

        return logicActiveX1cProductCategories;

    }


    public static List<LogicActiveX1cProductCategory> getByCategory(EntityUser user, final String categoryId) {

        final List logicActiveX1cProductCategories = new ArrayList();


        LogicActiveX1c.execute(user, new UtilActiveX1cTransaction() {

            public void execute(ActiveXComponent activeX1cComponent) {

                Variant categorys = activeX1cComponent.invoke("getCategoryByCategory", new Variant(categoryId));

                try {

                    ActiveXComponent categorysComponent = new ActiveXComponent(categorys.getDispatch());

                    try {

                        int categoryCount = Integer.parseInt(categorysComponent.invoke("LinesCnt").toString());


                        for (int i = 1; i <= categoryCount; i++) {

                            categorysComponent.invoke("getLineByNumber", new Variant(i));

                            LogicActiveX1cProductCategory logicActiveX1cProductCategory = new LogicActiveX1cProductCategory();


                            logicActiveX1cProductCategory.categoryName = categorysComponent.getProperty("categoryName").getString();


                            logicActiveX1cProductCategory.categoryId = categorysComponent.getProperty("categoryId").getString();

                            logicActiveX1cProductCategories.add(logicActiveX1cProductCategory);

                        }

                    } finally {

                        categorysComponent.safeRelease();

                    }

                } finally {

                    categorys.safeRelease();

                }

            }

        });

        return logicActiveX1cProductCategories;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.activeX1c.product.category.LogicActiveX1cProductCategoryManager
 * JD-Core Version:    0.6.0
 */