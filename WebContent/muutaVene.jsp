<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<!-- Jquery import -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>
<title>Muuta veneen tietoja</title>
<!-- Stylesheet importit. K‰yt‰n Bootstrappia ja jatkan sit‰ omalla teemalla lokaalissa CSS-tiedostossa -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<link href="css/stylesheet.css" rel="stylesheet">
</head>
<body>

<!-- Navigaatio -->
<nav class="navbar navbar-expand-md navbar-dark sticky-top" >
     <div class="container-fluid">
     <a class="navbar-brand" href="listaaVeneet.jsp">Veneohjelma</a>
     <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive">
         <span class="navbar-toggler-icon"></span>
     </button>
     <div class="collapse navbar-collapse" id="navbarResponsive">
         <ul class="navbar-nav ml-auto">
             <li class="nav-item"><a href="listaaVeneet.jsp" class="nav-link">Venelista</a></li>
             <li class="nav-item active"><a href="uusiVene.jsp" class="nav-link">Uusi vene</a></li>
         </ul>
     </div>
     </div>
 </nav>

<!-- Otsikko -->
<div class="spacer50"></div>
<h3 class="container">Veneen tietojen muuttaminen</h3><br>

<!--  Lomake -->
<form id="lomake" class="container">
	<div class="form-group">
		<label for="nimi">Veneen nimi:</label>
		<input type="text" id="nimi" name="nimi" class="form-control">
	</div>
	<div class="form-group">
		<label for="merkkimalli">Merkki ja malli:</label>
		<input type="text" id="merkkimalli" name="merkkimalli" class="form-control">
	</div>
	<div class="form-group">
		<label for="pituus">Pituus:</label>
		<input type="text" id="pituus" name="pituus" class="form-control">
	</div>
	<div class="form-group">
		<label for="leveys">Leveys:</label>
		<input type="text" id="leveys" name="leveys" class="form-control">
	</div>
	<div class="form-group">
		<label for="hinta">Hinta:</label>
		<input type="text" id="hinta" name="hinta" class="form-control">
	</div>
	<div class="form-group">
		<input type="hidden" id="tunnus" name="tunnus">
		<input type="button" id="tallenna" name="nappi" value="Muuta vene" onclick="lahetaTiedot()" class="btn btn-outline-light">
		<a href="listaaVeneet.jsp" type="button" id="peruuta" class="btn btn-outline-light">Peruuta</a>
	</div>
</form>

<span id="ilmo" class="container"></span>

<!-- Footer -->
<div class="spacer20"></div>
 <footer>
     <div class="container-fluid padding">
         <div class="row text-center">
             <div class="col-12">
             <hr class="light">
             	<small>Ohjelmointi 2</small><br>
                <small>Copyright: Joona Mellin 2020</small><br>
             </div>
         </div>
     </div>
 </footer>

<!--  Bootstrapin JavaScript. Huom, Jquery light otettu pois sill‰ sotkee muuten sivun jquery scriptit jotka tarvitsee 'aidon' jqueryn lightin sijaan --> 
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>

<!-- Oma JavaScript  -->
<script>

// Tartutaan lomakkeen ensimm‰iseen kentt‰‰n
document.getElementById("nimi").focus();

//Mahdollistetaan tietojen hakeminen Enter-n‰pp‰imell‰
function enterLahettaa(event){ 
	if(event.keyCode==13){
		lahetaTiedot();
	}
}

// Haetaan URL:ista veneen tunnus
var tunnus = requestURLParam("tunnus");

function requestURLParam(sParam){
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split("&");
    for (var i = 0; i < sURLVariables.length; i++){
        var sParameterName = sURLVariables[i].split("=");
        if(sParameterName[0] == sParam){
            return sParameterName[1];
        }
    }
}

// Ajetaan sivun auetessa:
$(document).ready(function(){
	
	// Haetaan lomakkeeseen veneen tiedot
	var url_id = requestURLParam("tunnus");
	console.log("Haetaan tiedot veneelle " + tunnus);
	$.getJSON({url:"veneet/" + url_id, type:"GET", dataType:"json", success:function(result) {
		console.log("Lˆydetty vene: " + result.nimi);
		$("#tunnus").val(result.tunnus);
		$("#nimi").val(result.nimi);
		$("#merkkimalli").val(result.merkkimalli);
		$("#pituus").val(result.pituus);
		$("#leveys").val(result.leveys);
		$("#hinta").val(result.hinta);
	}})
	
	$("#lomake").validate({	
		rules: {
			nimi: {
				required: true,
				minlength: 3,
				maxlength: 100
			},
			merkkimalli: {
				required: true,
				minlength: 3,
				maxlength: 100
			},
			pituus: {
				required: true,
				number:true
			},
			leveys: {
				required: true,
				number:true
			},
			hinta: {
				required: true,
				number:true
			},
		},
		messages: {
			nimi: {
				required: "Pakollinen tieto",
				minlength: "Liian lyhyt! Merkkej‰ oltava 3-100",
				maxlength: "Liian pitk‰! Merkkej‰ oltava 3-100"
			},
			merkkimalli: {
				required: "Pakollinen tieto",
				minlength: "Liian lyhyt! Merkkej‰ oltava 3-100",
				maxlength: "Liian pitk‰! Merkkej‰ oltava 3-100"
			},
			pituus: {
				required: "Pakollinen tieto",
				number: "Pituuden on oltava numeroarvo!"
			},
			leveys: {
				required: "Pakollinen tieto",
				number: "Leveyden on oltava numeroarvo!"
			},
			hinta: {
				required: "Pakollinen tieto",
				number: "Hinnan on oltava numeroarvo!"
			},
		},
		submitHandler: function(form) {
			lahetaTiedot();
		}
	});
});

// Muodostetaan lomakkeen tiedoista JSON-muotoinen sanoma
function formDataJsonStr(formArray) {
	var returnArray = {};
	for (var i = 0; i < formArray.length; i++){
		returnArray[formArray[i]['name']] = formArray[i]['value'];
	}
	return JSON.stringify(returnArray);
}

// L‰hetet‰‰n tiedot palvelimelle
function lahetaTiedot(){
	var formJsonStr = formDataJsonStr($("#lomake").serializeArray());
	console.log(formJsonStr);
	
	$.ajax({
		url:"veneet", 
		data:formJsonStr, 
		type:"PUT", 
		dataType:"json", 
		success:function(result) { 
			
        if(result.response==0){
        	$("#ilmo").html("Veneen lis‰‰minen ep‰onnistui");
        }else if(result.response==1){			
        	$("#nimi, #merkkimalli, #pituus, #leveys, #hinta").val("");
        	$("#ilmo").html("Veneen lis‰‰minen onnistui");
		}
    }});	
}
</script>
</body>
</html>