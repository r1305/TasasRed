<%@page import="ibk.dto.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--libreria para hacer los queries-->
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!--libreria para poder recorrer las filas que devuelven los queries-->
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=5" />
        <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon" />
        <script src="js/jquery.min.js" type="text/javascript"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="css/principal.css" rel="stylesheet" type="text/css"/>
        <script src="js/enviadas.js" type="text/javascript"></script>
        <title>Detalle de Solicitud</title>
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
        <!--conexión a la bd -->
        <sql:setDataSource var="snapshot" driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
                           url="jdbc:sqlserver://b27279ch3w7"
                           user="chip"  password="jedi1234"/>
        <!--query a ser recorrido más adelante almacenado en la variable RESULT-->
        <sql:query dataSource="${snapshot}" var="result">

            SELECT *,
            case Moneda
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
        <!--logo y banner según formato de IBK-->
        <%Conexion c = new Conexion();
            String user = nombre;%>
    <center>
        <div class="main" role="main" style="width: 100%" >
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

    <center>
        <div class="panel panel-default" style="width: 30%;height: 60%;margin-top: 20px"> 
            <!--con el c:forEach hacemos el recorrido de todas las filas que devuelve el query-->
            <c:forEach var="row" items="${result.rows}">
                <table align='center' style="width: 98%">                    
                    <tbody>
                        <tr align='center' style="background-color: #00A94E;color: #ffffff;text-align: center;vertical-align: central">
                            <td align='center' style="background-color: #00A94E;color: #ffffff;text-align: center;vertical-align: central">                                
                                <b style="text-align: center;vertical-align: central">Solicitud de TASA</b>
                            </td>
                            <td align='center' style="background-color: #00A94E;color: #ffffff;text-align: center;vertical-align: central">
                                <input type="button" id="back" type="button" onclick="location.href = 'formulario.jsp'" class="btn btn-default btn-sm" value="Atrás">
                            </td>
                        </tr>
                        <!--a partir de aquí se muestra el detalle de la solictud según el ID-->
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
                            <td style="vertical-align:middle;font-size: 14px">Valor Inmueble</td>
                            <td>
                                <input class="form-control" type='text' id='valorI' style="text-align: center" value="${row.money}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Valor Préstamo</td>
                            <td>
                                <input class="form-control" type='text' id='prestamo' style="text-align: center" value="${row.prestamo}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Cuota inicial</td>
                            <td>
                                <input class="form-control" type='text' id='cuotaI' style="text-align: center" name="cuotaI" value="${row.cuotaI}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Moneda</td>
                            <td>
                                <input class="form-control" type='text' id='moneda' style="text-align: center" name="cuotaI" value="${row.moneda}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Plazo(meses)</td>
                            <td><input class="form-control" type='text' id='pl' style="text-align: center" value="${row.plazo}" readonly=""></td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Producto</td>
                            <td>
                                <input class="form-control" type='text' id='producto' style="text-align: center" value="${row.producto_origen}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Medio de Calificación</td>
                            <td>
                                <input class="form-control" type='text' id='medio' style="text-align: center" value="${row.Medio_calificacion}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Mes estimado para desembolso</td>
                            <td>
                                <input class="form-control" type='text' id='mes' style="text-align: center" value="${row.Mes_desembolso}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Tipo de inmueble</td>
                            <td>
                                <input class="form-control" type='text' id='tipo' style="text-align: center" value="${row.Tipo_inmueble}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Vivienda</td>
                            <td>
                                <input class="form-control" type='text' id='vivienda' name="vivienda" style="text-align: center" value="${row.Nro_vivienda}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Tasa ADQ (%)</td>
                            <td><input class="form-control" readonly="" type='text' id='adq' style="text-align: center" value="${row.Tasa_ADQ}"></td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Tasa solicitada (%)</td>
                            <td><input class="form-control" readonly="" type='text' id='tasaS' style="text-align: center" value="${row.Tasa_Solicitada}">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Motivo de Baja de Tasa</td>
                            <td>
                                <input class="form-control" type='text' id='motivo' style="text-align: center" value="${row.motivo}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Segmento</td>
                            <td>
                                <input class="form-control" type='text' id='segmento' style="text-align: center" value="${row.Segmento}" readonly="">
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:middle;font-size: 14px">Cruce de Productos</td>
                            <td>
                                <input class="form-control" type='text' id='segmento' style="text-align: center" value="${row.Cruce_productos}" readonly="">
                            </td>
                        </tr>
                    </tbody>
                </table>
            </c:forEach>
        </div>
    </center>
    <!-- Boton para descargar archivos-->
    <center>
        <button type="button" onclick="descargar(${param.cod})">
            Descargar Archivos (<%=c.contarFiles(request.getParameter("cod"))%>)
        </button>
        <br><a href="\\hipotecario\Solicitudes\solicitud${param.cod}">Ver Archivos</a>

    </center>

    <script src="js/bootstrap.min.js"></script>
</body>
</html>
