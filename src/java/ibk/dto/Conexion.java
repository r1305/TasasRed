/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ibk.dto;

import ibk.dao.Duration;
import ibk.dao.Prima;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author BP2158
 */
public class Conexion {

    //conexion a la BD
    public Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection("jdbc:sqlserver://b27279ch3w7",
                    "chip", "jedi1234");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }

    public String vencidas(int cod) {
        String ok = "";
        Connection conn = getConnection();
        String query;
        try {
            query = "select * from BD_CHIP.Phoenix.Formulario where Id='" + cod + "'";

            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getInt("dias") < 0);
                if (rs.getInt("dias") < 0) {
                    ok = "ok";
                }
            }
        } catch (Exception e) {
            System.out.println(e);
            ok = "fail";
        }
        return ok;
    }

    public String getNombre(String registro) {
        String nombre = "";
        String nombref = "";
        String query;
        try {

            Connection conn = getConnection();
            Statement statement = conn.createStatement();
            query = "SELECT Nombre_colaborador FROM [BD_CHIP].[Phoenix].[Usuarios] where [Registro]='" + registro + "'";

            ResultSet rs = statement.executeQuery(query);

            while (rs.next()) {
                nombre = rs.getString(1);
            }
            String[] n = nombre.split(" ");

            String nom = "";
            String ap = "";
            for (int i = 1; i < n[2].length(); i++) {
                nom += String.valueOf(n[2].toLowerCase().charAt(i));
            }
            nombref += n[2].charAt(0) + nom;
            for (int i = 1; i < n[0].length(); i++) {
                ap += String.valueOf(n[0].toLowerCase().charAt(i));
            }
            nombref += " " + n[0].charAt(0) + ap;

            rs.close();
            conn.close();
            statement.close();

        } catch (SQLException ex) {

        }
        return nombref;
    }

    //envia mail cuando se responde una solicitud
    public boolean enviarMail(int cod) {
        Connection con = null;
        CallableStatement proc = null;
        ResultSet rs = null;
        boolean ok = false;

        try {
            con = getConnection();

            proc = con.prepareCall("{ call Phoenix.sp_mail(?) }");

            proc.setInt(1, cod);
            rs = proc.executeQuery();

            proc.close();
            rs.close();
            ok = false;
        } catch (Exception e) {

            ok = true;
        }
        return ok;
    }

    public boolean enviarMailABP(int cod) {
        Connection con = null;
        CallableStatement proc = null;
        ResultSet rs = null;
        boolean ok = false;

        try {
            con = getConnection();

            proc = con.prepareCall("{ call Phoenix.sp_mail_abp(?) }");

            proc.setInt(1, cod);
            rs = proc.executeQuery();

            proc.close();
            rs.close();
            ok = false;
        } catch (Exception e) {

            ok = true;
        }
        return ok;
    }

    public boolean enviarMailRechazados(int cod) {
        Connection con = null;
        CallableStatement proc = null;
        ResultSet rs = null;
        boolean ok = false;

        try {
            con = getConnection();

            proc = con.prepareCall("{ call Phoenix.sp_mail_rechazo(?) }");

            proc.setInt(1, cod);
            rs = proc.executeQuery();

            proc.close();
            rs.close();
            ok = false;
        } catch (Exception e) {

            ok = true;
        }
        return ok;
    }

    public boolean enviarMailRechazadosABP(int cod) {
        Connection con = null;
        CallableStatement proc = null;
        ResultSet rs = null;
        boolean ok = false;

        try {
            con = getConnection();

            proc = con.prepareCall("{ call Phoenix.sp_mail_rechazo_abp(?) }");

            proc.setInt(1, cod);
            rs = proc.executeQuery();

            proc.close();
            rs.close();
            ok = false;
        } catch (Exception e) {

            ok = true;
        }
        return ok;
    }

    public void cambioCLave(String u) {
        Connection con = null;
        CallableStatement proc = null;
        ResultSet rs = null;
        boolean ok = false;

        try {
            con = getConnection();

            proc = con.prepareCall("{ call Phoenix.sp_clave(?) }");

            proc.setString(1, u);
            rs = proc.executeQuery();

            proc.close();
            rs.close();

        } catch (Exception e) {

        }

    }

    public void guardarLogin(String u) {
        Connection con = null;
        CallableStatement proc = null;
        ResultSet rs = null;
        boolean ok = false;

        try {
            con = getConnection();

            proc = con.prepareCall("{ call Phoenix.sp_registrar_login(?) }");

            proc.setString(1, u);
            rs = proc.executeQuery();

            proc.close();
            rs.close();

        } catch (Exception e) {

        }

    }

    //actualiza la fecha de vencimiento de las solicitudes respondidas
    public boolean updateVencimiento() {
        Connection con = null;
        CallableStatement proc = null;
        ResultSet rs = null;
        boolean ok = false;

        try {
            con = getConnection();

            proc = con.prepareCall("{ call Phoenix.sp_ActualizarVigenciaDeTasas }");

            rs = proc.executeQuery();

            proc.close();
            rs.close();
            ok = false;
        } catch (Exception e) {

            ok = true;
        }
        return ok;
    }

    //devuelve una lista de duration que luego serán tratadas en el servlet
    public List<Duration> getDuration(double dur) {
        List<Duration> d = new ArrayList<Duration>();
        Duration dura = null;

        try {

            Connection conn = getConnection();
            Statement statement = conn.createStatement();
            String q = "Select Max(Fecha) from [BD_CHIP].[Maestro].[CostoFondos]";
            String query = "SELECT TOP 2 * FROM [BD_CHIP].[Maestro].[CostoFondos] where [Duration_días] <" + dur + "  and Fecha=(" + q + ") order by [Duration_días] desc;";
            ResultSet rs = statement.executeQuery(query);

            while (rs.next()) {

                dura = new Duration();
                dura.setFecha(rs.getString(1));
                dura.setPlazo(rs.getInt(2));
                dura.setSoles(rs.getFloat(4));
                dura.setUsd(rs.getFloat(5));

                d.add(dura);
            }
            conn.close();
            statement.close();
            rs.close();

        } catch (SQLException ex) {
            System.out.println("error " + ex);
        }
        return d;
    }

    //devuelve la prima de riesgo según el SB y el SH
    public Prima getPrima(String buro, String hip) {
        Prima p = null;
        try {

            Connection conn = getConnection();
            Statement statement = conn.createStatement();
            String query = "SELECT * FROM [BD_CHIP].[Phoenix].[PrimaRiesgos] "
                    + "where [ScoreBuro] ='" + buro + "' and [ScoreHipotecario]='" + hip + "'";
            ResultSet rs = statement.executeQuery(query);

            while (rs.next()) {
                p = new Prima();
                p.setColor(rs.getString(3));
                p.setPrima(rs.getString(4));
                p.setColor_txt(rs.getString(5));

            }
            conn.close();
            statement.close();
            rs.close();

        } catch (SQLException ex) {
            Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex);
        }
        return p;
    }

    public float getCoF(float plazo, String tipo, String moneda) {
        float cof = 0.0f;
        String query = "";
        try {

            Connection conn = getConnection();
            Statement statement = conn.createStatement();

            if (plazo <= 120) {
                query = "SELECT [CostoFondos] FROM [BD_CHIP].[Phoenix].[CostoFondos] where [Rango]=120 and Producto='" + tipo + "' and Moneda='" + moneda + "'";
            } else if (plazo > 120 && plazo <= 180) {
                query = "SELECT [CostoFondos] FROM [BD_CHIP].[Phoenix].[CostoFondos] where [Rango]=180 and Producto='" + tipo + "' and Moneda='" + moneda + "'";
            } else if (plazo > 180 && plazo <= 240) {
                query = "SELECT [CostoFondos] FROM [BD_CHIP].[Phoenix].[CostoFondos] where [Rango]=240 and Producto='" + tipo + "' and Moneda='" + moneda + "'";
            } else if (plazo > 240) {
                query = "SELECT [CostoFondos] FROM [BD_CHIP].[Phoenix].[CostoFondos] where [Rango]=241 and Producto='" + tipo + "' and Moneda='" + moneda + "'";
            }

            ResultSet rs = statement.executeQuery(query);

            while (rs.next()) {
                cof = rs.getFloat(1);
            }
            rs.close();
            conn.close();
            statement.close();

        } catch (SQLException ex) {

        }
        return cof;
    }

    public float getCosto(float monto, String tipo) {
        float cop = 0.0f;
        String query = "";
        try {

            Connection conn = getConnection();
            Statement statement = conn.createStatement();

            if (monto <= 100) {
                query = "SELECT [GastoOperativo] FROM [BD_CHIP].[Phoenix].[GastosOperativo] where [Rango]=100 and Producto='" + tipo + "'";
            } else if (monto > 100 && monto <= 150) {
                query = "SELECT [GastoOperativo] FROM [BD_CHIP].[Phoenix].[GastosOperativo] where [Rango]=150 and Producto='" + tipo + "'";
            } else if (monto > 150 && monto <= 250) {
                query = "SELECT [GastoOperativo] FROM [BD_CHIP].[Phoenix].[GastosOperativo] where [Rango]=250 and Producto='" + tipo + "'";
            } else if (monto > 250 && monto <= 350) {
                query = "SELECT [GastoOperativo] FROM [BD_CHIP].[Phoenix].[GastosOperativo] where [Rango]=350 and Producto='" + tipo + "'";
            } else if (monto > 350 && monto <= 450) {
                query = "SELECT [GastoOperativo] FROM [BD_CHIP].[Phoenix].[GastosOperativo] where [Rango]=450 and Producto='" + tipo + "'";
            } else if (monto > 450 && monto <= 600) {
                query = "SELECT [GastoOperativo] FROM [BD_CHIP].[Phoenix].[GastosOperativo] where [Rango]=600 and Producto='" + tipo + "'";
            } else if (monto > 600) {
                query = "SELECT [GastoOperativo] FROM [BD_CHIP].[Phoenix].[GastosOperativo] where [Rango]=601 and Producto='" + tipo + "'";
            }

            ResultSet rs = statement.executeQuery(query);

            while (rs.next()) {
                cop = rs.getFloat(1);
            }
            rs.close();
            conn.close();
            statement.close();

        } catch (SQLException ex) {

        }
        return cop;
    }

    public float getPrimaMonto(float monto, String tipo, String moneda) {
        float prim = 0.0f;
        String query = "";
        try {

            Connection conn = getConnection();
            Statement statement = conn.createStatement();

            if (monto <= 100) {
                query = "SELECT [PrimaMonto] FROM [BD_CHIP].[Phoenix].[PrimaMonto] where [Rango]=100 and Producto='" + tipo + "' and Moneda='" + moneda + "'";
            } else if (monto > 100 && monto <= 150) {
                query = "SELECT [PrimaMonto] FROM [BD_CHIP].[Phoenix].[PrimaMonto] where [Rango]=150 and Producto='" + tipo + "' and Moneda='" + moneda + "'";
            } else if (monto > 150 && monto <= 250) {
                query = "SELECT [PrimaMonto] FROM [BD_CHIP].[Phoenix].[PrimaMonto] where [Rango]=250 and Producto='" + tipo + "' and Moneda='" + moneda + "'";
            } else if (monto > 250 && monto <= 350) {
                query = "SELECT [PrimaMonto] FROM [BD_CHIP].[Phoenix].[PrimaMonto] where [Rango]=350 and Producto='" + tipo + "' and Moneda='" + moneda + "'";
            } else if (monto > 350 && monto <= 450) {
                query = "SELECT [PrimaMonto] FROM [BD_CHIP].[Phoenix].[PrimaMonto] where [Rango]=450 and Producto='" + tipo + "' and Moneda='" + moneda + "'";
            } else if (monto > 450 && monto <= 600) {
                query = "SELECT [PrimaMonto] FROM [BD_CHIP].[Phoenix].[PrimaMonto] where [Rango]=600 and Producto='" + tipo + "' and Moneda='" + moneda + "'";
            } else if (monto > 600) {
                query = "SELECT [PrimaMonto] FROM [BD_CHIP].[Phoenix].[PrimaMonto] where [Rango]=601 and Producto='" + tipo + "' and Moneda='" + moneda + "'";
            }

            ResultSet rs = statement.executeQuery(query);

            while (rs.next()) {
                prim = rs.getFloat(1);
            }
            rs.close();
            conn.close();
            statement.close();

        } catch (SQLException ex) {

        }
        return prim;
    }

    public float getSpread(String color, String prod, String moneda) {
        float spread = 0.0f;
        String query = "";
        try {

            Connection conn = getConnection();
            Statement statement = conn.createStatement();

            query = "SELECT [Spread] FROM [BD_CHIP].[Phoenix].[Spreads] where Color='" + color + "' and Producto='" + prod + "' and Moneda='" + moneda + "'";

            ResultSet rs = statement.executeQuery(query);

            while (rs.next()) {
                spread = rs.getFloat(1);
            }
            rs.close();
            conn.close();
            statement.close();

        } catch (SQLException ex) {

        }
        return spread;
    }

    public float getInof(float monto, String tipo) {
        float inof = 0.0f;
        String query = "";
        try {

            Connection conn = getConnection();
            Statement statement = conn.createStatement();
            if (monto <= 100) {
                query = "SELECT [INOF] FROM [BD_CHIP].[Phoenix].[INOF] where [Rango]=100 and Producto='" + tipo + "'";
            } else if (monto > 100 && monto <= 150) {
                query = "SELECT [INOF] FROM [BD_CHIP].[Phoenix].[INOF] where [Rango]=150 and Producto='" + tipo + "'";
            } else if (monto > 150 && monto <= 250) {
                query = "SELECT [INOF] FROM [BD_CHIP].[Phoenix].[INOF] where [Rango]=250 and Producto='" + tipo + "'";
            } else if (monto > 250 && monto <= 350) {
                query = "SELECT [INOF] FROM [BD_CHIP].[Phoenix].[INOF] where [Rango]=350 and Producto='" + tipo + "'";
            } else if (monto > 350 && monto <= 450) {
                query = "SELECT [INOF] FROM [BD_CHIP].[Phoenix].[INOF] where [Rango]=450 and Producto='" + tipo + "'";
            } else if (monto > 450 && monto <= 600) {
                query = "SELECT [INOF] FROM [BD_CHIP].[Phoenix].[INOF] where [Rango]=600 and Producto='" + tipo + "'";
            } else if (monto > 600) {
                query = "SELECT [INOF] FROM [BD_CHIP].[Phoenix].[INOF] where [Rango]=601 and Producto='" + tipo + "'";
            }

            ResultSet rs = statement.executeQuery(query);

            while (rs.next()) {
                inof = rs.getFloat(1);
            }
            conn.close();
            statement.close();

        } catch (SQLException ex) {
            Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex);
        }
        return inof;
    }

    public String getLogin(String user, String psw) {

        String ok = "";

        try {

            Connection conn = getConnection();
            Statement statement = conn.createStatement();
            String query = "SELECT * FROM [BD_CHIP].[Phoenix].[Usuarios] where Registro = '" + user.toUpperCase() + "'";
            ResultSet rs = statement.executeQuery(query);
            if (rs.getRow() == 0) {
                ok = "no existe";
            }
            while (rs.next()) {
                if (user.equalsIgnoreCase(rs.getString("Registro"))) {
                    if (psw.equals(rs.getString("Clave"))) {
                        if (rs.getString("Condicion").equalsIgnoreCase("Activo")) {
                            if (rs.getString("Perfil").equals("Evaluador")) {
                                ok = "jefe";
                            } else if (rs.getString("Perfil").equalsIgnoreCase("supervisor")) {
                                ok = "supervisor";
                            } else if (rs.getString("Perfil").equalsIgnoreCase("gerencial")) {
                                ok = "gerente";
                            } else if (rs.getString("Perfil").equalsIgnoreCase("Solicitante FFVV")) {
                                ok = "ffvv";
                            } else if (rs.getString("Perfil").equalsIgnoreCase("GT")) {
                                ok = "gt";
                            } else if (rs.getString("Perfil").equalsIgnoreCase("Evaluador ABP")) {
                                ok = "abp";

                            } else {
                                ok = "red";
                            }
                        } else {
                            ok = "no existe";
                        }

                    } else {
                        ok = "fail";
                    }
                }
            }
            conn.close();
            statement.close();
            rs.close();

        } catch (SQLException ex) {
            ok = "error";
            System.out.println("error " + ex);
        }
        return ok;
    }

    public int getUsuario(String user) {
        ResultSet rs = null;
        Statement statement = null;
        Connection conn = null;
        int u = 0;

        try {

            conn = getConnection();
            statement = conn.createStatement();
            String query = "SELECT * FROM [BD_CHIP].[Phoenix].[Usuarios] where Registro = '" + user + "'";
            rs = statement.executeQuery(query);
            while (rs.next()) {
                if (rs.getString("Perfil").equalsIgnoreCase("Evaluador")) {
                    u = 1;
                } else {
                    u = 2;
                }
            }

        } catch (Exception ex) {
            try {
                rs.close();
                statement.close();
                conn.close();
                u = 0;
                System.out.println("error " + ex);
            } catch (SQLException ex1) {
                Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex1);
            }
        }
        return u;
    }

    //muestra cuantas veces ha sido reconsiderada una solicitud
    public int getContador(String id) {
        ResultSet rs = null;
        Statement statement = null;
        Connection conn = null;
        int cont = 0;

        try {

            conn = getConnection();
            statement = conn.createStatement();
            String query = "SELECT * FROM [BD_CHIP].[Phoenix].[Formulario] where Id =" + id;
            rs = statement.executeQuery(query);
            while (rs.next()) {
                cont = rs.getInt("Cont");
            }

        } catch (Exception ex) {
            try {
                rs.close();
                statement.close();
                conn.close();
                cont = 0;
                System.out.println("error " + ex);
            } catch (SQLException ex1) {
                Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex1);
            }
        }
        return cont;
    }

    //registra nuevo psw del usuario
    public boolean registro(String user, String psw) {

        boolean ok = false;

        try {

            Connection conn = getConnection();

            String query1 = "SELECT * FROM [BD_CHIP].[Phoenix].[Usuarios] where Registro = '" + user + "'";
            String query = "update [BD_CHIP].[Phoenix].[Usuarios] set Clave='" + psw + "' where Registro='" + user + "'";
            Statement statement = conn.createStatement();
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs1 = statement.executeQuery(query1);

            while (rs1.next()) {
                if (user.equals(rs1.getString(1)) && rs1.getString("Condicion").equalsIgnoreCase("Activo")) {
                    ps.executeUpdate();
                    cambioCLave(user.toUpperCase());
                    ok = true;
                }
            }
            conn.close();
            ps.close();
            statement.close();

        } catch (SQLException ex) {
            ok = false;
            System.out.println("error " + ex);
        }
        return ok;
    }

    //ingreso de solicitudes para reconsideración
    public boolean repechaje(String id, String tasa, String coment) {

        boolean ok;

        try {

            Connection conn = getConnection();

            String query = "update [BD_CHIP].[Phoenix].[Formulario] set Estado='Pendiente',"
                    + "Tasa_solicitada=" + Float.parseFloat(tasa) + ","
                    + "comentF='" + coment + "',Fecha_solicitud=getdate(),"
                    + "cont=2 where Id=" + id;
            Statement statement = conn.createStatement();
            PreparedStatement ps = conn.prepareStatement(query);

            ps.executeUpdate();
            ok = true;
            conn.close();
            ps.close();
            statement.close();

        } catch (SQLException ex) {
            ok = false;
            System.out.println("error " + ex);
        }
        return ok;
    }

    public boolean actualización(String id, String tasa, String coment) {

        boolean ok;
        int cont = getContador(id);
        if (cont == 1) {
            cont = cont + 2;
        } else {
            cont = cont + 1;
        }
        System.out.println("actualizacion cont: " + cont);
        try {

            Connection conn = getConnection();

            String query = "update [BD_CHIP].[Phoenix].[Formulario] set Estado='Pendiente',"
                    + "Tasa_solicitada=" + Float.parseFloat(tasa) + ","
                    + "comentF='" + coment + "',Fecha_solicitud=getdate(),Fecha_Vencimiento=Null"
                    + ",cont=" + cont + " where Id=" + id;
            Statement st = conn.createStatement();
            PreparedStatement pst = conn.prepareStatement(query);

            pst.executeUpdate();
            updateVencimiento();
            ok = true;
            conn.close();
            pst.close();
            st.close();

        } catch (SQLException ex) {
            ok = false;
            System.out.println("error " + ex);
        }
        return ok;
    }

    /**
     * solicitudes de RED *
     */
    public boolean registroSolicitud2Files(String nombre, String r1, String r2, String dni, String prestamo, String cuotaI, String adq, String plazo, String tasaSol, String valorI, String moneda, String prod, String medio, String mes, String tipo, String vivienda, String motivo, String segmento, String cruce, String user, String coment, String prod_origen) {

        boolean ok = false;
        int len1;
        int len2;

        try {

            Connection conn = getConnection();

            String query = "INSERT INTO [BD_CHIP].[Phoenix].[Formulario]"
                    + "([Nombre_Cliente]"
                    + ",[Cod_doc]"
                    + ",[Prestamo]"
                    + ",[Cuota_inicial]"
                    + ",[Tasa_ADQ]"
                    + ",[Plazo]"
                    + ",[Tasa_Solicitada]"
                    + ",[Valor_inmueble]"
                    + ",[Moneda]"
                    + ",[Producto]"
                    + ",[Medio_calificacion]"
                    + ",[Mes_desembolso]"
                    + ",[Tipo_inmueble]"
                    + ",[Nro_vivienda]"
                    + ",[Motivo]"
                    + ",[Segmento]"
                    + ",[Cruce_productos]"
                    + ",[Estado]"
                    + ",[Usuario]"
                    + ",[Fecha_Solicitud]"
                    + ",[comentF]"
                    + ",[Cont]"
                    + ",[Archivo1]"
                    + ",[name1]"
                    + ",[Archivo2]"
                    + ",[name2],[Producto_origen])"
                    + "     VALUES"
                    + "('" + nombre + "'"
                    + ",'" + dni + "'"
                    + "," + prestamo + ""
                    + "," + cuotaI + ""
                    + "," + adq + ""
                    + "," + plazo + ""
                    + "," + tasaSol + ""
                    + "," + valorI + ""
                    + ",'" + moneda + "'"
                    + ",'" + prod + "'"
                    + ",'" + medio + "'"
                    + ",'" + mes + "'"
                    + ",'" + tipo + "'"
                    + ",'" + vivienda + "'"
                    + ",'" + motivo + "'"
                    + ",'" + segmento + "'"
                    + ",'" + cruce + "'"
                    + ",'Pendiente'"
                    + ",'" + user + "'"
                    + ",getdate()"
                    + ",'" + coment + "'"
                    + ",1"
                    + ",?,?,?,?,'" + prod_origen + "')";

            File f1 = new File(r1);
            File f2 = new File(r2);
            FileInputStream fis1 = new FileInputStream(f1);
            FileInputStream fis2 = new FileInputStream(f2);
            len1 = (int) f1.length();
            len2 = (int) f2.length();

            PreparedStatement ps = conn.prepareStatement(query);

            //method to insert a stream of bytes
            /**
             * ** archivo1 ***
             */
            ps.setBinaryStream(1, fis1, len1);
            ps.setString(2, f1.getName());
            /**
             * ** archivo2 ***
             */
            ps.setBinaryStream(3, fis2, len2);
            ps.setString(4, f2.getName());
            ps.executeUpdate();
            ok = true;
            ps.close();
            conn.close();
        } catch (Exception ex) {
            ok = false;
            Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex);
        }

        return ok;
    }

    //guarda el formulario con 1 solo file
    public boolean registro1File(String nombre, String r1, String dni, String prestamo, String cuotaI, String adq, String plazo, String tasaSol, String valorI, String moneda, String prod, String medio, String mes, String tipo, String vivienda, String motivo, String segmento, String cruce, String user, String coment, String prod_origen) {

        boolean ok = false;
        int len1;

        try {

            Connection conn = getConnection();

            String query = "INSERT INTO [BD_CHIP].[Phoenix].[Formulario]"
                    + "([Nombre_Cliente]"
                    + ",[Cod_doc]"
                    + ",[Prestamo]"
                    + ",[Cuota_inicial]"
                    + ",[Tasa_ADQ]"
                    + ",[Plazo]"
                    + ",[Tasa_Solicitada]"
                    + ",[Valor_inmueble]"
                    + ",[Moneda]"
                    + ",[Producto]"
                    + ",[Medio_calificacion]"
                    + ",[Mes_desembolso]"
                    + ",[Tipo_inmueble]"
                    + ",[Nro_vivienda]"
                    + ",[Motivo]"
                    + ",[Segmento]"
                    + ",[Cruce_productos]"
                    + ",[Estado]"
                    + ",[Usuario]"
                    + ",[Fecha_Solicitud]"
                    + ",[comentF]"
                    + ",[Cont]"
                    + ",[Archivo1]"
                    + ",[name1]"
                    + ",[Producto_origen])"
                    + "     VALUES"
                    + "('" + nombre + "'"
                    + ",'" + dni + "'"
                    + "," + Float.parseFloat(prestamo) + ""
                    + "," + Float.parseFloat(cuotaI) + ""
                    + "," + Float.parseFloat(adq) + ""
                    + "," + plazo + ""
                    + "," + Float.parseFloat(tasaSol) + ""
                    + "," + Float.parseFloat(valorI) + ""
                    + ",'" + moneda + "'"
                    + ",'" + prod + "'"
                    + ",'" + medio + "'"
                    + ",'" + mes + "'"
                    + ",'" + tipo + "'"
                    + ",'" + vivienda + "'"
                    + ",'" + motivo + "'"
                    + ",'" + segmento + "'"
                    + ",'" + cruce + "'"
                    + ",'Pendiente'"
                    + ",'" + user + "'"
                    + ",getdate()"
                    + ",'" + coment + "'"
                    + ",1"
                    + ",?,?,'" + prod_origen + "')";

            File f1 = new File(r1);

            FileInputStream fis1 = new FileInputStream(f1);

            len1 = (int) f1.length();

            PreparedStatement ps = conn.prepareStatement(query);

            //method to insert a stream of bytes
            /**
             * ** archivo1 ***
             */
            ps.setBinaryStream(1, fis1, len1);
            ps.setString(2, f1.getName());

            ps.executeUpdate();
            ok = true;
            ps.close();
            conn.close();
        } catch (Exception ex) {
            ok = false;
            Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex);
        }

        return ok;
    }

    //guarda el formulario sin ningun file añadido
    public boolean registroSolicitud(String nombre, String dni, String prestamo, String cuotaI, String adq, String plazo, String tasaSol, String valorI, String moneda, String prod, String medio, String mes, String tipo, String vivienda, String motivo, String segmento, String cruce, String user, String coment, String prod_origen) {

        boolean ok = false;
        try {

            Connection conn = getConnection();

            String query = "INSERT INTO [BD_CHIP].[Phoenix].[Formulario]"
                    + "([Nombre_Cliente]"
                    + ",[Cod_doc]"
                    + ",[Prestamo]"
                    + ",[Cuota_inicial]"
                    + ",[Tasa_ADQ]"
                    + ",[Plazo]"
                    + ",[Tasa_Solicitada]"
                    + ",[Valor_inmueble]"
                    + ",[Moneda]"
                    + ",[Producto]"
                    + ",[Medio_calificacion]"
                    + ",[Mes_desembolso]"
                    + ",[Tipo_inmueble]"
                    + ",[Nro_vivienda]"
                    + ",[Motivo]"
                    + ",[Segmento]"
                    + ",[Cruce_productos]"
                    + ",[Estado]"
                    + ",[Usuario]"
                    + ",[Fecha_Solicitud]"
                    + ",[comentF]"
                    + ",[Cont]"
                    + ",[Producto_origen])"
                    + "     VALUES"
                    + "('" + nombre + "'"
                    + ",'" + dni + "'"
                    + "," + Float.parseFloat(prestamo) + ""
                    + "," + Float.parseFloat(cuotaI) + ""
                    + ",'" + Float.parseFloat(adq) + "'"
                    + ",'" + plazo + "'"
                    + ",'" + Float.parseFloat(tasaSol) + "'"
                    + ",'" + Float.parseFloat(valorI) + "'"
                    + ",'" + moneda + "'"
                    + ",'" + prod + "'"
                    + ",'" + medio + "'"
                    + ",'" + mes + "'"
                    + ",'" + tipo + "'"
                    + ",'" + vivienda + "'"
                    + ",'" + motivo + "'"
                    + ",'" + segmento + "'"
                    + ",'" + cruce + "'"
                    + ",'Pendiente'"
                    + ",'" + user + "'"
                    + ",getdate()"
                    + ",'" + coment + "'"
                    + ",1,'" + prod_origen + "')";

            PreparedStatement ps = conn.prepareStatement(query);

            ps.executeUpdate();
            ok = true;
            ps.close();
            conn.close();
        } catch (Exception ex) {
            ok = false;
            Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex);
        }

        return ok;
    }

    /**
     * solicitudes de FFVV *
     */
    //guarda solicitudes de FFVV con 2 files añadidos
    public boolean registroSolicitud2FilesFFVV(String nombre, String r1, String r2, String dni, String prestamo, String cuotaI, String adq, String plazo, String tasaSol, String valorI, String moneda, String prod, String medio, String mes, String tipo, String vivienda, String motivo, String segmento, String cruce, String user, String coment, String prod_origen) {

        boolean ok = false;
        int len1;
        int len2;

        try {

            Connection conn = getConnection();

            String query = "INSERT INTO [BD_CHIP].[Phoenix].[Formulario]"
                    + "([Nombre_Cliente]"
                    + ",[Cod_doc]"
                    + ",[Prestamo]"
                    + ",[Cuota_inicial]"
                    + ",[Tasa_ADQ]"
                    + ",[Plazo]"
                    + ",[Tasa_Solicitada]"
                    + ",[Valor_inmueble]"
                    + ",[Moneda]"
                    + ",[Producto]"
                    + ",[Medio_calificacion]"
                    + ",[Mes_desembolso]"
                    + ",[Tipo_inmueble]"
                    + ",[Nro_vivienda]"
                    + ",[Motivo]"
                    + ",[Segmento]"
                    + ",[Cruce_productos]"
                    + ",[Estado]"
                    + ",[Usuario]"
                    + ",[Fecha_Solicitud]"
                    + ",[comentF]"
                    + ",[Cont]"
                    + ",[Archivo1]"
                    + ",[name1]"
                    + ",[Archivo2]"
                    + ",[name2]"
                    + ",[Score_Hipotecario]"
                    + ",[Producto_origen])"
                    + "     VALUES"
                    + "('" + nombre + "'"
                    + ",'" + dni + "'"
                    + "," + Float.parseFloat(prestamo) + ""
                    + "," + Float.parseFloat(cuotaI) + ""
                    + "," + Float.parseFloat(adq) + ""
                    + "," + plazo + ""
                    + "," + Float.parseFloat(tasaSol) + ""
                    + "," + Float.parseFloat(valorI) + ""
                    + ",'" + moneda + "'"
                    + ",'" + prod + "'"
                    + ",'" + medio + "'"
                    + ",'" + mes + "'"
                    + ",'" + tipo + "'"
                    + ",'" + vivienda + "'"
                    + ",'" + motivo + "'"
                    + ",'" + segmento + "'"
                    + ",'" + cruce + "'"
                    + ",'Pendiente'"
                    + ",'" + user + "'"
                    + ",getdate()"
                    + ",'" + coment + "'"
                    + ",1"
                    + ",?,?,?,?,'Sin Score'"
                    + ",'" + prod_origen + "')";

            File f1 = new File(r1);
            File f2 = new File(r2);
            FileInputStream fis1 = new FileInputStream(f1);
            FileInputStream fis2 = new FileInputStream(f2);
            len1 = (int) f1.length();
            len2 = (int) f2.length();

            PreparedStatement ps = conn.prepareStatement(query);

            //method to insert a stream of bytes
            /**
             * ** archivo1 ***
             */
            ps.setBinaryStream(1, fis1, len1);
            ps.setString(2, f1.getName());
            /**
             * ** archivo2 ***
             */
            ps.setBinaryStream(3, fis2, len2);
            ps.setString(4, f2.getName());
            ps.executeUpdate();
            ok = true;
            ps.close();
            conn.close();
        } catch (Exception ex) {
            ok = false;
            Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex);
        }

        return ok;
    }

    //guarda solicitudes de FFVV con 1 file añadido
    public boolean registro1FileFFVV(String nombre, String r1, String dni, String prestamo, String cuotaI, String adq, String plazo, String tasaSol, String valorI, String moneda, String prod, String medio, String mes, String tipo, String vivienda, String motivo, String segmento, String cruce, String user, String coment, String prod_origen) {

        boolean ok = false;
        int len1;

        try {

            Connection conn = getConnection();

            String query = "INSERT INTO [BD_CHIP].[Phoenix].[Formulario]"
                    + "([Nombre_Cliente]"
                    + ",[Cod_doc]"
                    + ",[Prestamo]"
                    + ",[Cuota_inicial]"
                    + ",[Tasa_ADQ]"
                    + ",[Plazo]"
                    + ",[Tasa_Solicitada]"
                    + ",[Valor_inmueble]"
                    + ",[Moneda]"
                    + ",[Producto]"
                    + ",[Medio_calificacion]"
                    + ",[Mes_desembolso]"
                    + ",[Tipo_inmueble]"
                    + ",[Nro_vivienda]"
                    + ",[Motivo]"
                    + ",[Segmento]"
                    + ",[Cruce_productos]"
                    + ",[Estado]"
                    + ",[Usuario]"
                    + ",[Fecha_Solicitud]"
                    + ",[comentF]"
                    + ",[Cont]"
                    + ",[Archivo1]"
                    + ",[name1]"
                    + ",[Score_Hipotecario]"
                    + ",[Producto_origen])"
                    + "     VALUES"
                    + "('" + nombre + "'"
                    + ",'" + dni + "'"
                    + "," + Float.parseFloat(prestamo) + ""
                    + "," + Float.parseFloat(cuotaI) + ""
                    + "," + Float.parseFloat(adq) + ""
                    + "," + plazo + ""
                    + "," + Float.parseFloat(tasaSol) + ""
                    + "," + Float.parseFloat(valorI) + ""
                    + ",'" + moneda + "'"
                    + ",'" + prod + "'"
                    + ",'" + medio + "'"
                    + ",'" + mes + "'"
                    + ",'" + tipo + "'"
                    + ",'" + vivienda + "'"
                    + ",'" + motivo + "'"
                    + ",'" + segmento + "'"
                    + ",'" + cruce + "'"
                    + ",'Pendiente'"
                    + ",'" + user + "'"
                    + ",getdate()"
                    + ",'" + coment + "'"
                    + ",1"
                    + ",?,?,'Sin Score'"
                    + ",'" + prod_origen + "')";

            File f1 = new File(r1);
            System.out.println(r1);

            FileInputStream fis1 = new FileInputStream(f1);
            System.out.println(fis1);
            System.out.println(f1.getName());

            len1 = (int) f1.length();

            PreparedStatement ps = conn.prepareStatement(query);

            //method to insert a stream of bytes
            /**
             * ** archivo1 ***
             */
            ps.setBinaryStream(1, fis1, len1);
            ps.setString(2, f1.getName());

            ps.executeUpdate();
            ok = true;
            ps.close();
            conn.close();
        } catch (Exception ex) {
            ok = false;
            Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex);
        }

        return ok;
    }

    //guarda solicitudes de FFVV sin file añadido
    public boolean registroSolicitudFFVV(String nombre, String dni, String prestamo, String cuotaI, String adq, String plazo, String tasaSol, String valorI, String moneda, String prod, String medio, String mes, String tipo, String vivienda, String motivo, String segmento, String cruce, String user, String coment, String prod_origen) {

        boolean ok = false;

        try {

            Connection conn = getConnection();

            String query = "INSERT INTO [BD_CHIP].[Phoenix].[Formulario]"
                    + "([Nombre_Cliente]"
                    + ",[Cod_doc]"
                    + ",[Prestamo]"
                    + ",[Cuota_inicial]"
                    + ",[Tasa_ADQ]"
                    + ",[Plazo]"
                    + ",[Tasa_Solicitada]"
                    + ",[Valor_inmueble]"
                    + ",[Moneda]"
                    + ",[Producto]"
                    + ",[Medio_calificacion]"
                    + ",[Mes_desembolso]"
                    + ",[Tipo_inmueble]"
                    + ",[Nro_vivienda]"
                    + ",[Motivo]"
                    + ",[Segmento]"
                    + ",[Cruce_productos]"
                    + ",[Estado]"
                    + ",[Usuario]"
                    + ",[Fecha_Solicitud]"
                    + ",[comentF]"
                    + ",[Cont]"
                    + ",[Score_Hipotecario]"
                    + ",[Producto_origen])"
                    + "     VALUES"
                    + "('" + nombre + "'"
                    + ",'" + dni + "'"
                    + "," + Float.parseFloat(prestamo) + ""
                    + "," + Float.parseFloat(cuotaI) + ""
                    + "," + Float.parseFloat(adq) + ""
                    + "," + plazo + ""
                    + "," + Float.parseFloat(tasaSol) + ""
                    + "," + Float.parseFloat(valorI) + ""
                    + ",'" + moneda + "'"
                    + ",'" + prod + "'"
                    + ",'" + medio + "'"
                    + ",'" + mes + "'"
                    + ",'" + tipo + "'"
                    + ",'" + vivienda + "'"
                    + ",'" + motivo + "'"
                    + ",'" + segmento + "'"
                    + ",'" + cruce + "'"
                    + ",'Pendiente'"
                    + ",'" + user + "'"
                    + ",getdate()"
                    + ",'" + coment + "'"
                    + ",1,'Sin Score'"
                    + ",'" + prod_origen + "')";

            PreparedStatement ps = conn.prepareStatement(query);

            ps.executeUpdate();
            ok = true;
            ps.close();
            conn.close();
        } catch (Exception ex) {
            ok = false;
            Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex);
        }

        return ok;
    }

    //insert de archivos fuera de formulario
    public boolean insertFiles(String filename, String cod) {
        int len;
        boolean ok = false;
        String query;
        PreparedStatement pstmt;
        Connection con = getConnection();

        try {
            File file = new File(filename);
            FileInputStream fis = new FileInputStream(file);
            len = (int) file.length();
            query = ("insert into BD_CHIP.Phoenix.Imagenes (Archivos,cod,nombre) VALUES(?,?,?)");
            pstmt = con.prepareStatement(query);
            pstmt.setString(3, file.getName());
            pstmt.setString(2, cod);

            //method to insert a stream of bytes
            pstmt.setBinaryStream(1, fis, len);
            pstmt.executeUpdate();
            ok = true;

        } catch (Exception e) {
            ok = false;
            e.printStackTrace();
        }
        return ok;
    }

    //retrieve de los archivos hacia la carpeta compartida
    public String getFilesData(String cod) {
        int c = Integer.parseInt(cod);
        String path = "";
        boolean ok = false;
        boolean ok1 = false;
        byte[] fileBytes;
        byte[] fileBytes1;
        String query, query1;
        Connection conn = getConnection();
        try {
            query = "select * from BD_CHIP.Phoenix.Imagenes where cod=" + c;
            query1 = "select * from BD_CHIP.Phoenix.Formulario where Id=" + c;
            Statement state = conn.createStatement();
            Statement state1 = conn.createStatement();
            ResultSet rs = state.executeQuery(query);
            ResultSet rs1 = state1.executeQuery(query1);
            File dir = new File("\\\\hipotecario\\Solicitudes\\solicitud" + c);
            dir.mkdir();
            int read = 0;
            while (rs.next()) {
                if (rs.getBytes(4) != null) {
                    fileBytes = rs.getBytes(4);

                    OutputStream targetFile = new FileOutputStream(
                            new File(dir + File.separator + rs.getString("nombre")));
                    targetFile.write(fileBytes);
                    targetFile.close();
                    ok = true;
                }

            }
            while (rs1.next()) {
                if (rs1.getBytes("Archivo1") != null) {

                    fileBytes1 = rs1.getBytes("Archivo1");
                    OutputStream targetFile1 = new FileOutputStream(
                            dir.getCanonicalPath() + "\\" + rs1.getString("name1"));
                    targetFile1.write(fileBytes1);
                    targetFile1.close();
                    ok1 = true;
                }
                if (rs1.getBytes("Archivo2") != null) {

                    fileBytes1 = rs1.getBytes("Archivo2");
                    OutputStream targetFile1 = new FileOutputStream(
                            dir.getCanonicalPath() + "\\" + rs1.getString("name2"));
                    targetFile1.write(fileBytes1);
                    targetFile1.close();
                    ok1 = true;
                }

            }
            if (ok || ok1) {
                path = dir.getCanonicalPath();
            } else {
                path = "no hay nada";
            }

        } catch (Exception e) {
            path = "no hay nada";
            e.printStackTrace();
        }
        return path;
    }

    public int contarFiles(String cod) {
        int cont = 0;
        int c = Integer.parseInt(cod);
        String query, query1;
        Connection conn = getConnection();
        try {
            query = "select * from BD_CHIP.Phoenix.Imagenes where cod=" + c;
            query1 = "select * from BD_CHIP.Phoenix.Formulario where Id=" + c;
            Statement state = conn.createStatement();
            Statement state1 = conn.createStatement();
            ResultSet rs = state.executeQuery(query);
            ResultSet rs1 = state1.executeQuery(query1);

            while (rs.next()) {
                cont++;

            }
            while (rs1.next()) {
                if (rs1.getBytes("Archivo1") != null) {

                    cont++;
                }
                if (rs1.getBytes("Archivo2") != null) {

                    cont++;
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return cont;
    }

    //actualiza el estado de las solicitudes de RED a Aceptadas o Rechazadas según cambios realizados
    public boolean responder(String user, String sb, String sh, String comentario, String tasa, int id,
            String tasaS, String tmin, String topt, String spread, String pmonto, String cope, String cof, String priesgo) {

        boolean ok;

        try {

            Connection conn = getConnection();

            String query = "update Phoenix.Formulario set Score_Hipotecario='" + sh + "', Score_bureau='" + sb + "',"
                    + "Encargado_revision='" + user + "',Comentarios='" + comentario + "',"
                    + "Tasa_aceptada=" + Float.parseFloat(tasa) + ","
                    + "Prima_riesgo=" + Float.parseFloat(priesgo) + ",CoF=" + Float.parseFloat(cof) + ","
                    + "COpe=" + Float.parseFloat(cope) + ",Prima_monto=" + Float.parseFloat(pmonto) + ","
                    + "Spread=" + Float.parseFloat(spread) + ","
                    + "Tasa_Minima=" + Float.parseFloat(tmin) + ",Tasa_Optima=" + Float.parseFloat(topt) + ","
                    + "Estado=?,Fecha_Respuesta=getdate(), Fecha_Vencimiento=getdate()+29 where Id=" + id;
            Statement statement = conn.createStatement();
            PreparedStatement ps = conn.prepareStatement(query);
            if (tasa.equals(tasaS)) {
                ps.setString(1, "Aceptada");
            } else {
                ps.setString(1, "ContraOferta");
            }

            ps.executeUpdate();
            updateVencimiento();

            ok = true;

            conn.close();
            ps.close();
            statement.close();

        } catch (SQLException ex) {
            ok = false;
            System.out.println("error " + ex);
        }
        return ok;
    }

    //actualiza el estado de las solicitudes de FFVV a Aceptadas o Rechazadas según cambios realizados
    public boolean responderFFVV(String buro, String user, String sh, String comentario, String tasa, int id,
            String tasaS, String tmin, String topt, String spread, String pmonto, String cope, String cof, String priesgo) {

        boolean ok;

        try {

            Connection conn = getConnection();

            String query = "update Phoenix.Formulario set Score_bureau='" + buro + "',"
                    + "Score_Hipotecario='" + sh + "',Encargado_revision='" + user + "',Comentarios='" + comentario + "',"
                    + "Tasa_aceptada=" + Float.parseFloat(tasa) + ","
                    + "Prima_riesgo=" + Float.parseFloat(priesgo) + ",CoF=" + Float.parseFloat(cof) + ","
                    + "COpe=" + Float.parseFloat(cope) + ",Prima_monto=" + Float.parseFloat(pmonto) + ","
                    + "Spread=" + Float.parseFloat(spread) + ","
                    + "Tasa_Minima=" + Float.parseFloat(tmin) + ",Tasa_Optima=" + Float.parseFloat(topt) + ","
                    + "Estado=?,Fecha_Respuesta=getdate(), Fecha_Vencimiento=getdate()+29 where Id=" + id;
            Statement statement = conn.createStatement();
            PreparedStatement ps = conn.prepareStatement(query);

            if (tasa.equals(tasaS)) {
                ps.setString(1, "Aceptada");
            } else {
                ps.setString(1, "ContraOferta");
            }

            ps.executeUpdate();
            enviarMail(id);
            updateVencimiento();
            ok = true;

            conn.close();
            ps.close();
            statement.close();

        } catch (SQLException ex) {
            ok = false;
            System.out.println("error " + ex);
        }
        return ok;
    }

    public boolean rechazadasFFVV(String user, int id, String comentario) {

        boolean ok;

        try {

            Connection conn = getConnection();

            String query = "update Phoenix.Formulario set Encargado_revision='" + user + "',Comentarios='" + comentario + "',"
                    + "Estado='Rechazada',Fecha_Respuesta=getdate() where Id=" + id;
            Statement statement = conn.createStatement();
            PreparedStatement ps = conn.prepareStatement(query);

            ps.executeUpdate();
            enviarMailRechazados(id);
            updateVencimiento();
            ok = true;

            conn.close();
            ps.close();
            statement.close();

        } catch (SQLException ex) {
            ok = false;
            System.out.println("error " + ex);
        }
        return ok;
    }

    public String validarRepeticiones(String dni, String monto, String tasa, String producto) {
        String ok = "";
        Connection conn = getConnection();
        String query;
        try {
            query = "select * from BD_CHIP.Phoenix.Formulario where Cod_doc='" + dni + "'";

            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(query);

            while (rs.next()) {
                //System.out.println("entrando al rs");
                if (rs.getString("Estado").equals("Rechazada")) {
                    ok = "ok";
                } else if ((dni.equals(rs.getString("Cod_doc")) && Float.parseFloat(monto) == Float.parseFloat(rs.getString("Prestamo"))
                        && Float.parseFloat(tasa) == rs.getFloat("Tasa_solicitada") && producto.equalsIgnoreCase(rs.getString("Producto_origen"))) == true) {
                    ok = "fail";
                    break;
                }

            }
        } catch (Exception e) {
            System.out.println(e);
            ok = "ok";
        }
        return ok;
    }
}
