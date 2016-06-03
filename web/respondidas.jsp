<%@page import="ibk.dto.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=5" />
        <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon" />        
        <!--<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>-->
        <script src="js/jquery.min.js" type="text/javascript"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="css/inicio.css" rel="stylesheet" type="text/css"/>
        <script src="js/calculadora.js" type="text/javascript"></script>
        <title>Detalle de Solicitudes Respondidas</title>
        <script>
            <%
                Cookie cookie = null;
                Cookie[] cookies = null;
                // Get an array of Cookies associated with this domain
                cookies = request.getCookies();
                String nombre = "";
                for (int i = 0; i < cookies.length; i++) {
                    if (cookies[i].getName().equals("user")) {
                        nombre = cookies[i].getValue();
                    }
                }

                if (nombre == null || nombre.equals("") || nombre.length() > 8) {
                    response.sendRedirect("index.jsp");
                }
            %>
        </script>
    </head>
    <body>
        <!-- Conexión a la BD -->
        <sql:setDataSource var="snapshot" driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
                           url="jdbc:sqlserver://b27279ch3w7"
                           user="chip"  password="jedi1234"/>
        <!-- Query para mostrar los datos de una solicitud -->
        <sql:query dataSource="${snapshot}" var="result">
            SELECT *,case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Valor_inmueble,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Valor_inmueble,0,0)),1),'.00','') 
            end as money,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end as prestamo,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','') 
            end as cuotaI
            FROM [BD_CHIP].[Phoenix].[Formulario] where Id=${param.cod}
        </sql:query>
        <!-- Cabecera de página -->
        <%Conexion c = new Conexion();
            String user = nombre;%>
    <center>
        <div class="main" role="main" style="width: 100%">
            <div class="header" style="width: 60%">
                <img src="img/Logo Ibk_verde_sinfondo.png" alt=""/>
                <!-- cerrar sesión del usuario logeado -->
                <a href="ServletLogout" id="logout">Cerrar sesión <span class="glyphicon glyphicon-log-in"></span></a>
            </div>
            <br>
            <br>
            <br>
            <div style="background-color: #00A94E;height: 50px;text-align:center">
                <table height="50" align="center" >
                    <tr>
                        <td style="color: #ffffff;font-size: 22px"><b>¡Hola! <%=c.getNombre(user)%></b></td>
                    </tr>
                </table>
            </div>
        </div>
    </center>
    <br>
    <!-- Recorrido para mostrar los datos de la solicitud -->
    <c:forEach var="row" items="${result.rows}">
        <center><div class="panel panel-default" style="width: 30%;height: 63%;margin-top: 1px">


                <table style="width: 98%"align='center'>
                    <tbody>

                        <tr align='center' style="background-color: #00A94E;color: #ffffff;text-align: center;vertical-align: central">
                            <td align='center' style="background-color: #00A94E;color: #ffffff;text-align: center;vertical-align: central" colspan="2">                                
                                <b style="text-align: center;vertical-align: central">Solicitud de TASA</b>
                            </td>
                            <td align='center' style="background-color: #00A94E;color: #ffffff;text-align: center;vertical-align: central" colspan="2">
                                <input type="button" id="back" type="button" onclick="location.href = 'formulario.jsp'" class="btn btn-default btn-sm" value="Atrás">
                            </td>
                        </tr>
                        <tr>
                            <td><br>Nombre Cliente</td>
                            
                            <td colspan="2">
                                <br><input type="text" id="cli" style="text-align: center" readonly="true" class="form-control" value="${row.Nombre_Cliente}">
                            </td>
                            
                        </tr>
                        <tr>
                            <td>DNI</td>
                            <td colspan="2">
                                <input type="text" id="dni" style="text-align: center" readonly="true" class="form-control" value="${row.Cod_doc}">
                            </td>
                        </tr>
                        <tr>
                            <td>Producto</td>
                            <td colspan="2">
                                <input type="text" id="prod" style="text-align: center" readonly="true" class="form-control" value="${row.Producto_origen}">
                            </td>
                        </tr>
                        <tr>
                            <td>Moneda</td>
                            <td colspan="2">
                                <input type="text" id="moneda" style="text-align: center" readonly="true" class="form-control" value="${row.Moneda}">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Monto 
                            </td>
                            <td colspan="2">
                                <input type="text" id="c" style=" text-align: center" class="form-control" value="${row.prestamo}" readonly="true" >
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Tasa ADQ (%)
                            </td>
                            <td colspan="2">
                                <input type="text"  name="tasa" readonly="true" class="form-control" value="${row.Tasa_ADQ}">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Tasa Solicitada (%)
                            </td>
                            <td colspan="2">
                                <input type="text" readonly="" class="form-control" value="${row.Tasa_Solicitada}">
                            </td>
                        </tr>  
                        <tr>
                            <td>
                                <br>Prima de Riesgo (%)
                            </td>
                            <td colspan="2">
                                <br><input type="text" id="pr" readonly="true" class="form-control" value="${row.Prima_riesgo}">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                Costo de Fondos (%)
                            </td>
                            <td colspan="2">
                                <input type="text" id="cof" readonly="true" class="form-control" value="${row.CoF}">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                Prima por Monto (%)
                            </td>
                            <td colspan="2">
                                <input type="text" id="prim" readonly="true" class="form-control" value="${row.Prima_monto}" >
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                Tasa Aprobada (%)
                            </td>
                            <td colspan="2">
                                <input type="text" id="tasa" readonly="true" class="form-control" value="${row.Tasa_aceptada}" >
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                Plazo (meses)
                            </td>
                            <td colspan="2">
                                <input type="text" id="plazo" name="plazo" class="form-control" value="${row.Plazo}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td id="tabla" colspan="2"></td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px" class="control-label">Comentario Ejecutivo</td>
                            <td colspan="2"><textarea readonly="" type="text" rows="5"  class="form-control" >${row.ComentF}</textarea></td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px" class="control-label">Comentario Evaluador</td>
                            <td colspan="2"><textarea readonly="" type="text" rows="5"  class="form-control" >${row.Comentarios}</textarea></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </center>
    </c:forEach>
    <!-- Boton Para descargar archivos-->
    <center>
        <button type="button" onclick="descargar(${param.cod});">Descargar Archivos (<%=c.contarFiles(request.getParameter("cod"))%>)</button>
        <br><a href="\\hipotecario\Solicitudes\solicitud${param.cod}">Ver Archivos</a>
    </center>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>
