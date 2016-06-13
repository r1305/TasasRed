
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
        <!--<script src="js/jquery.min.js" type="text/javascript"></script>-->
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="css/formulario.css" rel="stylesheet" type="text/css"/>
        <script src="js/formulario.js" type="text/javascript"></script>
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

            function actualizar() {
                location.reload("formulario.jsp");
                location.reload("formulario2.jsp");
                location.reload("formulario3.jsp");
                location.reload("formulario4.jsp");                                
                location.reload("formulario5.jsp");
            }

        </script>
    </head>
    <body onload="">
        <!--recibe el registro del usuario logeado-->
        <% String user = nombre;%>
        <!--conexión a la BD-->
        <sql:setDataSource var="snapshot" driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
                           url="jdbc:sqlserver://b27279ch3w7"
                           user="chip"  password="jedi1234"/>
        <!-- query para obtener la cantidad de solicitudes pendientes del usuario logeado-->
        <sql:query dataSource="${snapshot}" var="n">
            select COUNT(*) as numero from Phoenix.Formulario f
            join
            Phoenix.Usuarios u 
            on u.Registro=f.Usuario
            where u.Cod_Tienda=(select Cod_Tienda from Phoenix.Usuarios where Registro='<%=user%>') and f.Estado='Pendiente'
        </sql:query>
        <!-- query para obtener la cantidad de solicitudes aceptadas del usuario logeado-->
        <sql:query dataSource="${snapshot}" var="a">
            select COUNT(*) as numero from Phoenix.Formulario f
            join
            Phoenix.Usuarios u 
            on u.Registro=f.Usuario
            where u.Cod_Tienda=(select Cod_Tienda from Phoenix.Usuarios where Registro='<%=user%>') and  Estado='Aceptada'and dias>=0
        </sql:query>
        <!-- query para obtener la cantidad de solicitudes rechazadas del usuario logeado-->
        <sql:query dataSource="${snapshot}" var="r">
            select COUNT(*) as numero from Phoenix.Formulario f
            join
            Phoenix.Usuarios u 
            on u.Registro=f.Usuario
            where u.Cod_Tienda=(select Cod_Tienda from Phoenix.Usuarios where Registro='<%=user%>') and  Estado='ContraOferta'and dias>=0
        </sql:query>
        <!-- query para obtener la cantidad de solicitudes vencidas del usuario logeado-->
        <sql:query dataSource="${snapshot}" var="v">
            select COUNT(*) as numero from Phoenix.Formulario f
            join
            Phoenix.Usuarios u 
            on u.Registro=f.Usuario
            where u.Cod_Tienda=(select Cod_Tienda from Phoenix.Usuarios where Registro='<%=user%>') and dias<0 and (Estado='Aceptada' or Estado='ContraOferta' or Estado='Pendiente')
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
        <div class="container" align="center" >
            <br>
            <h3 style="color: grey"><b>El acuerdo de servicio es de 24 horas para la atención de solicitudes</b></h3>
            <br>
            <br>
            <!--Tabs de bandeja de solicitudes-->
            <div class="container" style="margin-top: -20px;width: 88.5%">
                <div class="input-group">
                    <span class="input-group-addon" onclick="location.reload();" style="background-color: #cccccc;color: #000000;font-style: inherit;float: left">
                        Actualizar
                    </span>
                </div>
                <center>
                    <table width="101%" border="1">
                        <tr style="background-color: #00A94E;height: 50px">
                            <th style="text-align: center;vertical-align:middle;width: 20.2%"><a onclick="actualizar()" href="formulario_gt.jsp" style="color: #FFFFFF"><b>Enviadas (<c:forEach var="b" items="${n.rows}">${b.numero}</c:forEach>)</b></a></th>
                            <th style="text-align: center;vertical-align:middle;width: 20.2%"><a onclick="actualizar()" href="formulario2_gt.jsp" style="color: #FFFFFF"><b>Aceptadas (<c:forEach var="b" items="${a.rows}">${b.numero}</c:forEach>)</b></a></th>
                            <th style="text-align: center;vertical-align:middle;width: 20.2%"><a onclick="actualizar()" href="formulario3_gt.jsp" style="color: #FFFFFF"><b>Contra Ofertas (<c:forEach var="b" items="${r.rows}">${b.numero}</c:forEach>)</b></a></th>
                            <th style="text-align: center;vertical-align:middle;width: 20.2%"><a onclick="actualizar()" href="formulario4_gt.jsp" style="color: #FFFFFF"><b>Vencidas (<c:forEach var="b" items="${v.rows}">${b.numero}</c:forEach>)</b></a></th>
                            <th style="background-color:#009042;text-align: center;vertical-align:middle;width: 20.2%"><a onclick="actualizar()" href="formulario5_gt.jsp" style="color: #FFFFFF"><b>Solicitud</b></a></th>                               
                        </tr>
                    </table>
                </center>
            </div>
            <div class="tab-content" style="margin-top: 15px">
                <!--Tab de formulario-->
                <div id="solicitud" class="tab-pane fade">
                    <center>
                        <div class="panel panel-default" style="width: 35%;margin-top: 10px;height: 100px"> 

                            <form id="formulario" name="formulario" action="ServletFormulario" method="POST" enctype="multipart/form-data">
                                <table align='center' style="width: 98%;margin-top: 5px" >
                                    <thead>
                                    <th style="background-color: #00A94E;color: #ffffff;font-family: Calibri;height: 30px;text-align: center" colspan="2"><b>Solicitud de TASA</b></th>
                                    </thead>

                                    <tbody>
                                        <tr style="height: 30px">
                                            <td>Nombre del Cliente</td>
                                            <td>
                                                <input class="form-control" type='text' id='nombre' name="nombre" required="true" pattern="[Aa-Zz]" placeholder="Ejm: Apellido, Nombre">
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>DNI</td>
                                            <td>
                                                <input class="form-control" type='text' id='dni' name="dni" required="true" pattern="[0-9]{8}" placeholder="Ingrese DNI">
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Valor Inmueble</td>
                                            <td>
                                                <input class="form-control" type='text' id='valorI' name="valorI" onchange="r();" placeholder="Ingrese valor del inmueble"required="true" pattern="[0-9]+([,\.][0-9]+)?">
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Cuota inicial</td>
                                            <td><input class="form-control" type='text' id='cuotaI' name="cuotaI" onchange="r();" pattern="[0-9]+([,\.][0-9]+)?" required="" placeholder="Ingrese cuota inicial">
                                                <input type="checkbox" id="cuota1" onclick="ci();">No aplica</td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Financiamiento</td>
                                            <td>
                                                <input class="form-control" type='text' id='prestamo' name="prestamo" required="" readonly="">
                                            </td>
                                        </tr>                                  
                                        <tr style="height: 30px">
                                            <td>Moneda</td>
                                            <td>
                                                <select class="form-control" id="moneda" name="moneda">
                                                    <option value="Soles">Soles</option>
                                                    <option value="Dolares">Dolares</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Plazo</td>
                                            <td><input class="form-control" type='text' id='pl' name="plazo" pattern="[0-9]+([,\.][0-9]+)?" required="" placeholder="Ingrese plazo en meses"></td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Producto</td>
                                            <td>
                                                <select class="form-control" id="prod" name="prod" onchange="compra();">
                                                    <option value="Hipotecario">Hipotecario</option>
                                                    <option value="Préstamo con Garantía Hipotecaria">Préstamo con Garantía Hipotecaria</option>
                                                    <option value="Libre Disponibilidad con Garantía Hipotecaria">Libre Disponibilidad con Garantía Hipotecaria</option>
                                                    <option value="Compra deuda">Compra deuda</option> 
                                                    <option value="Mi Vivienda">Mi Vivienda</option>
                                                    <option value="Crédito con ampliación">Crédito con ampliación</option>
                                                    <option value="Crédito para construcción">Crédito para construcción</option>
                                                    <option value="Techo Propio">Techo Propio</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Medio de Calificación</td>
                                            <td>
                                                <select class="form-control" id="medio" name="medio">
                                                    <option>Tradicional</option>
                                                    <option>Ahorro casa</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Mes estimado para desembolso</td>
                                            <td>
                                                <select class="form-control" id="mes" name="mes">
                                                    <option>Enero</option>
                                                    <option>Febrero</option>
                                                    <option>Marzo</option>
                                                    <option>Abril</option>
                                                    <option>Mayo</option>
                                                    <option>Junio</option>
                                                    <option>Julio</option>
                                                    <option>Agosto</option>
                                                    <option>Setiembre</option>
                                                    <option>Octubre</option>
                                                    <option>Noviembre</option>
                                                    <option>Diciembre</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Tipo de inmueble</td>
                                            <td>
                                                <select class="form-control" id="tipo" name="tipo">
                                                    <option>Bien Futuro</option>
                                                    <option value="Bien Terminado">Bien Terminado</option>
                                                    <option>Proyecto otro banco</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Vivienda</td>
                                            <td>
                                                <select class="form-control" id="vivienda" name="vivienda" onchange="mv();">
                                                    <option value="Primera">Primera</option>
                                                    <option value="Segunda">Segunda</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Tasa ADQ</td>
                                            <td><input class="form-control" type='text' id='adq' name="adq" onchange="mv();"  pattern="[0-9]+([,\.][0-9]+)?" placeholder="Ingrese tasa ADQ en %" required="">
                                                <input type="checkbox" id="adq1" onclick="adq.value = 0">No aplica
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Tasa solicitada</td>
                                            <td>
                                                <input class="form-control" type='text' id='tasaS' onchange="producto()" name="tasaS" pattern="[0-9]+([,\.][0-9]+)?" min="7" placeholder="Ingrese tasa solicitada en %" required="">
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Motivo de Baja de Tasa</td>
                                            <td>
                                                <select class="form-control" onchange="motivo()" id="mot" name="mot">
                                                    <option>Competencia</option>
                                                    <option value="ADQ">Actualización de Tasa ADQ</option>
                                                    <option>Compra deuda</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Segmento</td>
                                            <td>
                                                <select class="form-control" id="segmento" name="segmento">
                                                    <option>1A</option>
                                                    <option>1BC</option>
                                                    <option>2</option>
                                                    <option>3</option>
                                                    <option>4</option>
                                                    <option>5</option>
                                                    <option>6</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td>Tenencia de Productos IB</td>
                                            <td>
                                                <br>
                                                <input type="checkbox" value="cts" id="cts" name="cts"> CTS<br>
                                                <input type="checkbox" value="planilla" id="planilla" name="planilla"> Planilla<br>
                                                <input type="checkbox" id="otros" onclick="otrosText.disabled = !this.checked">Otros
                                                <input type="text" name="otros" id="otrosText" disabled="disabled" />
                                            </td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td class="control-label">Comentarios</td>
                                            <td><br><textarea type="text" id="comentarioF" name="comentarioF" class="form-control" maxlength="255"></textarea></td>
                                        </tr>
                                        <tr style="height: 30px">
                                            <td rowspan="2">Archivos Adjuntos</td>
                                            <td align="center">
                                                <br><input type="file" name="f1" class="form-control" style="height: 30px">
                                                <input type="file" name="f2" class="form-control" style="height: 30px">
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <br>
                                <center><input type="submit" class="btn btn-success" value="Enviar Solicitud" ></center>
                            </form>
                        </div>
                    </center>
                </div>
            </div>
        </div>
    </center>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>
