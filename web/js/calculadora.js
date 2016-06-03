//calcula la prima de riesgo a partir del Score Bureau e Hipotecario
function p() {
    costo();
    cfondo();
    var b = document.getElementById("buro").value;
    var h = document.getElementById("hipo").value;
    $.post('ServletPrima', {
        buro: b,
        hipo: h
    }, function (responseText) {
        $('#prima').html(responseText);
        
        $.post('ServletSpread', {
            
            color: document.getElementById("color").value,
            prod: document.getElementById("prod").value,
            moneda: document.getElementById("moneda").value
        }, function (responseText) {
            
            $('#spread').html(responseText);
            
            topt();
            tminima();
        });
    });
}
//calcula el ROA
function roa() {
    var t = parseFloat(document.getElementById("tasa").value);
    var pr = parseFloat(document.getElementById("pr").value);
    var cofS = parseFloat(document.getElementById("cof").value);
    var cope = parseFloat(document.getElementById("cope").value);

    var responseText = t - pr - cofS - cope;
    document.getElementById("roa").value = responseText.toFixed(3);

}

function cfondo() {
    var tipo = document.getElementById("prod").value;
    var moneda = document.getElementById("moneda").value;
    var plazo = document.getElementById("plazo").value;

    $.get
            ('ServletCoF', {
                plazo: plazo,
                tipo: tipo,
                moneda: moneda
            }, function (responseText) {

                $('#cdf').html(responseText);
                tminima();
            });

}

function costo() {
    var m = document.getElementById("c").value;
    var tipo = document.getElementById("prod").value;
    var moneda = document.getElementById("moneda").value;


    $.post('ServletCosto', {
        monto: m,
        tipo: tipo
    }, function (responseText) {
        $('#cos').html(responseText);
    });

    $.post('ServletPrimaMonto', {
        monto: m,
        tipo: tipo,
        moneda:moneda
    }, function (responseText) {
        $('#mxp').html(responseText);
    });

}

function tminima() {
    var priesgo = parseFloat(document.getElementById("pr").value);
    var cofS = parseFloat(document.getElementById("cof").value);
    var cope = parseFloat(document.getElementById("cope").value);
    var prim = parseFloat(document.getElementById("prim").value);

    var sum = priesgo + cofS + cope + prim;
    document.getElementById("tmin").value = sum.toFixed(3);
    topt();
}

function topt() {

    var priesgo = parseFloat(document.getElementById("pr").value);
    var cofS = parseFloat(document.getElementById("cof").value);
    var cope = parseFloat(document.getElementById("cope").value);
    var prim = parseFloat(document.getElementById("prim").value);
    var sp = parseFloat(document.getElementById("sp").value);

    var sum = priesgo + cofS + cope + prim + sp;
    document.getElementById("topt").value = sum.toFixed(3);

}

//Descarga los archivos de la BD en la ruta especificada
function descargar(id) {
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

//deshabilita la tecla F12 y el menú para ver el código fuente
/*document.onkeypress = function (event) {
 event = (event || window.event);
 if (event.keyCode == 123) {
 //alert('No F-12');
 return false;
 }
 }
 document.onkeydown = function (event) {
 event = (event || window.event);
 if (event.keyCode == 123) {
 //alert('No F-keys');
 return false;
 }
 }
 $(document).bind("contextmenu", function (e) {
 e.preventDefault();
 });*/
