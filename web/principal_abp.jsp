<%@page import="ibk.dto.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=10" />
        <title>Solicitudes Pendientes</title>
        <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon" />        
        <script src="js/jquery.min.js" type="text/javascript"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="css/principal.css" rel="stylesheet" type="text/css"/>
        <script src="js/tables_evaluador.js" type="text/javascript"></script>
        <script src="js/calculadora.js" type="text/javascript"></script>
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
        <!--recibe el registro del usuario logeado-->
        <% String user = nombre;%>

        <!-- Conexión a la BD -->
        <sql:setDataSource var="snapshot" driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
                           url="jdbc:sqlserver://b27279ch3w7"
                           user="chip"  password="jedi1234"/>
        <!-- Query para las solicitudes pendiente del canal de RED -->
        <sql:query dataSource="${snapshot}" var="result">
            SELECT *,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end as prestamo,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','') 
            end as cuotaI,
            convert(nvarchar(255),DAY(fecha_solicitud))+'-'+convert(nvarchar(255),MONTH(fecha_solicitud))+'-'+convert(nvarchar(255),YEAR(fecha_solicitud)) as solicitud
            FROM [Phoenix].[Formulario] f   
            left join [BD_CHIP].[Phoenix].[Usuarios] u 
            on (f.Usuario=u.Registro) 
            where f.Estado='Pendiente' and u.Canal2='ABP' and f.Cont=1
            order by tiempo desc
        </sql:query>
        <!-- Query para las solicitudes pendiente de repechaje del canal de RED -->
        <sql:query dataSource="${snapshot}" var="repe_red">
            SELECT *,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end as prestamo,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','') 
            end as cuotaI,
            convert(nvarchar(255),DAY(fecha_solicitud))+'-'+convert(nvarchar(255),MONTH(fecha_solicitud))+'-'+convert(nvarchar(255),YEAR(fecha_solicitud)) as solicitud
            FROM [Phoenix].[Formulario] f   
            left join [BD_CHIP].[Phoenix].[Usuarios] u 
            on (f.Usuario=u.Registro) 
            where f.Estado='Pendiente' and u.Canal2='ABP' and f.Cont=2
            order by tiempo desc
        </sql:query>

        <!-- Query para contar las solicitudes pendiente del canal de RED -->
        <sql:query dataSource="${snapshot}" var="n">
            SELECT COUNT(*) as numero
            FROM [Phoenix].[Formulario] f   
            left join [BD_CHIP].[Phoenix].[Usuarios] u 
            on (f.Usuario=u.Registro) 
            where f.Estado='Pendiente' and u.Canal2='ABP' and f.Cont=1
        </sql:query>

        <!-- Query para contar las solicitudes pendiente de repechaje del canal de RED -->
        <sql:query dataSource="${snapshot}" var="repe_red_n">
            SELECT COUNT(*) as numero
            FROM [Phoenix].[Formulario] f   
            left join [BD_CHIP].[Phoenix].[Usuarios] u 
            on (f.Usuario=u.Registro) 
            where f.Estado='Pendiente' and u.Canal2='ABP' and f.Cont=2
        </sql:query>
        <!-- Query para contar las solicitudes aceptadas según encargado -->
        <sql:query dataSource="${snapshot}" var="a">
            select COUNT(*) as numero from Phoenix.Formulario where Estado='Aceptada' and Encargado_revision='<%=user%>'
        </sql:query>

        <!-- Query para contar las solicitudes contraOfertas según encargado -->
        <sql:query dataSource="${snapshot}" var="r">
            select COUNT(*) as numero from Phoenix.Formulario where Estado='ContraOferta' and Encargado_revision='<%=user%>'
        </sql:query>

        <!-- Query para mostrar todas las solicitudes aceptadas por el usuario logeado -->
        <sql:query dataSource="${snapshot}" var="aceptada">
            SELECT *,case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end as prestamo,
            convert(nvarchar(255),DAY(fecha_respuesta))+'-'+convert(nvarchar(255),MONTH(fecha_respuesta))+'-'+convert(nvarchar(255),YEAR(fecha_respuesta)) as aprobacion
            FROM [Phoenix].[Formulario] f   
            left join [BD_CHIP].[Phoenix].[Usuarios] u 
            on (f.Usuario=u.Registro) 
            where f.Estado='Aceptada' and Encargado_revision='<%=user%>'
            order by 1
        </sql:query>
        <!-- Query para mostrar todas las solicitudes rechazadas por el usuario logeado -->
        <sql:query dataSource="${snapshot}" var="contra">
            SELECT *,case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end as prestamo,
            convert(nvarchar(255),DAY(fecha_respuesta))+'-'+convert(nvarchar(255),MONTH(fecha_respuesta))+'-'+convert(nvarchar(255),YEAR(fecha_respuesta)) as aprobacion
            FROM [Phoenix].[Formulario] f   
            left join [BD_CHIP].[Phoenix].[Usuarios] u 
            on (f.Usuario=u.Registro) 
            where f.Estado='ContraOferta' and Encargado_revision='<%=user%>'
            order by 1
        </sql:query>
        <!-- cabecera de página-->
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
            <ul class="nav nav-tabs nav-justified">
                <li class="active"><a data-toggle="tab" href="#abp" style="color: #0060B3;font-size: 13px"><b>Pendientes (<c:forEach var="b" items="${n.rows}">${b.numero}</c:forEach>)</b></a></li>                
                <li><a data-toggle="tab" href="#repe_abp" style="color: #0060B3;font-size: 13px"><b>Repechaje (<c:forEach var="b" items="${repe_red_n.rows}">${b.numero}</c:forEach>)</b></a></li>                
                <li><a data-toggle="tab" href="#aceptadas" style="color: #0060B3;font-size: 13px"><b>Aceptadas (<c:forEach var="b" items="${a.rows}">${b.numero}</c:forEach>) </b></a></li>
                <li><a data-toggle="tab" href="#rechazadas" style="color: #0060B3;font-size: 13px"><b>Contra Ofertas (<c:forEach var="b" items="${r.rows}">${b.numero}</c:forEach>)</b></a></li>
                    <li><a data-toggle="tab" href="#simulador" onclick="p();"style="color: #0060B3;font-size: 13px"><b>Simulador</b></a></li>
                </ul>
                <!-- Contenido de los tabs -->
                <div class="tab-content" style="margin-top: 15px">
                    <!-- Solicitudes pendientes de ABP -->
                    <div id="abp" class="tab-pane fade in active">
                        <div class="container" style="overflow-y: scroll;width:100%">
                            <div class="input-group"> 
                                <span class="input-group-addon" onclick="location.reload();">
                                    <span class="glyphicon glyphicon-refresh"></span>
                                    Actualizar
                                </span>
                                <input id="f1" type="text" class="form-control" placeholder="Ingrese consulta...">
                            </div>
                            <table class="table" border="1">
                                <thead class="filters">
                                    <tr>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">Fecha de Solicitud</th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="8%">Usuario</th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Canal</th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Tasa ADQ</th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Tasa Solicitada</th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="8%">Plazo</th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="12%">Motivo</th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Producto</th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Monto Solicitado</th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;">Moneda</th>

                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="container" style="overflow-y: scroll;margin-top: -20px;max-height: 600px;width:100%">
                            <table class="table" border="1">
                                <tbody class="searchable1" data-filter="#f1">
                                <c:forEach var="a" items="${result.rows}">
                                    <tr style="text-align: center">
                                        <td style="font-size: 12px;vertical-align:middle" width="10%"><a href="inicio_abp.jsp?id=${a.Id}">${a.solicitud}</a>
                                            <c:choose>
                                                <c:when test="${a.tiempo<=480}">
                                                    <span align="center" style="color:#00A94E; font-family: Webdings; font-weight:bold">n</span>
                                                </c:when>
                                                <c:when test="${a.tiempo<=1260}">
                                                    <span align="center" style="color:#FACC2E; font-family: Webdings; font-weight:bold">n</span>
                                                </c:when>
                                                <c:when test="${a.tiempo>1260}">
                                                    <span align="center" style="color:red; font-family: Webdings; font-weight:bold">n</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="8%">${a.Usuario}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">${a.Canal}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">${a.Tasa_ADQ}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">${a.Tasa_Solicitada}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="8%">${a.Plazo}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="12%">${a.Motivo}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">${a.Producto_origen}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">${a.prestamo}</td>
                                        <td style="font-size: 12px;vertical-align:middle;">${a.Moneda}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- Solicitudes repechajes de ABP -->
                <div id="repe_abp" class="tab-pane fade">

                    <div class="container" style="overflow-y: scroll;width:100%">
                        <div class="input-group"> 

                            <span class="input-group-addon" onclick="location.reload();">
                                <span class="glyphicon glyphicon-refresh"></span>
                                Actualizar
                            </span>

                            <input id="f2" type="text" class="form-control" placeholder="Ingrese consulta...">
                        </div>
                        <table class="table" border="1">
                            <thead class="filters">
                                <tr>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">Fecha de Solicitud</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="8%">Usuario</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Canal</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Tasa ADQ</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Tasa Solicitada</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="8%">Plazo</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="12%">Motivo</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Producto</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Monto Solicitado</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;">Moneda</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="container" style="overflow-y: scroll;margin-top: -20px;max-height: 600px;width:100%">
                        <table class="table" border="1">
                            <tbody class="searchable2" data-filter="#f2">
                                <c:forEach var="a" items="${repe_red.rows}">
                                    <tr style="text-align: center">
                                        <td style="font-size: 12px;vertical-align:middle" width="10%"><a href="repe_abp.jsp?id=${a.Id}">${a.solicitud}</a>
                                            <c:choose>
                                                <c:when test="${a.tiempo<=480}">
                                                    <span align="center" style="color:#00A94E; font-family: Webdings; font-weight:bold">n</span>
                                                </c:when>
                                                <c:when test="${a.tiempo<=1260}">
                                                    <span align="center" style="color:#FACC2E; font-family: Webdings; font-weight:bold">n</span>
                                                </c:when>
                                                <c:when test="${a.tiempo>1260}">
                                                    <span align="center" style="color:red; font-family: Webdings; font-weight:bold">n</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="8%">${a.Usuario}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">${a.Canal}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">${a.Tasa_ADQ}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">${a.Tasa_Solicitada}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="8%">${a.Plazo}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="12%">${a.Motivo}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">${a.Producto_origen}</td>
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">${a.prestamo}</td>
                                        <td style="font-size: 12px;vertical-align:middle;">${a.Moneda}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- Solicitudes aceptadas-->
                <div id="aceptadas" class="tab-pane fade">
                    <div class="container" style="overflow-y: scroll;width:100%">
                        <div class="input-group">
                            <span class="input-group-addon" onclick="location.reload();">
                                <span class="glyphicon glyphicon-refresh"></span>
                                Actualizar
                            </span>
                            <input id="f5" type="text" class="form-control" placeholder="Ingrese consulta...">
                        </div>
                        <table class="table" border="1">
                            <thead>
                                <tr>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">Fecha de Respuesta</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="8%">Usuario</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Canal</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Tasa ADQ</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Tasa Aprobada</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="8%">Plazo</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="12%">Motivo</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Producto</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Monto Solicitado</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" >Moneda</th>

                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="container" style="overflow-y: scroll;margin-top: -20px;;max-height: 600px;width:100%">
                        <table class="table" border="1" id="datos">
                            <tbody class="searchable5" data-filter="#f5">
                                <c:forEach var="a" items="${aceptada.rows}">
                                    <tr style="text-align: center">
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">
                                            <a href="respondidas_abp.jsp?cod=${a.Id}">${a.aprobacion}</a>
                                        </td>
                                        <td style=";font-size: 12px;vertical-align:middle;" width="8%">${a.Usuario}</td>
                                        <td style=";font-size: 12px;vertical-align:middle;" width="10%">${a.Canal}</td>
                                        <td style=";font-size: 12px;vertical-align:middle;" width="10%">${a.Tasa_ADQ}</td>
                                        <td style=";font-size: 12px;vertical-align:middle;" width="10%">${a.Tasa_aceptada}</td>
                                        <td style=";font-size: 12px;vertical-align:middle;" width="8%">${a.Plazo}</td>
                                        <td style=";font-size: 12px;vertical-align:middle;" width="12%">${a.Motivo}</td>
                                        <td style=";font-size: 12px;vertical-align:middle;" width="10%">${a.Producto_origen}</td>
                                        <td style=";font-size: 12px;vertical-align:middle;" width="10%">${a.prestamo}</td>
                                        <td style=";font-size: 12px;vertical-align:middle;" >${a.Moneda}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- Solicitudes rechazadas-->
                <div id="rechazadas" class="tab-pane fade">
                    <div class="container" style="overflow-y: scroll;width:100%" >
                        <div class="input-group">
                            <span class="input-group-addon" onclick="location.reload();">
                                <span class="glyphicon glyphicon-refresh"></span>
                                Actualizar
                            </span>
                            <input id="f6" type="text" class="form-control" placeholder="Ingrese consulta...">
                        </div>
                        <table class="table" border="1">
                            <thead>
                                <tr>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">Fecha de Respuesta</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="8%">Usuario</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Canal</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Tasa ADQ</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Tasa Solicitada</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="8%">Plazo</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="12%">Motivo</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Producto</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" width="10%">Monto Solicitado</th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" >Moneda</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="container" style="overflow-y: scroll;margin-top: -20px;max-height: 600px;width:100%">
                        <table class="table" border="1" id="datos">
                            <tbody class="searchable6" data-filter="#f6">
                                <c:forEach var="a" items="${contra.rows}">

                                    <tr style="text-align: center">
                                        <td style="font-size: 12px" width="10%">
                                            <a href="respondidas_abp.jsp?cod=${a.Id}">${a.aprobacion}</a>
                                        </td>
                                        <td style=";font-size: 12px" width="8%">${a.Usuario}</td>
                                        <td style=";font-size: 12px" width="10%">${a.Canal}</td>
                                        <td style=";font-size: 12px" width="10%">${a.Tasa_ADQ}</td>
                                        <td style=";font-size: 12px" width="10%">${a.Tasa_Solicitada}</td>
                                        <td style=";font-size: 12px" width="8%">${a.Plazo}</td>
                                        <td style=";font-size: 12px" width="12%">${a.Motivo}</td>
                                        <td style=";font-size: 12px" width="10%">${a.Producto_origen}</td>
                                        <td style=";font-size: 12px" width="10%">${a.prestamo}</td>
                                        <td style=";font-size: 12px">${a.Moneda}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- Simulador -->
                <div id="simulador" class="tab-pane fade">
                    <center>
                        <div class="panel panel-default" style="width: 35%;margin-top: 15px">
                            <table style="width: 95%"align='center'>
                                <tbody>
                                    <tr>
                                        <td align='center' style="background-color: #00A94E;color: #ffffff;" colspan="2"><b>Calculadora de TASA</b></td>
                                    </tr>
                                    <tr>
                                        <td style="vertical-align:middle;font-size: 14px"><br>Producto</td>
                                        <td>
                                            <br><select id="prod" class="form-control" onchange="costo();cfondo();">
                                                <option>Hipotecario</option>
                                                <option>Mi Vivienda</option>
                                            </select>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td style="vertical-align:middle;font-size: 14px">
                                            Monto 
                                        </td>
                                        <td>
                                            <input type="text" id="c" onchange="costo();" class="form-control">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="vertical-align:middle;font-size: 14px">
                                            Plazo (meses)
                                        </td>
                                        <td>
                                            <input type="text" id="plazo" name="plazo" onchange="cfondo();" class="form-control" placeholder="Ingrese la cantidad de meses">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="vertical-align:middle;font-size: 14px">Moneda</td>
                                        <td>    
                                            <select id="moneda" class="form-control">
                                                <option>Soles</option>
                                                <option>Dolares</option>
                                            </select>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="vertical-align:middle;font-size: 14px">
                                            Score Bureau
                                        </td>
                                        <td>
                                            <select id="buro" class="form-control" onchange="p();">
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
                                        <td style="vertical-align:middle;font-size: 14px">
                                            Score Hipotecario
                                        </td>
                                        <td>
                                            <select id="hipo" class="form-control" onchange="p();">
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
                                                <input type="text" class="form-control" readonly="">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="vertical-align:middle;font-size: 14px">
                                            <br>Costo Operativo (%)
                                        </td>
                                        <td>
                                            <div  id="cos">
                                                <input type="text" class="form-control" readonly="">
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="vertical-align:middle;font-size: 14px">
                                            Prima por Monto (%)
                                        </td>
                                        <td>
                                            <div id="mxp">
                                                <input type="text" class="form-control" readonly="">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="vertical-align:middle;font-size: 14px">
                                            Spread (%)
                                        </td>
                                        <td>
                                            <div id="spread">
                                                <input type="text" class="form-control" readonly="">
                                            </div>
                                        </td>
                                    </tr>   
                                    <tr>
                                        <td style="vertical-align:middle;font-size: 14px">
                                            Costo de Fondos (%)
                                        </td>
                                        <td>
                                            <div id="cdf">
                                                <input type="text"class="form-control" readonly="">
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
                                            <br>Tasa aprobada (%)
                                        </td>
                                        <td>
                                            <br><input type="text" id="tasa" onchange="roa();" name="tasa" class="form-control" placeholder="Ingrese tasa mayor a 0">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="control-label" style="vertical-align:middle;font-size: 12px">ROA (%)</td>
                                        <td>
                                            <div>
                                                <input id="roa" type="text"  class="form-control" readonly="true">
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <br>
                        </div>
                    </center>
                </div>
            </div>
        </div> 
    </center>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>
