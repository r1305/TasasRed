
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
                            <th style="text-align: center;vertical-align:middle;"><a  href="formulario2.jsp" style="color: #FFFFFF"><b>Aceptadas (<c:forEach var="b" items="${a.rows}">${b.numero}</c:forEach>)</b></a></th>
                            <th style="text-align: center;vertical-align:middle;"><a  href="formulario3.jsp" style="color: #FFFFFF"><b>Contra Ofertas (<c:forEach var="b" items="${r.rows}">${b.numero}</c:forEach>)</b></a></th>
                            <th style="text-align: center;vertical-align:middle;"><a  href="formulario4.jsp" style="color: #FFFFFF"><b>Vencidas (<c:forEach var="b" items="${v.rows}">${b.numero}</c:forEach>)</b></a></th>
                            <th style="background-color:#009042;text-align: center;vertical-align:middle;"><a  href="formulario5.jsp" style="color: #FFFFFF"><b>Solicitud</b></a></th>                               
                        </tr>
                    </table>
                </center>
            </div>
            <div class="tab-content" style="margin-top: 15px">
                <!--Tab de formulario-->
                <div id="solicitud" class="tab-pane fade">
                    <center>
                        <div class="panel panel-default" style="width: 43%;margin-top: 20px"> 

                            <form id="formulario" name="formulario" action="ServletFormulario" method="POST" enctype="multipart/form-data">
                                <table align='center' style="width: 98%;margin-top: 5px" >
                                    <thead>
                                    <th style="background-color: #00A94E;color: #ffffff;font-family: Calibri;height: 30px;text-align: center" colspan="2"><b>Solicitud de TASA</b></th>
                                    </thead>

                                    <tbody>
                                        <tr style="height: 50px">
                                            <td><br>Nombre del Cliente</td>
                                            <td>
                                                <br><input class="form-control" type='text' id='nombre' name="nombre" required="true" pattern="[Aa-Zz]" placeholder="Ejm: Apellido, Nombre">
                                            </td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td>DNI</td>
                                            <td>
                                                <input class="form-control" type='text' id='dni' name="dni" required="true" pattern="[0-9]{8}" placeholder="Ingrese DNI">
                                            </td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td>Valor Inmueble</td>
                                            <td>
                                                <input class="form-control" type='text' id='valorI' name="valorI" onchange="r();" placeholder="Ingrese valor del inmueble"required="true" pattern="[0-9]+([,\.][0-9]+)?">
                                            </td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td>Cuota inicial</td>
                                            <td><input class="form-control" type='text' id='cuotaI' name="cuotaI" onchange="r();" pattern="[0-9]+([,\.][0-9]+)?" required="" placeholder="Ingrese cuota inicial">
                                                <input type="checkbox" id="cuota1" onclick="ci();">No aplica</td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td>Financiamiento</td>
                                            <td>
                                                <input class="form-control" type='text' id='prestamo' name="prestamo" required="" readonly="">
                                            </td>
                                        </tr>                                  
                                        <tr style="height: 50px">
                                            <td>Moneda</td>
                                            <td>
                                                <select class="form-control" id="moneda" name="moneda">
                                                    <option>Soles</option>
                                                    <option>Dolares</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td>Plazo</td>
                                            <td><input class="form-control" type='text' id='pl' name="plazo" pattern="[0-9]+([,\.][0-9]+)?" required="" placeholder="Ingrese plazo en meses"></td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td>Producto</td>
                                            <td>
                                                <select class="form-control" id="prod" name="prod" onchange="compra();">
                                                    <option>Hipotecario</option>
                                                    <option>Préstamo con Garantía Hipotecaria</option>
                                                    <option>Libre Disponibilidad con Garantía Hipotecaria</option>
                                                    <option value="Compra deuda">Compra deuda</option> 
                                                    <option>Mi Vivienda</option>
                                                    <option>Crédito con ampliación</option>
                                                    <option>Crédito para construcción</option>
                                                    <option>Techo Propio</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td>Medio de Calificación</td>
                                            <td>
                                                <select class="form-control" id="medio" name="medio">
                                                    <option>Tradicional</option>
                                                    <option>Ahorro casa</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 50px">
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
                                        <tr style="height: 50px">
                                            <td>Tipo de inmueble</td>
                                            <td>
                                                <select class="form-control" id="tipo" name="tipo">
                                                    <option>Bien Futuro</option>
                                                    <option value="Bien Terminado">Bien Terminado</option>
                                                    <option>Proyecto otro banco</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td>Vivienda</td>
                                            <td>
                                                <select class="form-control" id="vivienda" name="vivienda" onchange="mv();">
                                                    <option>Primera</option>
                                                    <option>Segunda</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td>Tasa ADQ</td>
                                            <td><input class="form-control" type='text' id='adq' name="adq" onchange="mv();"  pattern="[0-9]+([,\.][0-9]+)?" placeholder="Ingrese tasa ADQ en %" required="">
                                                <input type="checkbox" id="adq1" onclick="adq.value = 0">No aplica</td>

                                        </tr>
                                        <tr style="height: 50px">
                                            <td>Tasa solicitada</td>
                                            <td><input class="form-control" type='text' id='tasaS' onchange="producto()" name="tasaS" pattern="[0-9]+([,\.][0-9]+)?" min="7" placeholder="Ingrese tasa solicitada en %" required=""></td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td>Motivo de Baja de Tasa</td>
                                            <td>
                                                <select class="form-control" onchange="motivo()" id="mot" name="mot">
                                                    <option>Competencia</option>
                                                    <option value="ADQ">Actualización de Tasa ADQ</option>
                                                    <option>Compra deuda</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 50px">
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
                                        <tr style="height: 50px">
                                            <td>Tenencia de Productos IB</td>
                                            <td>
                                                <br>
                                                <input type="checkbox" value="cts" id="cts" name="cts"> CTS<br>
                                                <input type="checkbox" value="planilla" id="planilla" name="planilla"> Planilla<br>
                                                <input type="checkbox" id="otros" onclick="otrosText.disabled = !this.checked">Otros
                                                <input type="text" name="otros" id="otrosText" disabled="disabled" />
                                            </td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td class="control-label">Comentarios</td>
                                            <td><br><textarea type="text" id="comentarioF" name="comentarioF" class="form-control" maxlength="255"></textarea></td>
                                        </tr>
                                        <tr style="height: 50px">
                                            <td rowspan="2">Archivos Adjuntos</td>
                                            <td align="center">
                                                <br><input type="file" name="f1" class="form-control">
                                                <br><input type="file" name="f2" class="form-control">
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <br>
                                <center><input type="submit" class="btn btn-success" value="Enviar Solicitud" ></center>
                            </form>
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
