/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ibk.servlets;

import ibk.dto.Conexion;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.FileNameMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author BP2158
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
public class Imagen extends HttpServlet {

    PrintWriter writer = null;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");


        String id = request.getParameter("idA");
        Part file = request.getPart("archivo");

        Conexion con = new Conexion();
        if (file.getSize() > 0) {
            con.insertFiles(writeFile(file), id);
            writer = response.getWriter();
            writer.println("<center style=\"margin-top: 140px \">Archivo insertado correctamente");
            writer.println("<br><a href='#' onclick='window.close()'>Cerrar</a></center>");
        } else {
            writer = response.getWriter();            
            writer.println("<center style=\"margin-top: 140px \">Debe seleccionar un archivo");
            writer.println("<br><a href='#' onclick='window.close()'>Cerrar</a></center>");
        }
    }

    private String getFileName(final Part part) {
        String ruta = "";
        final String partHeader = part.getHeader("content-disposition");
        for (String content : partHeader.split(";")) {
            if (content.trim().startsWith("filename")) {
                ruta = content.substring(
                        content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return ruta;
    }

    public String writeFile(Part filePart) throws IOException {
        //System.out.println(filePart.getName());
        String file=getFileName(filePart);
        String fileName = file.substring(file.lastIndexOf("\\")+1);
        //writer.println("File name "+fileName);
        //System.out.println("file name "+fileName);
        OutputStream out = null;
        InputStream filecontent = null;
        final String path = "D:\\Solicitudes\\Archivos\\";
        //writer.println("path "+path);
        //System.out.println("path "+path);
        String ruta = "";
        try {
            out = new FileOutputStream(new File(path + File.separator
                    + fileName));
            filecontent = filePart.getInputStream();
            int read = 0;
            final byte[] bytes = new byte[1024];

            while ((read = filecontent.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
            ruta = path + fileName;

        } catch (Exception fne) {
            System.out.println(fne.toString());
        } finally {
            if (out != null) {
                out.close();
            }
            if (filecontent != null) {
                filecontent.close();
            }
        }
        return ruta;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
