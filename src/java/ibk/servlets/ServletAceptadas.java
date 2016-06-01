/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ibk.servlets;

import ibk.dto.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author BP2158
 */
public class ServletAceptadas extends HttpServlet {

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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        String user = request.getParameter("user");
        int id = Integer.parseInt(request.getParameter("id"));
        String sb = request.getParameter("sb");
        String sh = request.getParameter("sh");
        String comentario = request.getParameter("comentario");
        String tasa = request.getParameter("tasa"); 
        String tasaS = request.getParameter("tasaS");
        String spread=request.getParameter("spread");
        String pmonto=request.getParameter("pmonto");
        String priesgo=request.getParameter("priesgo");
        String cof=request.getParameter("cof");
        String cope=request.getParameter("cope");
        String tmin=request.getParameter("tmin");
        String topt=request.getParameter("topt");
        
        Conexion con = new Conexion();
        boolean ok = con.responder(user, sb, sh, comentario, tasa, id, tasaS,tmin,topt,spread,pmonto,cope,cof,priesgo);
        if (ok) {
            response.getWriter().write("success");
            con.enviarMail(id);
        } else {
            response.getWriter().write("fail");
        }

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
