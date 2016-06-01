
<%@page import="ibk.dto.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--libreria para hacer la conexión a la base de datos-->
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!--libreria para recorrer las filas que devuelvan los query-->
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=5" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Formulario</title>
        <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon" />
        <script src="js/jquery.min.js" type="text/javascript"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="css/formulario.css" rel="stylesheet" type="text/css"/>
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

            function popup(id)
            {
                var x = screen.width / 2 - 700 / 2;
                var y = screen.height / 2 - 450 / 2;
                window.open('reenvio.jsp?cod=' + id, '_blank', 'width = 400, height = 350,left=' + x + ',top=' + y);
            }
        </script>
    </head>
    <body>
        <!--recibe el registro del usuario logeado-->
        <% String user = nombre;%>
        <!--conexión a la BD-->
        <sql:setDataSource var="snapshot" driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
                           url="jdbc:sqlserver://b27279ch3w7"
                           user="chip"  password="jedi1234"/>
        <!-- query para obtener la cantidad de solicitudes pendientes del usuario logeado-->
        <sql:query dataSource="${snapshot}" var="n">
            select COUNT(*) as numero from Phoenix.Formulario where Estado='Pendiente' and  [Usuario]='<%=user%>'
        </sql:query>
        <!-- query para obtener la cantidad de solicitudes aceptadas del usuario logeado-->
        <sql:query dataSource="${snapshot}" var="a">
            select COUNT(*) as numero from Phoenix.Formulario where Estado='Aceptada' and [Usuario]='<%=user%>'
        </sql:query>
        <!-- query para obtener la cantidad de solicitudes rechazadas del usuario logeado-->
        <sql:query dataSource="${snapshot}" var="r">
            select COUNT(*) as numero from Phoenix.Formulario where Estado='ContraOferta' and  [Usuario]='<%=user%>'
        </sql:query>
        <!-- query para obtener la cantidad de solicitudes vencidas del usuario logeado-->
        <sql:query dataSource="${snapshot}" var="v">
            select COUNT(*) as numero from Phoenix.Formulario where dias<0 and  [Usuario]='<%=user%>' and (Estado='Aceptada' or Estado='ContraOferta' or Estado='Pendiente')
        </sql:query>
        <!--Query para mostrar las solicitudes aceptadas con formato de monedas y fechas--> 
        <sql:query dataSource="${snapshot}" var="aceptada">
            SELECT *,case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end As prestamo,
            case Moneda 
            when 'Dolares ' then '$ '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','')
            end As cuotaI,
            DATEDIFF(HH,fecha_solicitud,fecha_respuesta) as rpta,
            convert(nvarchar(255),DAY(fecha_respuesta))+'-'+convert(nvarchar(255),MONTH(fecha_respuesta))+'-'+convert(nvarchar(255),YEAR(fecha_respuesta)) as aprobacion
            FROM [BD_CHIP].[Phoenix].[Formulario] where  [Usuario]='<%=user%>' and Estado='Aceptada' and dias >=0 order by 1
        </sql:query>
        <!--Logo y banner según IBK-->
        <%Conexion c = new Conexion();%>
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
    <center>
        <div class="container" align="center" style="width: 88.5%">
            <br>
            <h3 style="color: grey"><b>El acuerdo de servicio es de 24 horas para la atención de solicitudes</b></h3>
            <br>
            <br>
            <!--Tabs de bandeja de solicitudes-->
            <div class="container" style="margin-top: -20px;max-height: 600px;width: 100%">
                <center>
                    <table width="101%">
                        <tr style="background-color: #00A94E;height: 50px">
                            <th style="text-align: center;vertical-align:middle;"><a href="formulario.jsp" style="color: #FFFFFF"><b>Enviadas (<c:forEach var="b" items="${n.rows}">${b.numero}</c:forEach>)</b></a></th>
                            <th style=";background-color:#009042 ;text-align: center;vertical-align:middle;"><a  href="formulario2.jsp" style="color: #FFFFFF"><b>Aceptadas (<c:forEach var="b" items="${a.rows}">${b.numero}</c:forEach>)</b></a></th>
                            <th style="text-align: center;vertical-align:middle;"><a  href="formulario3.jsp" style="color: #FFFFFF"><b>Contra Ofertas (<c:forEach var="b" items="${r.rows}">${b.numero}</c:forEach>)</b></a></th>
                            <th style="text-align: center;vertical-align:middle;"><a  href="formulario4.jsp" style="color: #FFFFFF"><b>Vencidas (<c:forEach var="b" items="${v.rows}">${b.numero}</c:forEach>)</b></a></th>
                            <th style="text-align: center;vertical-align:middle;"><a  href="formulario5.jsp" style="color: #FFFFFF"><b>Solicitud</b></a></th>                               
                        </tr>
                    </table>
                </center>
                </div>
                <div class="tab-content" style="margin-top: -15px;">
                    <!--Tab de solicitudes aceptadas-->
                    <div id="aceptadas" class="tab-pane fade" style="margin-top: 15px">
                        <div class="container" style="overflow-y: scroll;width: 100%">
                            <table class="table" border="1">
                                <thead>
                                    <tr>

                                        <th style=";font-size: 16px;text-align: center;vertical-align:middle;" align="center" width="10%">
                                            <b>Fecha de Aprobación</b>
                                        </th>
                                        <th style=";font-size: 16px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>DNI</b></th>
                                        <th style=";font-size: 16px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Monto Solicitado</b></th>
                                        <th style=";font-size: 16px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Moneda</b></th>
                                        <th style=";font-size: 16px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Plazo</b></th>
                                        <th style=";font-size: 16px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Producto</b></th>
                                        <th style=";font-size: 16px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Tasa Aprobada</b></th>
                                        <th style=";font-size: 16px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Vigencia (dias)</b></th>
                                        <th style=";font-size: 16px;text-align: center;vertical-align:middle;" align="center" width="14%"><b>Motivo</b></th>
                                        <th style=";font-size: 16px;text-align: center;vertical-align:middle;" align="center" ><b>Reenvio</b></th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="container" style="overflow-y: scroll;margin-top: -20px;max-height: 600px;width: 100%">    
                            <table class="table" border="1">
                                <tbody class="searchable1">
                                <c:forEach var="row" items="${aceptada.rows}">
                                    <tr style="text-align: center">                                  
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;color: #000000" align="center" width="10%">
                                            <a style="color: #000000" href="respondidas.jsp?cod=${row.Id}">${row.aprobacion}</a>
                                        </td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Cod_doc}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.prestamo}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Moneda}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Plazo}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Producto_origen}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Tasa_aceptada}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.dias}
                                            <c:choose>
                                                <c:when test="${row.dias>20}">
                                                    <span align="center" style="color:#009150; font-family: Webdings; font-weight:bold" width="8%">n</span>
                                                </c:when>
                                                <c:when test="${row.dias>10 and row.dias<21}">
                                                    <span align="center" style="color:#009150; font-family: Webdings; font-weight:bold" width="8%">n</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span align="center" style="color:red; font-family: Webdings; font-weight:bold" width="8%">n</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td> 
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="14%">${row.Motivo}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" >
                                            <a href="#" onclick="popup(${row.Id});">Reenvio</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </center>

    <script src="js/bootstrap.min.js"></script>
</body>
</html>
