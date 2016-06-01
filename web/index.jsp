<!-- ********** LOGIN ***********-->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=5" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Login Hipotecario</title>
        <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon" />
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <script src="js/funciones.js"></script>
        <link href="css/index.css" rel="stylesheet" type="text/css"/>
        <script>
            if (${param.cod==1}) {
                alert("Contraseña incorrecta");
            } else if (${param.cod==2}) {
                alert("Usuario no autorizado");
            }

            function popup()
            {
                var x = screen.width / 2 - 700 / 2;
                var y = screen.height / 2 - 450 / 2;
                window.open('contraseña.jsp', '_blank','height=310,width=450,left=' + x + ',top=' + y);
            }
        </script>
    </head>
    <body style="margin: 18%">
    <center>
        <div class="panel panel-default" style="width: 480px;height: 280px">
            <form action="ServletLogin" method="Post">
                <table role="table" align="center" style="height: 100%;width: 100%">
                    <!-- cabecera de login-->
                    <thead>
                    <th colspan="3" style="background-color: #00A94E">
                        <img src="img/Logo IBK verde.jpg" alt=""/>
                        <b><h3 id="txt" style="font-family: Calibri">Control de Accesos</h3></b>
                    </th>
                    </thead>
                    <tbody>
                        <tr>
                            <td><br><br><br><label class="col-sm-3" for="user" >Usuario:</label></td>
                            <td><br><br><br><input type="text" class="col-sm-16" style=";width: 150px" class="form-control" id="user" name="user" placeholder="Ingrese usuario"></td>
                            <td  rowspan="3" style="padding-left: 45px">
                                <img id="hi_img" src="img/hipotecario.jpg" style="margin-top: 5px;margin-bottom: 20px"/>
                            </td>
                        </tr>
                        <tr>
                            <td ><br><label class="col-sm-3" style="margin-top: 5px" for="pwd" >Contraseña:</label></td>
                            <td ><br><input class="col-sm-16" style="margin-top: 5px;width: 150px" type="password" class="form-control" id="psw" name="psw" placeholder="Ingrese contraseña"></td>
                        </tr>
                        <tr>
                            <td colspan="2"><br><p style="margin-left: 115px;margin-top: -20px;color: #ffffff">Contraseña incorrecta</p></td>
                            <td></td>
                        </tr>
                        <tr style="vertical-align: central;text-align: center">
                            <td colspan="2" >
                                <br><input type="submit" id="login" style="width:135px;margin-top: -20px;margin-right: 20px;background: #00A94E;color: white" class="btn btn-default" value="Login">
                            </td>
                            <td>
                                <br><button type="button" style="margin-top: -20px;font-family: Calibri;background: #00A94E;color: white" class="btn btn-default" onclick="popup();">Olvidé mi contraseña</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </div>
    </center>
    <!--<script src="js/bootstrap.min.js"></script>-->
</body>
</html>
