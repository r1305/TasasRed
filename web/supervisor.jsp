<%@page import="ibk.dto.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=10" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Formulario</title>
        <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon" />
        <script src="js/jquery.min.js" type="text/javascript"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="css/formulario.css" rel="stylesheet" type="text/css"/>
        <script src="js/tables_supervisor.js" type="text/javascript"></script>
        <script src="js/calculadora.js" type="text/javascript"></script>
        <script>
            <%
                Cookie cookie = null;
                Cookie[] cookies = null;
                // Get an array of Cookies associated with this domain
                cookies = request.getCookies();
                String nombre = "";
                for (int i = 0; i < cookies.length; i++) {
                    System.out.println(cookies[i].getValue() + " - " + cookies[i].getValue());
                    if (cookies[i].getName().equals("user")) {
                        System.out.println(cookies[i].getValue());
                        nombre = cookies[i].getValue();
                    }
                }
                if (nombre == null || nombre.equals("") || nombre.length() > 10) {
                    response.sendRedirect("index.jsp");
                }
            %>
        </script>
    </head>
    <body>
        <!--Obtenemos el usuario-->
        <% String user = nombre;%>
        <!--Conexion a la BD-->
        <sql:setDataSource var="snapshot" driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
                           url="jdbc:sqlserver://b27279ch3w7"
                           user="chip"  password="jedi1234"/>
        <!--Contador de solicitudes pendientes del canal del supervisor-->
        <sql:query dataSource="${snapshot}" var="n">
            select COUNT(*) as numero from Phoenix.Formulario f 
            join
            Phoenix.Usuarios u
            on f.Usuario=u.Registro
            where Estado='Pendiente' and u.Canal=(select Canal from BD_CHIP.Phoenix.Usuarios where Registro='<%=user%>')
        </sql:query>
        <!--Contador de solicitudes aceptadas del canal del supervisor-->
        <sql:query dataSource="${snapshot}" var="a">
            select COUNT(*) as numero from Phoenix.Formulario f 
            join
            Phoenix.Usuarios u
            on f.Usuario=u.Registro
            where Estado='Aceptada' and u.Canal=(select Canal from BD_CHIP.Phoenix.Usuarios where Registro='<%=user%>') and dias>=0
        </sql:query>
        <!--Contador de solicitudes rechazadas del canal del supervisor-->
        <sql:query dataSource="${snapshot}" var="r">
            select COUNT(*) as numero from Phoenix.Formulario f 
            join
            Phoenix.Usuarios u
            on f.Usuario=u.Registro
            where Estado='ContraOferta' and u.Canal=(select Canal from BD_CHIP.Phoenix.Usuarios where Registro='<%=user%>') and dias>=0
        </sql:query>
        <!--Contador de solicitudes vencidas del canal del supervisor-->
        <sql:query dataSource="${snapshot}" var="v">
            select COUNT(*) as numero from Phoenix.Formulario f 
            join
            Phoenix.Usuarios u
            on f.Usuario=u.Registro
            where (Estado='ContraOferta'or Estado='Aceptada') and u.Canal=(select Canal from BD_CHIP.Phoenix.Usuarios where Registro='<%=user%>') and dias<0
        </sql:query>
        <!--Listado de solicitudes pendientes -->
        <sql:query dataSource="${snapshot}" var="result">

            select *,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end as prestamo,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','') 
            end as cuotaI,
            DATEDIFF(HH,fecha_solicitud,fecha_respuesta) as rpta,
            convert(nvarchar(255),DAY(fecha_solicitud))+'-'+convert(nvarchar(255),MONTH(fecha_solicitud))+'-'+convert(nvarchar(255),YEAR(fecha_solicitud)) as solicitud
            from BD_CHIP.Phoenix.Formulario f
            join
            Phoenix.Usuarios u
            on f.Usuario=u.Registro
            where u.canal=(select Canal from BD_CHIP.Phoenix.Usuarios where Registro='<%=user%>') and Estado='Pendiente' order by tiempo desc
        </sql:query>
        <!--Listado de solicitudes aceptadas -->
        <sql:query dataSource="${snapshot}" var="aceptada">
            select *,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end as prestamo,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','') 
            end as cuotaI,
            DATEDIFF(HH,fecha_solicitud,fecha_respuesta) as rpta,
            convert(nvarchar(255),DAY(fecha_solicitud))+'-'+convert(nvarchar(255),MONTH(fecha_solicitud))+'-'+convert(nvarchar(255),YEAR(fecha_solicitud)) as aprobacion
            from BD_CHIP.Phoenix.Formulario f
            join
            Phoenix.Usuarios u
            on f.Usuario=u.Registro
            where u.canal=(select Canal from BD_CHIP.Phoenix.Usuarios where Registro='<%=user%>') and Estado='Aceptada'  and dias>=0 order by tiempo desc
        </sql:query>
        <!--Listado de solicitudes rechazadas -->
        <sql:query dataSource="${snapshot}" var="contra">
            select *,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end as prestamo,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','') 
            end as cuotaI,
            DATEDIFF(HH,fecha_solicitud,fecha_respuesta) as rpta,
            convert(nvarchar(255),DAY(fecha_solicitud))+'-'+convert(nvarchar(255),MONTH(fecha_solicitud))+'-'+convert(nvarchar(255),YEAR(fecha_solicitud)) as aprobacion
            from BD_CHIP.Phoenix.Formulario f
            join
            Phoenix.Usuarios u
            on f.Usuario=u.Registro
            where u.canal=(select Canal from BD_CHIP.Phoenix.Usuarios where Registro='<%=user%>') and Estado='ContraOferta'  and dias>=0 order by tiempo desc
        </sql:query>

        <!--Listado de solicitudes vencidas -->
        <sql:query dataSource="${snapshot}" var="vencidas">
            select *,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end as prestamo,
            case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Cuota_inicial,0,0)),1),'.00','') 
            end as cuotaI,
            DATEDIFF(HH,fecha_solicitud,fecha_respuesta) as rpta,
            convert(nvarchar(255),DAY(fecha_solicitud))+'-'+convert(nvarchar(255),MONTH(fecha_solicitud))+'-'+convert(nvarchar(255),YEAR(fecha_solicitud)) as aprobacion
            from BD_CHIP.Phoenix.Formulario f
            join
            Phoenix.Usuarios u
            on f.Usuario=u.Registro
            where u.canal=(select Canal from BD_CHIP.Phoenix.Usuarios where Registro='<%=user%>') and (Estado='ContraOferta' or Estado='Aceptada') and dias<0 order by tiempo desc
        </sql:query>
        <!--Cabecera de página -->
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
    <div class="container" align="center" style="width: 88.5%">
        <br>
        <h3 style="color: grey"><b>El acuerdo de servicio es de 24 horas para la atención de solicitudes</b></h3>
        <br><ul class="nav nav-tabs nav-justified">
            <li class="active"><a data-toggle="tab" href="#enviadas" style="color:#0060B3"><b>Enviadas (<c:forEach var="b" items="${n.rows}">${b.numero}</c:forEach>)</b></a></li>
            <li><a data-toggle="tab" href="#aceptadas" style="color: #0060B3"><b>Aceptadas (<c:forEach var="b" items="${a.rows}">${b.numero}</c:forEach>) </b></a></li>
            <li><a data-toggle="tab" href="#contraOfertas" style="color: #0060B3"><b>Contra Ofertas (<c:forEach var="b" items="${r.rows}">${b.numero}</c:forEach>)</b></a></li>
            <li><a data-toggle="tab" href="#vencidas" style="color: #0060B3"><b>Vencidas (<c:forEach var="b" items="${v.rows}">${b.numero}</c:forEach>)</b></a></li>
                <li><a data-toggle="tab" href="#simulador" onclick="p();" style="color: #0060B3"><b>Simulador</b></a></li>
            </ul>

            <div class="tab-content" class="tab-content" style="margin-top: 15px">
                <!--Tab de solicitudes pendientes-->
                <div id="enviadas" class="tab-pane fade in active" style="margin-top: 15px">
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
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">
                                        <b>Fecha de Solicitud</b>
                                    </th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>DNI</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Monto Solicitado</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Moneda</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Plazo</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Producto</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Tasa ADQ</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Tasa Solicitada</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Motivo</b></th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="container" style="overflow-y: scroll;margin-top: -20px;max-height: 600px;width: 100%">    
                        <table class="table" border="1">
                            <tbody  class="searchable1" data-filter="#f1">
                            <c:forEach var="row" items="${result.rows}">
                                <tr style="text-align: center">
                                    <td style="font-size: 12px;vertical-align:middle;" width="10%">
                                        <a href="enviadasSup.jsp?cod=${row.Id}">${row.solicitud}</a>
                                        <c:choose>
                                            <c:when test="${row.tiempo<=480}">
                                                <span align="center" style="color:#00A94E; font-family: Webdings; font-weight:bold">n</span>
                                            </c:when>
                                            <c:when test="${row.tiempo<=1260}">
                                                <span align="center" style="color:#FACC2E; font-family: Webdings; font-weight:bold">n</span>
                                            </c:when>
                                            <c:when test="${row.tiempo>1260}">
                                                <span align="center" style="color:red; font-family: Webdings; font-weight:bold">n</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td style=";font-size: 12px;text-align: center;padding-right: -10px;vertical-align:middle;" align="center" width="10%">${row.Cod_doc}</td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.prestamo}</td>
                                    <td style=";font-size: 12px;text-align: center;padding-left: 3px;vertical-align:middle;" align="center" width="8%">${row.Moneda}</td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Plazo}</td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Producto_origen}</td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Tasa_ADQ}</td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Tasa_Solicitada}</td>                                  
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Motivo}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <!--Tab de solicitudes aceptadas-->
            <div id="aceptadas" class="tab-pane fade" style="margin-top: 15px">
                <div class="container" style="overflow-y: scroll;width:100%">
                    <div class="input-group">
                        <span class="input-group-addon" onclick="location.reload();">
                            <span class="glyphicon glyphicon-refresh"></span>
                            Actualizar
                        </span>
                        <input id="f2" type="text" class="form-control" placeholder="Ingrese consulta...">
                    </div>
                    <table class="table" border="1">
                        <thead  class="filters">
                            <tr>

                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">
                                    <b>Fecha de Aprobación</b>
                                </th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>DNI</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Monto Solicitado</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Moneda</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Plazo</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Producto</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Tasa Aprobada</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Vigencia(dias)</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Motivo</b></th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <div class="container" style="overflow-y: scroll;margin-top: -20px;max-height: 600px;width:100%">    
                    <table class="table" border="1">
                        <tbody class="searchable2" data-filter="#f2">
                            <c:forEach var="row" items="${aceptada.rows}">
                                <tr style="text-align: center">
                                    <td style="font-size: 12px;vertical-align:middle;" width="10%">
                                        <a href="respondidas_sup.jsp?cod=${row.Id}">${row.aprobacion}</a>                                        
                                    </td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Cod_doc}</td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.prestamo}</td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Moneda}</td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Plazo}</td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Producto_origen}</td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Tasa_aceptada}</td>
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.dias}
                                        <c:choose>
                                            <c:when test="${row.dias>20}">
                                                <span align="center" style="color:#009150; font-family: Webdings;; font-weight:bold">n</span>
                                            </c:when>
                                            <c:when test="${row.dias>10 && row.dias <21}">
                                                <span align="center" style="color:yellow; font-family: Webdings;; font-weight:bold">n</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span align="center" style="color:red; font-family: Webdings; font-weight:bold">n</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td> 
                                    <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Motivo}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <!--Tab de solicitudes rechazadas-->
            <div id="contraOfertas" class="tab-pane fade" style="margin-left: -14px;margin-top: 15px">
                <div class="container" style="overflow-y: scroll;width:100%">
                    <div class="input-group">
                        <span class="input-group-addon" onclick="location.reload();">
                            <span class="glyphicon glyphicon-refresh"></span>
                            Actualizar
                        </span>
                        <input id="f3" type="text" class="form-control" placeholder="Ingrese consulta...">
                    </div>
                    <table class="table" border="1">
                        <thead  class="filters">
                            <tr>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">
                                    <b>Fecha de Aprobación</b>
                                </th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>DNI</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Monto Solicitado</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Moneda</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Plazo</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Producto</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Tasa Mínima</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Tasa Solicitada</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Vigencia(dias)</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" ><b>Motivo</b></th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <div class="container" style="overflow-y: scroll;margin-top: -20px;max-height: 600px;width:100%">    
                    <table class="table" border="1">
                        <tbody class="searchable3" data-filter="#f3">
                            <c:forEach var="row" items="${contra.rows}">
                                <tr style="text-align: center">
                                    <td style="font-size: 12px;vertical-align:middle;" width="10%">
                                        <a href="respondidas_sup.jsp?cod=${row.Id}">${row.aprobacion}</a>
                                    </td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Cod_doc}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.prestamo}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Moneda}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Plazo}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Producto_origen}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Tasa_Aceptada}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Tasa_Solicitada}</td> 
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.dias}
                                        <c:choose>
                                            <c:when test="${row.dias>20}">
                                                <span align="center" style="color:#009150; font-family: Webdings;; font-weight:bold">n</span>
                                            </c:when>
                                            <c:when test="${row.dias>10 && row.dias <21}">
                                                <span align="center" style="color:yellow; font-family: Webdings;; font-weight:bold">n</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span align="center" style="color:red; font-family: Webdings; font-weight:bold">n</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td> 
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" >${row.Motivo}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <!--Tab de solicitudes vencidas-->
            <div id="vencidas" class="tab-pane fade" style="margin-left: -14px;margin-top: 15px">
                <div class="container" style="overflow-y: scroll;width:100%">
                    <div class="input-group">
                        <span class="input-group-addon" onclick="location.reload();">
                            <span class="glyphicon glyphicon-refresh"></span>
                            Actualizar
                        </span>
                        <input id="f4" type="text" class="form-control" placeholder="Ingrese consulta...">
                    </div>
                    <table class="table" border="1">
                        <thead  class="filters">
                            <tr>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">
                                    <b>Fecha de Aprobación</b>
                                </th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>DNI</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Monto Solicitado</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Moneda</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Plazo</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Producto</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Tasa Mínima</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Tasa Solicitada</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Vigencia(dias)</b></th>
                                <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" ><b>Motivo</b></th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <div class="container" style="overflow-y: scroll;margin-top: -20px;max-height: 600px;width:100%">    
                    <table class="table" border="1">
                        <tbody class="searchable4" data-filter="#f4">
                            <c:forEach var="row" items="${vencidas.rows}">
                                <tr style="text-align: center">
                                    <td style="font-size: 12px;vertical-align:middle;" width="10%">
                                        <a href="respondidas_sup.jsp?cod=${row.Id}">${row.aprobacion}</a>
                                    </td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Cod_doc}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.prestamo}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Moneda}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Plazo}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Producto_origen}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Tasa_Aceptada}</td>
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Tasa_Solicitada}</td> 
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${Math.abs(row.dias)}
                                        <c:choose>
                                            <c:when test="${row.dias>20}">
                                                <span align="center" style="color:#009150; font-family: Webdings;; font-weight:bold">n</span>
                                            </c:when>
                                            <c:when test="${row.dias>10 && row.dias <21}">
                                                <span align="center" style="color:yellow; font-family: Webdings;; font-weight:bold">n</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span align="center" style="color:red; font-family: Webdings; font-weight:bold">n</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td> 
                                    <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" >${row.Motivo}</td>
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
    <script src="js/bootstrap.min.js"></script>
</body>
</html>
