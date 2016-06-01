//valida el login y redirige a las páginas que correspondan
function nuevaContraseña() {
    var u = prompt("Ingrese su registro");
    var p = prompt("Ingrese su nueva contraseña");
    
    alert("usuario: "+u+"/ncontraseña: "+p);
    /*$.get('ServletRegistro', {
        user: u, psw: p
    });*/

}
//cuando olvida contraseña
//valida que el usuario este registrado y redirecciona según perfil
function ver() {

    var u = document.getElementById("user1").value;
    var p = document.getElementById("psw1").value;
    $.get
            ('ServletRegistro', {
                user: u, psw: p
            }, function (responseText) {
                if (responseText === "jefe") {
                    (window).location.href = 'principal.jsp';
                } else if (responseText === "abp") {
                    (window).location.href = 'principal_abp.jsp';
                }  else if (responseText === "supervisor") {
                    (window).location.href = 'supervisor.jsp';
                } else if (responseText === "gerente") {
                    (window).location.href = 'gerente.jsp';
                } else if (responseText === "red") {
                    (window).location.href = 'formulario.jsp';
                } else if (responseText === "ffvv") {
                    (window).location.href = 'formulario_ffvv.jsp';
                } else if (responseText === "fail") {
                    $("p").css("color", "red");
                } else if (responseText === "no existe") {
                    alert("¡Usuario no autorizado!");
                }
            });
}

//validar el navegador
var navegador = navigator.userAgent;
if (navigator.userAgent.indexOf('Firefox') !== -1) {
    alert('Ingrese por otro navegador porfavor');
    window.stop();
} else if (navigator.userAgent.indexOf('Opera') !== -1) {
    alert('Ingrese por otro navegador porfavor');
    document.execCommand("Stop");
    window.stop();
}


//dehabilitar función de ver código fuente
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
