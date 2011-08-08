package ua.com.testes.manager.logic.product;


import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.product.EntityProduct;
import ua.com.testes.manager.view.product.ViewCategory;
import ua.com.testes.manager.view.product.ViewProduct;


public final class LogicProduct {

    public static int add(String name, int userId, int categoryId, String description)
            throws LogicProductException {

        final EntityProduct product = new EntityProduct();

        if (name == null) {

            throw new LogicProductException(product, new LogicProductError[]{LogicProductError.NAME_EMPTY});

        }

        product.name = name.trim();

        if (product.name.length() == 0) {

            throw new LogicProductException(product, new LogicProductError[]{LogicProductError.NAME_EMPTY});

        }

        product.description = description;

        if (product.description == null) {

            product.description = "";

        }

        product.category = ViewCategory.getById(categoryId);

        product.category.products.add(product);

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public EntityProduct execute(javax.persistence.EntityManager manager) {

                ua.com.testes.manager.entity.EntityManager.get().persist(product);

                return product;

            }

        });

        return product.id.intValue();

    }


    public static void edit(String name, int productId, String description) throws LogicProductException {

        EntityProduct product = ViewProduct.getById(productId);

        if (product == null) {

            throw new IllegalArgumentException("Can't find product with id " + productId);

        }

        if (name == null) {

            throw new LogicProductException(product, new LogicProductError[]{LogicProductError.NAME_EMPTY});

        }

        product.name = name.trim();

        if (product.name.length() == 0) {

            throw new LogicProductException(product, new LogicProductError[]{LogicProductError.NAME_EMPTY});

        }

        product.description = description;

        if (product.description == null) {

            product.description = "";

        }

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public EntityProduct execute(javax.persistence.EntityManager manager) {

                return null;

            }

        });

    }


    public static void delete(int productId) throws LogicProductException {

        final EntityProduct product = ViewProduct.getById(productId);

        if (product == null) {

            throw new IllegalArgumentException("Can't find product with id " + productId);

        }

        product.category.products.remove(product);

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public Object execute(javax.persistence.EntityManager manager) {

                ua.com.testes.manager.entity.EntityManager.get().remove(product);

                return null;

            }

        });

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.LogicProduct
 * JD-Core Version:    0.6.0
 */