<%-- 
    Document   : añadir
    Created on : 30/05/2016, 12:03:52 PM
    Author     : BP2158
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="js/jquery.min.js" type="text/javascript"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
    <center>
        <div role="dialog">
            <div class="modal-dialog modal-sm"> 
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header" style="background-color: #00A94E;color: #FFFFFF">
                        <center><h4 class="modal-title"><b>Añadir Archivo</b></h4></center>
                    </div>
                    <div class="modal-body">
                        <form action="Imagen" method="post" enctype="multipart/form-data">
                            <br><input type="file" name="archivo"/>
                            <br><input type="text" name="idA" id="idA" hidden="" value="${param.cod}">
                            <br><input type="submit" value="Registrar">
                        </form>
                    </div>
                </div>

            </div>
        </div>
    </center>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>
