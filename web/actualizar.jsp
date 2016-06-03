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
                        <center><h4 class="modal-title" ><b>Nueva Propuesta</b></h4></center>
                    </div>
                    <div class="modal-body">
                        <form action="ServletActualizacion" method="post" enctype="multipart/form-data">
                            <br>Tasa Aprobada Vencida (%)
                            <br><input type="text" name="tasaR" id="tasaR" placeholder="Ejm: 8.5" />
                            <br><input type="text" name="idR" id="idR" hidden="" value="${param.cod}">
                            <br><input type="file" name="imagen"  id="imagen"/>
                            <br>Comentario
                            <br><textarea type="textarea" id="comentarioR" name="comentarioR" maxlength="255" placeholder="Motivo de la nueva tasa"></textarea>
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
