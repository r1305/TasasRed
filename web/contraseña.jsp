<%-- 
    Document   : contraseña
    Created on : 30/05/2016, 03:30:31 PM
    Author     : BP2158
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cambio de contraseña</title>
        <script src="js/jquery.min.js" type="text/javascript"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <div role="dialog">
            <div class="modal-dialog modal-sm"> 
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header" style=";background: #00A94E">
                        <center><h4 class="modal-title" style="color: #ffffff" ><b>Cambio de Contraseña</b></h4></center>
                    </div>
                    <div class="modal-body" >
                        <form method="POST" action="ServletRegistro">
                            <div class="form-group">
                                <center>
                                    <label for="user" class="col-sm-6">Usuario:</label>
                                    <input type="text" style="width: 200px;height: 10px" class="form-control" name="user" id="user1" placeholder="Usuario">
                                </center>
                            </div>
                            <div class="form-group">
                                <center>
                                    <label for="pwd" class="col-sm-6" >Contraseña:</label>
                                    <input type="password" style="width: 200px;height: 10px" class="form-control" name="psw" id="psw1" placeholder="Contraseña nueva">
                                </center>
                            </div>
                            <center><input type="submit" class="btn btn-info" value="Registrar"></center>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script src="js/bootstrap.min.js"></script>
    </body>
</html>
