<%-- 
    Document   : PruebasImagen
    Created on : 25/03/2016, 12:44:24 PM
    Author     : bp2158
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <form action="Imagen" method="Post" enctype="multipart/form-data">
            <input type="file" name="archivo">
            <input type="text" name="id">
            <input type="submit" value="guardar">
        </form>
    </body>
</html>
