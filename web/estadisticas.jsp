<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

    <head>
        <script src="http://canvasjs.com/assets/script/canvasjs.min.js"></script>

        <script type="text/javascript" src="/assets/script/canvasjs.min.js"></script>
    </head>
    <body>
        <sql:setDataSource var="snapshot" driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
                           url="jdbc:sqlserver://b27279ch3w7"
                           user="chip"  password="jedi1234"/>
        <!-- Query para mostrar los datos de la solicitud clickeada -->
        <sql:query dataSource="${snapshot}" var="prod">
            select Producto,COUNT(*) as contador from BD_CHIP.Phoenix.Formulario group by Producto
        </sql:query>
        <sql:query dataSource="${snapshot}" var="estado">
            select Estado,COUNT(*) as contador from BD_CHIP.Phoenix.Formulario group by Estado
        </sql:query>
        <sql:query dataSource="${snapshot}" var="canal">
            select Canal2,COUNT(*) as contador from BD_CHIP.Phoenix.Formulario f
            left join 
            BD_CHIP.Phoenix.Usuarios u
            on u.Registro=f.Usuario
            group by Canal2
        </sql:query>
        <sql:query dataSource="${snapshot}" var="equipo">
            select Canal,COUNT(*) as contador from BD_CHIP.Phoenix.Formulario f
            left join 
            BD_CHIP.Phoenix.Usuarios u
            on u.Registro=f.Usuario
            group by Canal
        </sql:query>

        <div class="container" style="overflow-y: scroll;margin-top: 15px;max-height: 390px;width:100%">
            <table style="width: 80%" align='center'>
                <tbody>
                    <tr>
                        <td><div id="producto" style="height: 450px;width: 500px;float: left"></div></td>
                        <td><center><div id="estado" style="height: 450px;width: 500px;float: right"></div></center></td>
                </tr>
                <tr>
                    <td><div id="canal" style="height: 450px;width: 500px;float: left"></div></td>
                    <td><div id="equipo" style="height: 450px;width: 500px;float: right"></div></td>
                </tr>
                </tbody>
            </table>
        </div>
        <script>
            setTimeout(
                    function () {
                    var chart = new CanvasJS.Chart("producto",
                    {
                    title:{
                    text: "Solicitudes por Producto",
                            fontSize: 20
                    }, data: [
                    {

                    dataPoints: [
            <c:forEach var="r" items="${prod.rows}">
                    {y: ${r.contador}, label: "${r.Producto}"},
            </c:forEach>

                    ]
                    }
                    ]
                    });
                    var chart1 = new CanvasJS.Chart("estado",
                    {
                    title:{
                    text: "Solicitudes por Estado",
                            fontSize: 20
                    }, data: [
                    {

                    dataPoints: [
            <c:forEach var="r" items="${estado.rows}">
                    {y: ${r.contador}, label: "${r.estado}"},
            </c:forEach>

                    ]
                    }
                    ]
                    });
                    var chart2 = new CanvasJS.Chart("canal",
                    {
                    title:{
                    text: "Solicitudes por Canal",
                            fontSize: 20
                    }, data: [
                    {

                    dataPoints: [
            <c:forEach var="r" items="${canal.rows}">
                    {y: ${r.contador}, label: "${r.Canal2}"},
            </c:forEach>

                    ]
                    }
                    ]
                    });
                    var chart3 = new CanvasJS.Chart("equipo",
                    {
                    title:{
                    text: "Solicitudes por Equipo",
                            fontSize: 20
                    }, data: [
                    {

                    dataPoints: [
            <c:forEach var="r" items="${equipo.rows}">
                    {y: ${r.contador}, label: "${r.Canal}"},
            </c:forEach>

                    ]
                    }
                    ]
                    });
                    chart.render();
                    chart1.render();
                    chart2.render();
                    chart3.render();
                    }, 500);
        </script>
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/bootstrap.min.js"></script>
    </body>

</html>
