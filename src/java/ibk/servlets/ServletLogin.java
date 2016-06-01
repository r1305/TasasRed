/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ibk.servlets;

import ibk.dto.Conexion;
import java.io.IOException;
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
public class ServletLogin extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession ses = request.getSession(true);
        
        request.setCharacterEncoding("UTF-8");
        
        Conexion c = new Conexion();
        String user = request.getParameter("user");
        Cookie cookie = new Cookie("user",user);
        cookie.setMaxAge(60*60*24*7*360);
        response.addCookie(cookie);
        String psw = request.getParameter("psw");
        String ok = c.getLogin(user.toUpperCase().toUpperCase(), psw);
        c.updateVencimiento();
        if (ok.equals("jefe")) {
            c.guardarLogin(user);
            response.sendRedirect("principal.jsp");
        } else if (ok.equals("supervisor")) {
            c.guardarLogin(user);
            response.sendRedirect("supervisor.jsp");
        } else if (ok.equals("gerente")) {
            c.guardarLogin(user);
            response.sendRedirect("gerente.jsp");
        } else if (ok.equals("red")) {
            c.guardarLogin(user);
            response.sendRedirect("formulario.jsp");
        } else if (ok.equals("ffvv")) {
            c.guardarLogin(user);
            response.sendRedirect("formulario_ffvv.jsp");
        }else if(ok.equals("abp")){
            c.guardarLogin(user);
            response.sendRedirect("principal_abp.jsp");
        } else if (ok.equals("fail")) {
            response.sendRedirect("index.jsp?cod=1");
        } else if (ok.equals("no existe")) {
            response.sendRedirect("index.jsp?cod=2");
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
