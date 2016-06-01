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

public class ServletDuration extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);

        String tipo = request.getParameter("tipo");
        String moneda = request.getParameter("moneda");
        float plazo = Float.parseFloat(request.getParameter("plazo"));
        float t=Float.parseFloat(request.getParameter("tasa"));
        double tasaM=Math.pow(1 + (t / 100), 1 / 12)-1;
        double d1=(1 + tasaM) / tasaM;
        double d2=plazo /Math.pow(1 + tasaM, plazo);
        double d=(d1 - d2) * 30;
        //float d = Float.parseFloat(request.getParameter("d"));
        Conexion c = new Conexion();
        List<Duration> l = c.getDuration(d);
        float LSp = l.get(0).plazo;
        float LIp = l.get(1).plazo;
        float LStS = l.get(0).soles;
        float LItS = l.get(1).soles;
        float LStD = l.get(0).usd;
        float LItD = l.get(1).usd;
        String fecha = l.get(1).fecha;

        double rptaS = LItS + ((d - LIp) / (LSp - LIp)) * (LStS - LItS);
        String soles = String.format("%.3f", rptaS);
        double rptaD = LItD + ((d - LIp) / (LSp - LIp)) * (LStD - LItD);
        String dolares = String.format("%.3f", rptaD);

        
        
    }

    
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
