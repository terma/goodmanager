package ua.com.testes.manager.servlet;


import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.content.EntityImage;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.OutputStream;


public final class ServletImageGet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EntityImage image = (EntityImage) EntityManager.find(EntityImage.class, Integer.valueOf(Integer.parseInt(request.getParameter("imageid"))));

        if (image != null) {

            response.setContentType("application/octet-stream");

            response.addHeader("Content-Disposition", ";filename=image" + image.id + "." + image.extend);

            byte[] buffer = new byte[2048];

            OutputStream output = response.getOutputStream();

            ByteArrayInputStream input = new ByteArrayInputStream(image.data);

            int length = input.read(buffer);

            while (length > -1) {

                output.write(buffer, 0, length);

                length = input.read(buffer);

            }

        }

    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.servlet.ServletImageGet
 * JD-Core Version:    0.6.0
 */