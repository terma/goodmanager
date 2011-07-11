<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityView" %>
<%@ page import="java.util.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.logic.view.LogicView" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.view.EntityViewUser" %>
<%@ page import="ua.com.testes.manager.util.request.UtilRequest" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer sectionId = null;
    if (request.getParameter("sectionId") != null) {
        sectionId = Integer.parseInt(request.getParameter("sectionId"));
    }
    Integer firmId = null;
    if (request.getParameter("firmId") != null) {
        firmId = Integer.parseInt(request.getParameter("firmId"));
    }
    // Текущий пользователь
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    // Представление
    final EntityView view = LogicView.get(user);
    // Установим другие настройки
    view.byMe = request.getParameter("byme") != null;
    view.byMeOld = request.getParameter("bymeold") != null;
    view.byMeTotal = request.getParameter("bymetotal") != null;
    view.byMeRepeat = request.getParameter("bymerepeat") != null;
    view.history.firm = request.getParameter("firmhistorys") != null;
    view.history.pipol = request.getParameter("pipolhistorys") != null;
    view.history.contact = request.getParameter("contacthistorys") != null;
    view.delete.firm = request.getParameter("firmdelete") != null;
    view.delete.pipol = request.getParameter("pipoldelete") != null;
    view.delete.contact = request.getParameter("contactdelete") != null;
    view.mail.show = request.getParameter("mailshow") != null;
    view.showRate = request.getParameter("rateshow") != null;
    view.flateHead = request.getParameter("flatehead") != null;
    view.showAddress = request.getParameter("showaddress") != null;
    view.showTelephon = request.getParameter("showtelephon") != null;
    view.showFax = request.getParameter("showfax") != null;
    view.showEmail = request.getParameter("showemail") != null;
    view.showWeb = request.getParameter("showweb") != null;
    view.showOwner = request.getParameter("showowner") != null;
    view.showLastContact = request.getParameter("showlastcontact") != null;
    view.mail.count = null;
    // Реальный пречень из бд
    final List<EntityUser> users = EntityManager.list(
            "select user from ua.com.testes.manager.entity.user.EntityUser as user");
    // Список удаляемых
    final List<EntityViewUser> deleteVuewUsers = new ArrayList<EntityViewUser>();
    // Удалим всех кого нет в бд из представления
    Iterator<EntityViewUser> viewUserIterator = view.users.iterator();
    while (viewUserIterator.hasNext()) {
        boolean containt = false;
        final EntityViewUser viewUser = viewUserIterator.next();
        for (final EntityUser tempUser : users) {
            if (tempUser.getId() == viewUser.id.userId) {
                containt = true;
                break;
            }
        }
        // Такого пользователя нет, нужно его удалить
        if (!containt) {
            deleteVuewUsers.add(viewUser);
            viewUserIterator.remove();
        }
    }
    // Теперь удалим всех кого нет в списка установленных
    String[] userStringArray = request.getParameterValues("viewusers");
    if (userStringArray != null) {
        final Set<String> userSet = new HashSet<String>(Arrays.asList(userStringArray));
        viewUserIterator = view.users.iterator();
        while (viewUserIterator.hasNext()) {
            final EntityViewUser viewUser = viewUserIterator.next();
            // Если пользователь из представления нет в выбранных, удалить такого
            if (!userSet.contains(Integer.toString(viewUser.id.userId))) {
                deleteVuewUsers.add(viewUser);
                viewUserIterator.remove();
            }
        }
        // Теперь добавим того кого нет в выбранных
        for (final String selectUserId : userSet) {
            // Проверяем если он
            boolean containt = false;
            for (final EntityViewUser viewUser : view.users) {
                if (selectUserId.equals(Integer.toString(viewUser.id.userId))) {
                    containt = true;
                    break;
                }
            }
            if (!containt) {
                final EntityViewUser viewUser = new EntityViewUser();
                viewUser.id.userId = Integer.parseInt(selectUserId);
                viewUser.id.view = view;
                view.users.add(viewUser);
            }
        }
    } else {
        deleteVuewUsers.addAll(view.users);
        view.users.clear();
    }
    try {
        view.mail.count = Integer.parseInt(request.getParameter("mailcount"));
    } catch (NumberFormatException exception) {

    }
    if (view.mail.count != null && view.mail.count < 0) {
        view.mail.count = null;
    }
    // Собственно схораненние
    EntityManager.execute(new EntityTransaction() {

        public Object execute(javax.persistence.EntityManager manager) {
            for (final EntityViewUser viewUser : deleteVuewUsers) {
                manager.remove(viewUser);
            }
            user.setDefaultView(view);
            manager.persist(user);
            return null;
        }

    });
    String redirectUrl = "/security/views.jsp";
    if (sectionId != null) {
        redirectUrl = UtilRequest.addParameter(redirectUrl, "sectionId", sectionId.toString());
    }
    if (firmId != null) {
        redirectUrl = UtilRequest.addParameter(redirectUrl, "firmId", firmId.toString());
    }
    response.sendRedirect(redirectUrl);
%>