function calcular(){
	var tipoLic = document.getElementById("cmbTipoLic").value;	
    var cantidad = document.getElementById("txtCantidad");
    var precioUnidad = document.getElementById("PrecioUnidad").innerText.substring(1);
    var valorAct = document.getElementById("valor");
    var total = document.getElementById("total");
    //Subtotal
    var subTotal = precioUnidad * cantidad.value;
    while(valorAct.firstChild) {
		valorAct.removeChild(valorAct.firstChild);
	}
	valorAct.appendChild(document.createTextNode("$"+subTotal));
	//Valor Total
	while(total.firstChild) {
		total.removeChild(total.firstChild);
	}
	total.appendChild(document.createTextNode("$"+subTotal));
	document.getElementById("amount").value = subTotal;
    //cantidad.value = cantidad.value.toUpperCase();    
}

function calcularPagoUnico(codigoPlan, descripcionPlan, valorPlan){

	var cantidad = Number(document.getElementById("dataFormCant_" + codigoPlan).value);
	var meses = Number(document.getElementById("dataFormMes_" + codigoPlan).value);
	var licencia = Number(valorPlan);
	var precioUnidad = document.getElementById("total_" + codigoPlan);
	while(precioUnidad.firstChild) {
		precioUnidad.removeChild(precioUnidad.firstChild);
	}
	precioUnidad.appendChild(document.createTextNode("$"+licencia*cantidad*meses));
	
	document.getElementById("formulario_" + codigoPlan).elements.namedItem("amount").value = licencia*cantidad*meses;
	document.getElementById("formulario_" + codigoPlan).elements.namedItem("referenceCode").value = codigoPlan + "-" + Math.floor((Math.random() * (9999999 - 1000000)) + 1000000);
	document.getElementById("formulario_" + codigoPlan).elements.namedItem("description").value = "Licencia " + descripcionPlan;
	hash(codigoPlan);
}


function obtenerPrecio(){
	var tipoLic = document.getElementById("cmbTipoLic").value;	
	var precioUnidad = document.getElementById("PrecioUnidad");
	var valorPla = 0;
	switch(tipoLic){
    	case "1":
    		//gold
			document.getElementById("formularioGold").elements.namedItem("referenceCode").value = "lt1-" + Math.floor((Math.random() * (9999999 - 1000000)) + 1000000);
			document.getElementById("formularioGold").elements.namedItem("description").value = "Licencia Gold";
    		valorPla = 49;
    		break;
    	case "2":
    		//platino
			document.getElementById("formularioPlatinum").elements.namedItem("referenceCode").value = "lt2-" + Math.floor((Math.random() * (9999999 - 1000000)) + 1000000);
			document.getElementById("formularioPlatinum").elements.namedItem("description").value = "Licencia Platino";
    		valorPla = 69;
    		break;
    }
	while(precioUnidad.firstChild) {
		precioUnidad.removeChild(precioUnidad.firstChild);
	}
	precioUnidad.appendChild(document.createTextNode("$"+valorPla));
	var cantidad = document.getElementById("txtCantidad").value;
	if(cantidad != ""){
		calcular();
	}
}

function copyTextValue(bf) {
    document.getElementById("buyerEmail").value = bf.value;
}


function hash(codigoPlan){
	var concat = "4Vj8eK4rloUd272L48hsrarnUA~508029~" + document.getElementById("formulario_" + codigoPlan).elements.namedItem("referenceCode").value + "~" + document.getElementById("formulario_" + codigoPlan).elements.namedItem("amount").value + "~" + document.getElementById("formulario_" + codigoPlan).elements.namedItem("currency").value  
	var hash = md5(concat);
	document.getElementById("formulario_" + codigoPlan).elements.namedItem("signature").value= hash;
}