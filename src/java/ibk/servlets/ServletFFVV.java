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
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author BP2158
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
public class ServletFFVV extends HttpServlet {

    PrintWriter writer = null;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession ses = request.getSession(true);
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        final Part a1 = request.getPart("f1");
        final Part a2 = request.getPart("f2");

        String user = request.getParameter("user");
        String nombre = request.getParameter("nombre");
        String dni = request.getParameter("dni");
        String valorI = request.getParameter("valorI");
        String prestamo = request.getParameter("prestamo");
        String cuotaI = request.getParameter("cuotaI");
        String moneda = request.getParameter("moneda");
        String plazo = request.getParameter("plazo");
        String prod = request.getParameter("prod");
        String medio = request.getParameter("medio");
        String mes = request.getParameter("mes");
        String tipo = request.getParameter("tipo");
        String vivienda = request.getParameter("vivienda");
        String tasa = request.getParameter("tasaS");
        String adq = request.getParameter("adq");
        String motivo = request.getParameter("moti");
        String segmento = request.getParameter("segmento");
        String cts = request.getParameter("cts");
        String planilla = request.getParameter("planilla");
        String comentario = request.getParameter("comentarioF");
        String otros = request.getParameter("otros");
        String cruce = "";

        if (cts != "" && cts != null) {
            cts = cts + ",";
        } else {
            cts = "";
        }

        if (planilla != "" && planilla != null) {
            planilla = planilla + ",";
        } else {
            planilla = "";
        }
        if (otros != "" && otros != null) {
            otros = otros + ",";
        } else {
            otros = "";
        }
        String p ="";
        String f = cruce.concat(cts + planilla + otros + ",");
        String cruceF = "";
        System.out.println(prod);
        if (prod.equals("Mi Vivienda") || prod.equals("Techo Propio")) {
            p="Mi Vivienda";
        }else{
            p="Hipotecario";
        }
        
        if (cts == "" && planilla == "" && otros == "") {
            cruceF = f.substring(0, f.length() - 1);
        } else {
            cruceF = f.substring(0, f.length() - 2);
        }
        if (user == null || user.equals("") || user.equals("null")) {
            response.sendRedirect("index.jsp");
        } else {
            Conexion c = new Conexion();
            boolean ok = false;
            String repe = c.validarRepeticiones(dni, prestamo, tasa,prod);
            System.out.println(repe);
            if (repe.equals("ok")|| repe.equals("")) {
                if (a1.getSize() == 0 && a2.getSize() == 0) {
                    ok = c.registroSolicitudFFVV(nombre.toUpperCase(), dni, prestamo, cuotaI, adq, plazo, tasa, valorI, moneda, p, medio, mes, tipo, vivienda, motivo, segmento, cruceF, user, comentario,prod);
                    c.updateVencimiento();
                } else if (a1.getSize() == 0) {
                    String f1 = writeFile(a2);
                    ok = c.registro1FileFFVV(nombre.toUpperCase(), f1, dni, prestamo, cuotaI, adq, plazo, tasa, valorI, moneda, p, medio, mes, tipo, vivienda, motivo, segmento, cruceF, user.toUpperCase(), comentario,prod);
                    c.updateVencimiento();
                } else if (a2.getSize() == 0) {
                    String f1 = writeFile(a1);
                    ok = c.registro1FileFFVV(nombre.toUpperCase(), f1, dni, prestamo, cuotaI, adq, plazo, tasa, valorI, moneda, p, medio, mes, tipo, vivienda, motivo, segmento, cruceF, user.toUpperCase(), comentario,prod);
                    c.updateVencimiento();
                } else {
                    String f1 = writeFile(a1);
                    String f2 = writeFile(a2);
                    ok = c.registroSolicitud2FilesFFVV(nombre.toUpperCase(), f1, f2, dni, prestamo, cuotaI, adq, plazo, tasa, valorI, moneda, p, medio, mes, tipo, vivienda, motivo, segmento, cruceF, user.toUpperCase(), comentario,prod);
                    c.updateVencimiento();
                }
            }else if(repe.equals("fail")){
                writer = response.getWriter();
                writer.println(""
                        + "<center><div class=\"panel panel-default\" style=\"width: 480px;height: 280px\">               "
                        + "<table role=\"table\" border='1' align=\"center\" style=\"height: 100%;width: 100%\">"
                        + "                    <!-- cabecera de login-->\n"
                        + "                    <thead>\n"
                        + "                    <th colspan=\"3\" style='background-color: #00A94E;heig:150px'>"
                        + "                        <img src=\"img/Logo IBK verde.jpg\" alt=\"\" style='width: 192px;\n" +
                                                    "    height: 60px;\n" +
                                                    "    line-height: 1;'/>"
                        + "                    </th>"
                        + "                    </thead>"
                        + "                    <tbody>"
                        + "                        <tr>"
                        + "                            <td style='text-align:center;font-size:22px'>"
                        + "                                 <b>Ya se ha ingresado una solicitud con los mismo datos"
                        + "                                 <br>Para regresar haga click <a href='formulario_ffvv.jsp'>aquí</a><b>"
                        + "                            </td>"
                        + "                        </tr>\n"
                        + "                    </tbody>\n"
                        + "                </table>"
                        + "</div></center>");
                
            }
            
            if (ok) {
                response.sendRedirect("formulario_ffvv.jsp");
            }
        }

    }

    private String getFileName(final Part part) {
        String ruta = "";
        final String partHeader = part.getHeader("content-disposition");
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                ruta = content.substring(
                        content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return ruta;
    }

    public String writeFile(Part filePart) throws IOException {
        //System.out.println(filePart.getName());
        String file = getFileName(filePart);
        String fileName = file.substring(file.lastIndexOf("\\") + 1);
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

            //writer.println("out "+out);
            //System.out.println("out "+out);
            filecontent = filePart.getInputStream();
            //System.out.println(filecontent);

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
