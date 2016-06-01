//descarga las imagenes en la ruta establecida
function descargar(id){
    $.post('ServletDescargas', {
            cod: id

        }, function (responseText) {
            if (responseText === "no hay nada") {
                alert("¡No hay archivos adjuntos!");
                
            } else {
                alert("Los archivos se encuentran en: \n"+responseText);
            }
        });
}

