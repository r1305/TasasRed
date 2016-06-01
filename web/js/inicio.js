//función para responder (aceptar o contraofertar)
//las solicitudes de tasa creada
function aceptar() {

    var id = document.getElementById("id").value;
    var b = document.getElementById("buro").value;
    var h = document.getElementById("hipo").value;
    var tasa = document.getElementById("tasa").value;
    var tasaS = document.getElementById("tasaS").value;
    var u = document.getElementById("u").value;
    var c = document.getElementById("comentario").value;
    var tmin = document.getElementById("tmin").value;
    var topt = document.getElementById("topt").value;
    var spread = document.getElementById("sp").value;
    var pmonto = document.getElementById("prim").value;
    var cope = document.getElementById("cope").value;
    var cof = document.getElementById("cof").value;
    var priesgo = document.getElementById("pr").value;
    

    $.get
            ('ServletAceptadas', {
                id: id,
                user: u,
                sb: b,
                sh: h,
                tasa: tasa,
                tasaS: tasaS,
                comentario: c,
                tmin:tmin,
                topt:topt,
                spread:spread,
                priesgo:priesgo,
                cof:cof,
                cope:cope,
                pmonto:pmonto
            }, function (responseText) {
                if (responseText === "success") {
                    alert("Solicitud Respondida");
                    (window).location.href = 'principal.jsp';
                } else {
                    alert("Ha ocurrido un error");
                }
            });
}

//descarga los archivos adjuntos en la ruta especifica
function descargar() {
    var cod = document.getElementById("cod").value;
    $.post('ServletDescargas', {
        cod: cod

    }, function (responseText) {
        if (responseText === "no hay nada") {
            alert("¡No hay archivos adjuntos!");
            
        }
    });
}

//al abrir la solicitud
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
}

function topt() {

    var priesgo = parseFloat(document.getElementById("pr").value);
    var cofS = parseFloat(document.getElementById("cof").value);
    var cope = parseFloat(document.getElementById("cope").value);
    var prim = parseFloat(document.getElementById("prim").value);
    var sp = parseFloat(document.getElementById("sp").value);

    var sum = priesgo + cofS + cope + prim + sp;
    document.getElementById("topt").value = sum.toFixed(3);
    roa();

}