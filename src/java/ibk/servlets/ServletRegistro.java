/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ibk.servlets;

import ibk.dto.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author BP2158
 */
public class ServletRegistro extends HttpServlet {

    PrintWriter writer = null;
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession ses = request.getSession(true);
        Conexion c = new Conexion();
        String user = request.getParameter("user");
        String psw = request.getParameter("psw");
        Cookie cookie = new Cookie("user",user.toUpperCase());
        cookie.setMaxAge(360*24*60*60);
        response.addCookie(cookie);
        boolean ok = c.registro(user.toUpperCase(), psw);
        String tipo = c.getLogin(user.toUpperCase(),psw);
        
        if(ok){
            writer = response.getWriter();
            writer.println("<center style=\"margin-top: 140px \">Cambio de contraseña correcta");
            writer.println("<br><a href='#' onclick='window.close()'>Cerrar</a></center>");
        }else{
            writer = response.getWriter();
            writer.println("<center style=\"margin-top: 140px \">¡Hubo un error al registrar su nueva contraseña!");
            writer.println("<br><a href='contraseña.jsp'>Regresar</a></center>");
        }

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
