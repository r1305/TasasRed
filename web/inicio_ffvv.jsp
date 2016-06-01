<%@page import="ibk.dto.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<html>
    <head>
        <title>Calculadora de Tasas</title>
        <meta http-equiv="X-UA-Compatible" content="IE=10" />
        <meta charset="utf-8">
        <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon" />
        <script src="js/jquery.min.js" type="text/javascript"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <script src="js/inicio_ffvv.js" type="text/javascript"></script>
        <link href="css/inicio.css" rel="stylesheet" type="text/css"/>
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
    <!-- al cargar la página se ejecutará los siguientes scripts -->
    <body onload="p(), roa()">
        <!-- Conexión a la BD -->
        <sql:setDataSource var="snapshot" driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
                           url="jdbc:sqlserver://b27279ch3w7"
                           user="chip"  password="jedi1234"/>
        <!-- Query para mostrar los datos de la solicitud clickeada -->
        <sql:query dataSource="${snapshot}" var="result">
            SELECT *,case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end as p,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Valor_inmueble,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Valor_inmueble,0,0)),1),'.00','') 
            end as vi,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','') 
            end as cuotaI
            FROM [BD_CHIP].[Phoenix].[Formulario] where Id= ${param.id}
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
            <div style="background-color: #00A94E;height: 50px;">
                <center>
                    <table height="50" align="center" >
                        <tr>
                            <td style="color: #ffffff;font-size: 22px;text-align: center"><b>¡Hola! <%=c.getNombre(user)%></b></td>
                        </tr>
                    </table>
                </center>
            </div>
        </div>
    </center>
    <br>
    <!-- Recorrido para mostrar los datos de la solicitud -->
    <c:forEach var="row" items="${result.rows}">
        <center>
            <div class="container">
                <center>
                    <table style="width: 100%;" align='center'>
                        <tr>
                            <td style="background-color: #00A94E;color: #ffffff;text-align: center;vertical-align: central" colspan="2">
                                <button id="back" type="button" onclick="location.href = 'principal.jsp'" class="btn btn-default btn-sm">
                                    <span class="glyphicon glyphicon-arrow-left"></span> Atrás
                                </button>
                                <b style="text-align: center;margin-right: -65px">Calculadora de TASA</b>
                            </td>
                        </tr>
                    </table>
                </center>
                <div class="panel panel-default" style="width: 50%;height: 550px;margin-top: 1px;float: left">

                    <!-- Detalle de solicitudes completas -->
                    <table style="width: 95%;" align='center'>
                        <tbody>

                            <tr>
                                <td><input type="text" id="id" hidden="" value="${row.Id}">
                                    <input type="text" id="u" hidden="" value="<%=user%>">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px"><br>Nombre</td>
                                <td>
                                    <br><input type="text" style="text-align: center" readonly="true" class="form-control" value="${row.Nombre_Cliente}">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">DNI</td>
                                <td>
                                    <input type="text" style="text-align: center" readonly="true" class="form-control" value="${row.Cod_doc}">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">Producto</td>
                                <td>
                                    <input type="text" style="text-align: center" readonly="true" class="form-control" value="${row.Producto_origen}">
                                    <input type="text" id="prod" style="text-align: center" hidden="" value="${row.Producto}">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">
                                    Plazo (meses)
                                </td>
                                <td>
                                    <input type="text" id="plazo" name="plazo" onchange="cfondo();" class="form-control" value="${row.Plazo}">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">
                                    Monto 
                                </td>
                                <td>
                                    <input type="text" style=" text-align: center" value="${row.p}" readonly="true" class="form-control">
                                    <input type="text" id="c" style=" text-align: center" onload="costo();" value="${row.Prestamo}" readonly="true" hidden="true">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">Cuota Inicial</td>
                                <td>
                                    <input type="text" id="cuotaI" style="text-align: center" readonly="true" class="form-control" value="${row.cuotaI}">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">Valor Inmueble</td>
                                <td>
                                    <input type="text" id="valorI" style="text-align: center" readonly="true" class="form-control" value="${row.vi}">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px" >Motivo</td>
                                <td>
                                    <input type="text" id="motivo" style="text-align: center" readonly="true" class="form-control" value="${row.motivo}">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">Cruce de productos</td>
                                <td>
                                    <input type="text" id="cruce" style="text-align: center" readonly="true" class="form-control" value="${row.cruce_productos}">
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
                                    Score Hipotecario
                                </td>
                                <td>
                                    <input type="text" style="text-align: center" readonly="true" class="form-control" value="${row.Score_Hipotecario}">                                
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">
                                    Score Bureau
                                </td>
                                <td>
                                    <select id="buro" class="form-control" onchange="p()">
                                        <option>Alto</option>
                                        <option>Medio</option>
                                        <option>Bajo</option>
                                        <option>Muy Bajo</option>
                                        <option>Rechazo</option>
                                        <option>No recomendable</option>

                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Score Hipotecario</td>
                                <td >
                                    <select id="hipo" name="hipo" class="form-control" onchange="p()">
                                        <option>Alto</option>
                                        <option>Medio</option>
                                        <option>Bajo</option>
                                        <option>Rechazo</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">
                                    Prima de Riesgo (%)
                                </td>
                                <td>
                                    <div id="prima">
                                        <input type='text' class="form-control" readonly="">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="panel panel-default" style="width: 50%;height: 550px;margin-top: 1px;float: right">
                    <table  style="width: 95%;" align='center'>
                        <tbody>
                            <tr hidden="">
                                <td style="vertical-align:middle;font-size: 14px">
                                    <br>Costo Operativo (%)
                                </td>
                                <td>
                                    <div  id="cos">
                                        <br><input type="text"  readonly="" >
                                    </div>
                                </td>
                            </tr>
                            <tr hidden="">
                                <td style="vertical-align:middle;font-size: 14px">
                                    Costo de Fondos (%)
                                </td>
                                <td>
                                    <div id="cdf">
                                        <input type="text" readonly="" >
                                    </div>
                                </td>
                            </tr>
                            <tr hidden="">
                                <td style="vertical-align:middle;font-size: 14px">
                                    Prima por Monto (%)
                                </td>
                                <td>
                                    <div id="mxp">
                                        <input type="text"  readonly="">
                                    </div>
                                </td>
                            </tr>
                            <tr hidden="">
                                <td style="vertical-align:middle;font-size: 14px">
                                    Spread (%)
                                </td>
                                <td>
                                    <div id="spread">
                                        <input type="text"  readonly="">
                                    </div>
                                </td>
                            </tr> 
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">
                                    <br>Tasa Mínima (%)
                                </td>
                                <td>
                                    <div>
                                        <br><input id="tmin" type="text" class="form-control" readonly="">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">
                                    Tasa Óptima (%)
                                </td>
                                <td>
                                    <div>
                                        <input id="topt" type="text" class="form-control" readonly="">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">
                                    Tasa ADQ (%)
                                </td>
                                <td>                                                                
                                    <input type="text" readonly="true" class="form-control" value="${row.Tasa_ADQ}">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">
                                    Tasa Solicitada (%)
                                </td>
                                <td>
                                    <input type="text" readonly="true" id="tasaS" class="form-control" value="${row.Tasa_Solicitada}">
                                </td>
                            </tr>  
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px">
                                    <br>Tasa Aprobada (%)
                                </td>
                                <td>
                                    <br><input type="text" id="tasa" onchange="roa();" class="form-control" value="${row.Tasa_Solicitada}">
                                </td>
                            </tr>                         
                            <tr>
                                <td class="control-label" style="vertical-align:middle;font-size: 14px">ROA (%)</td>
                                <td>
                                    <div>
                                        <input id="roa" type="text" class="form-control" readonly="true">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px" class="control-label">Comentario Ejecutivo</td>
                                <td><textarea readonly="" type="text" rows="5"  class="form-control" >${row.ComentF}</textarea></td>
                            </tr>
                            <tr>
                                <td style="vertical-align:middle;font-size: 14px" class="control-label">Comentario Evaluador</td>
                                <td><textarea id="comentario" type="text" rows="5"  class="form-control" ></textarea></td>
                            </tr>
                        </tbody>
                    </table>                    
                </div>
                <center>
                    <br>
                    <button type="button" id="aceptar" name="aceptar"  onclick="aceptar();" class="btn btn-success">Responder</button>
                    <!--boton rechazar-->
                    <button type="button" id="rechazar" name="rechazar" onclick="rechazar();" class="btn btn-danger">Rechazar</button>
                </center>
            </div>
            <c:choose>
                <c:when test="${row.Cont==2}">
                    <p style="color: red"><b>¡Repechaje¡</b></p>
                    <p style="color: red"><b>Tasa aprobada: ${row.Tasa_aceptada}</b></p>
                </c:when>
                <c:when test="${row.Cont>2}">
                    <p style="color: orange"><b>¡Actualización de Tasa¡</b></p>
                    <p style="color: orange"><b>Tasa aprobada: ${row.Tasa_aceptada}</b></p>
                </c:when>
            </c:choose>
            <br>
            <button type="button" onclick="descargar()">Descargar Archivos (<%=c.contarFiles(Integer.parseInt(request.getParameter("id")))%>)</button>
            <input type="text" value="${param.id}" id="cod" hidden="">
            <br><a href="\\hipotecario\Solicitudes\solicitud${param.id}">Ver Archivos</a>
        </center>
    </c:forEach>

    <script src="js/bootstrap.min.js"></script>
</body>
</html>
