/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ibk.servlets;

import ibk.dao.Duration;
import ibk.dto.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author BP2158
 */
public class ServletRoa extends HttpServlet {

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

        double t=Double.parseDouble(request.getParameter("tasa"));
        float pr = Float.parseFloat(request.getParameter("pr"));
        float cope = Float.parseFloat(request.getParameter("cope"));        
        
        String tipo = request.getParameter("tipo");
        String moneda = request.getParameter("moneda");
        float plazo = Float.parseFloat(request.getParameter("plazo"));
        
        double t1=(1 + (t / 100));
        double div=1.0/12.0;
          
        float tasaM=(float) (Math.pow(t1,div)-1);
        float d1=(1 + tasaM) / tasaM;
        float d2=plazo /(float)(Math.pow(1 + tasaM*100, plazo)-1);
        float d=(d1 - d2) * 30;
        
        Conexion c = new Conexion();
        List<Duration> l = c.getDuration(d);
        float LSp = l.get(0).plazo;
        float LIp = l.get(1).plazo;
        float LStS = l.get(0).soles;
        float LItS = l.get(1).soles;
        float LStD = l.get(0).usd;
        float LItD = l.get(1).usd;

        double rptaS = LItS + ((d - LIp) / (LSp - LIp)) * (LStS - LItS);
        String soles = String.format("%.3f", rptaS);
        double rptaD = LItD + ((d - LIp) / (LSp - LIp)) * (LStD - LItD);
        String dolares = String.format("%.3f", rptaD);
        
        double cof;
        if(tipo.equals("Hipotecario")){
            if(moneda.equals("Soles")){
                cof=rptaS;
            }else{
                cof=rptaD;
            }
        }else{
            cof=6.85;
        }
        
        
        double rpta = t - (pr) - cof - (cope);
        String r=String.format("%.3f", rpta);
        //String s = "<input type='text' class='form-control' readonly='true' value='" + rpta + "%'>";
        response.getWriter().write(r);

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
