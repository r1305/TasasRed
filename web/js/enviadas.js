//descarga las imagenes en la ruta establecida
function descargar(id){
    var xhr=new XMLHttpRequest();
    xhr.onreadystatechange=function(){
        if(xhr.readyState===4){
            var data=xhr.responseText;
            alert("¡Descarga correcta!")
            alert("El archivo se encuentra en: "+data);
        }
    }
    xhr.open("POST","ServletDescargas?cod="+id,true);
    xhr.send();
}

