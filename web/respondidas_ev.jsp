<%@page import="ibk.dto.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=10" />
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
                for (int i = 0; i <cookies.length; i++) {
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
    <!--Al cargar la página se ejecutara el script p() para calcular la primad de riesgo-->
    <body onload="p();">
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
    <%Conexion c=new Conexion();
    String user=nombre;%>
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
        <center><div class="panel panel-default" style="width: 35%;height: 63%;margin-top: 1px">


                <table style="width: 95%"align='center'>
                    <tbody>

                        <tr>
                            <td align='center' style="background-color: #00A94E;color: #ffffff" colspan="2">
                                <button id="back" type="button" onclick="location.href = 'principal.jsp'"class="btn btn-default btn-sm">
                                    <span class="glyphicon glyphicon-arrow-left"></span> Atrás
                                </button>
                                <b style="margin-left: -80px">Solicitud de TASA</b>
                            </td>
                        </tr>
                        <tr>
                    <input type="text" id="id" hidden="" value="${row.Id}">
                    <input type="text" id="u" hidden="" value="<%= request.getParameter("u")%>">
                    </tr>
                    <tr>
                        <td><br>Nombre Cliente</td>
                        <td>
                            <br><input type="text" id="cli" style="text-align: center" readonly="true" class="form-control" value="${row.Nombre_Cliente}">
                        </td>
                    </tr>
                    <tr>
                        <td>DNI</td>
                        <td>
                            <input type="text" id="dni" style="text-align: center" readonly="true" class="form-control" value="${row.Cod_doc}">
                        </td>
                    </tr>
                    <tr>
                        <td>Producto</td>
                        <td>
                            <input type="text" id="prod" style="text-align: center" readonly="true" class="form-control" value="${row.Producto_origen}">
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">Moneda</td>
                        <td>
                            <input type="text" id="moneda" style="text-align: center" readonly="true" class="form-control" value="${row.Moneda}">
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">
                            Score Bureau
                        </td>
                        <td>
                            <input type="text" id="buro" style="text-align: center" readonly="true" class="form-control" value="${row.Score_bureau}">
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">
                            Score Hipotecario
                        </td>
                        <td>
                            <input type="text" id="hipo" style="text-align: center" readonly="true" class="form-control" value="${row.Score_Hipotecario}">
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">
                            Tasa ADQ (%)
                        </td>
                        <td>
                            <input type="text"  name="tasa" readonly="true" class="form-control" value="${row.Tasa_ADQ}">
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">
                            Tasa Solicitada (%)
                        </td>
                        <td>
                            <input type="text" readonly="" class="form-control" value="${row.Tasa_Solicitada}">
                        </td>
                    </tr>  
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">
                            <br>Prima de Riesgo (%)
                        </td>
                        <td>
                            <br><input type="text" id="pr" readonly="true" class="form-control" value="${row.Prima_riesgo}">
                        </td>
                    </tr> 
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">
                            Costo de Fondos (%)
                        </td>
                        <td>
                            <input type="text" id="cof" readonly="true" class="form-control" value="${row.CoF}">
                        </td>

                    </tr>
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">
                            Costo Operativo (%)
                        </td>

                        <td>
                            <input type="text" id="cope" readonly="true" class="form-control" value="${row.COpe}">
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">
                            Prima por Monto (%)
                        </td>
                        <td>
                            <input type="text" id="prim" readonly="true" class="form-control" value="${row.Prima_monto}">
                        </td>
                        <td>
                            <input type="text" id="sp" hidden="" value="${row.Spread}">
                        </td>
                    </tr> 
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">
                            Spread (%)
                        </td>                       
                        <td>
                            <input type="text" id="sp" readonly="true" class="form-control" value="${row.Spread}">
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">
                            Tasa Aprobada (%)
                        </td>
                        <td>
                            <input type="text" id="tasa" readonly="true" class="form-control" value="${row.Tasa_aceptada}">
                        </td>
                    </tr> 
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px">
                            Plazo (meses)
                        </td>
                        <td>
                            <input type="text" id="plazo" name="plazo" onchange="duration();" class="form-control" value="${row.Plazo}" readonly="">
                        </td>
                    </tr>
                    <tr>
                        <td id="tabla" colspan="2"></td>
                    </tr>
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px" class="control-label">Comentario Ejecutivo</td>
                        <td><textarea readonly="" type="text" rows="5"  class="form-control" >${row.ComentF}</textarea></td>
                    </tr>
                    <tr>
                        <td style="vertical-align:middle;font-size: 14px" class="control-label">Comentario Evaluador</td>
                        <td><textarea readonly="" type="text" rows="5"  class="form-control" >${row.Comentarios}</textarea></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </center>
    </c:forEach>
    <center>
        <button type="button" onclick="descargar()">Descargar Archivos (<%=c.contarFiles(Integer.parseInt(request.getParameter("cod")))%>)</button>
        <input type="text" value="${param.cod}" id="cod" hidden="">
        <br><a href="\\hipotecario\Solicitudes\solicitud${param.cod}">Ver Archivos</a>
    </center>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>
