package ua.com.testes.manager.logic.activeX1c.product.storage;


import com.jacob.activeX.ActiveXComponent;
import com.jacob.com.Variant;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.logic.activeX1c.LogicActiveX1c;
import ua.com.testes.manager.util.activex1c.UtilActiveX1cTransaction;

import java.util.ArrayList;
import java.util.List;


public class LogicActiveX1cProductStorageManager {

    public static List<LogicActiveX1cProductStorage> getByCategory(EntityUser user, final String categoryId) {

        final List logicActiveX1cProductStorages = new ArrayList();


        LogicActiveX1c.execute(user, new UtilActiveX1cTransaction() {

            public void execute(ActiveXComponent activeX1cComponent) {

                Variant productStorages = activeX1cComponent.invoke("getProductStorageByCategory", new Variant(categoryId));

                try {

                    ActiveXComponent productStoragesComponent = new ActiveXComponent(productStorages.getDispatch());

                    try {

                        int productStorageCount = Integer.parseInt(productStoragesComponent.invoke("LinesCnt").toString());


                        for (int i = 1; i <= productStorageCount; i++) {

                            productStoragesComponent.invoke("getLineByNumber", new Variant(i));

                            LogicActiveX1cProductStorage logicActiveX1cProductStorage = new LogicActiveX1cProductStorage();


                            logicActiveX1cProductStorage.productName = productStoragesComponent.getProperty("productName").getString();


                            logicActiveX1cProductStorage.productCount = Integer.parseInt(productStoragesComponent.getProperty("productCount").toString());


                            logicActiveX1cProductStorage.productCountReserved = Integer.parseInt(productStoragesComponent.getProperty("productCountReserved").toString());

                            logicActiveX1cProductStorages.add(logicActiveX1cProductStorage);

                        }

                    } finally {

                        productStoragesComponent.safeRelease();

                    }

                } finally {

                    productStorages.safeRelease();

                }

            }

        });

        return logicActiveX1cProductStorages;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.activeX1c.product.storage.LogicActiveX1cProductStorageManager
 * JD-Core Version:    0.6.0
 */