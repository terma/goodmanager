package ua.com.testes.manager.logic.task;


import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.task.EntityTask;
import ua.com.testes.manager.entity.task.EntityTaskExecutor;
import ua.com.testes.manager.entity.user.EntityUser;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public class LogicTask {

    public static List<EntityTask> getForExecute(int userId) {

        List<EntityTaskExecutor> executors = ua.com.testes.manager.entity.EntityManager.list("select executor from task_executors as executor where executor.user.userId = :p0", new Object[]{Integer.valueOf(userId)});


        List tasks = new ArrayList();

        for (EntityTaskExecutor executor : executors) {

            tasks.add(executor.task);

        }

        return tasks;

    }


    public static EntityTask get(int userId, int taskId) {

        return (EntityTask) ua.com.testes.manager.entity.EntityManager.find(EntityTask.class, Integer.valueOf(taskId));

    }


    public static EntityTask create(int userId, String name, String description, List<Integer> executorIds, List<Date> executorMusts) {

        final EntityTask task = new EntityTask();

        task.name = name;

        task.owner = ((EntityUser) ua.com.testes.manager.entity.EntityManager.find(EntityUser.class, Integer.valueOf(userId)));

        task.description = description;

        int i = 0;

        for (Integer executorId : executorIds) {

            EntityTaskExecutor executor = new EntityTaskExecutor();

            executor.task = task;

            executor.user = ((EntityUser) ua.com.testes.manager.entity.EntityManager.find(EntityUser.class, executorId));

            executor.must = ((Date) executorMusts.get(i));

            task.executors.add(executor);

            i++;

        }

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public EntityTask execute(javax.persistence.EntityManager manager) {

                ua.com.testes.manager.entity.EntityManager.get().persist(task);

                return task;

            }

        });

        return task;

    }


    public static void accept(final int userId, final int taskId, final String description) {

        final EntityTask task = (EntityTask) ua.com.testes.manager.entity.EntityManager.find(EntityTask.class, Integer.valueOf(taskId));

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public Void execute(javax.persistence.EntityManager manager) {

                for (EntityTaskExecutor executor : task.executors) {

                    if (executor.user.getId().intValue() == userId) {

                        executor.accept = new Date();

                        executor.description = description;

                    }

                }

                return null;

            }

        });

    }


    public static void delete(int userId, int taskId) {

        final EntityTask task = (EntityTask) ua.com.testes.manager.entity.EntityManager.find(EntityTask.class, Integer.valueOf(taskId));

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public Void execute(javax.persistence.EntityManager manager) {

                ua.com.testes.manager.entity.EntityManager.get().remove(task);

                return null;

            }

        });

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.task.LogicTask
 * JD-Core Version:    0.6.0
 */