<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Listaa veneet</title>
<!-- Stylesheet importit. Käytän Bootstrappia ja jatkan sitä omalla teemalla lokaalissa CSS-tiedostossa -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<link href="css/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>
<!--  Navigaatio  -->
<nav class="navbar navbar-expand-md navbar-dark navbar-fixed-top">
    <div class="container-fluid">
    <a class="navbar-brand" href="listaaVeneet.jsp">Veneohjelma</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarResponsive">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item active"><a href="listaaVeneet.jsp" class="nav-link">Venelista</a></li>
            <li class="nav-item"><a href="lisaaVene.jsp" class="nav-link">Uusi vene</a></li>
        </ul>
    </div>
    </div>
</nav>

<div class="dark-background container">
<!--  Otsikko  -->
<div class="spacer50"></div>
<h3 class="container">Venelista</h3>

<!--  Listaus  -->
<div class="container">
<form>
	<div class="form-group">
	<label>Hakusana:</label>
	<input type="text" id="hakusana" class="form-control col-4">
	</div>
	<input type="button" id="hae" value="Hae" class="btn btn-outline-light" style="margin-bottom: 20px;" onclick="haeTiedot()">
	<a href="lisaaVene.jsp" id="uusiVene" class="btn btn-outline-light" style="margin-bottom: 20px;">Uusi vene</a>
	<div class="spacer20"></div>
	<table id="venelista" class="container table">
		<thead>
			<tr>
				<th>Tunnus</th>
				<th>Nimi</th>
				<th>Merkki ja malli</th>
				<th>Pituus</th>
				<th>Leveys</th>
				<th>Hinta</th>
				<th>Muuta tai poista</th>
			</tr>
		</thead>
		<tbody id="tbody">
		</tbody>
	</table>
</form>
</div>
</div>
<!-- Footer -->

<div class="spacer20"></div>
 <footer>
     <div class="container-fluid padding">
         <div class="row text-center">
             <div class="col-12">
             <hr class="light">
             	<small>Ohjelmointi 2</small><br>
                <small>Copyright: Joona Mellin 2020</small><br>
                <small>Background image copyright: <a href="https://unsplash.com/photos/B7zI7Gd3rgQ">Johny Vino at Unsplash.com</a></small> 
             </div>
         </div>
     </div>
 </footer>

<!--  Bootstrapin JavaScript --> 
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>

<!-- Oma JavaScript -->
<script>
// Haetaan tiedot kun sivu avataan
haeTiedot();

//Asetetaan fokus hakusanan syöttämiseen
document.getElementById("hakusana").focus(); 

//Mahdollistetaan Enter-näppäimellä hakeminen
function enterLahettaa(event){ 
	if(event.keyCode==13){
		haeTiedot();
	}
}

// Tietojen hakeminen
function haeTiedot() {  
	document.getElementById("tbody").innerHTML = "";
	fetch("veneet/hakusana/" + document.getElementById("hakusana").value, {
		method: 'GET'
	})
		.then(function (response) {
			return response.json();
		})
		.then(function (responseJson) {
			var veneet = responseJson.veneet;
			var htmlStr = "";
			
			for (var i = 0; i < veneet.length; i++) {
				htmlStr+="<tr>";
				htmlStr+="<td>" + veneet[i].tunnus + "</td>";
				htmlStr+="<td>" + veneet[i].nimi + "</td>";
				htmlStr+="<td>" + veneet[i].merkkimalli + "</td>";
				htmlStr+="<td>" + veneet[i].pituus + "</td>";
				htmlStr+="<td>" + veneet[i].leveys + "</td>";
				htmlStr+="<td>" + veneet[i].hinta + "</td>";
				htmlStr+="<td class='lastrow'><a class='btn btn-outline-light listanappi' href='muutaVene.jsp?tunnus="+ veneet[i].tunnus +"'>Muuta</a>    "; 
	        	htmlStr+="<button class='btn btn-outline-light listanappi' onclick=poista(" + veneet[i].tunnus + ") >Poista</button></td>";
	        	htmlStr+="</tr>";
			}
			document.getElementById("tbody").innerHTML = htmlStr;
		}) 
}


// Veneen poistaminen kannasta
function poista(tunnus) {
	if(confirm("Poistetaanko vene " + tunnus + "?")){
		fetch("veneet/" + tunnus, { 
			method: 'DELETE'
		})
		.then(function (response) {
			return response.json()
		})
		.then(function (responseJson) {
			var vastaus = responseJson.response;
			if(vastaus==0) {
				document.getElementById("ilmo").innerHTML = "Veneen poisto epäonnistui.";
			} else if (vastaus==1) {
				document.getElementById("ilmo").innerHTML = "Veneen " + sahkoposti + "poisto onnistui.";
				haeTiedot();
			}
			setTimeout(function() { document.getElementById("ilmo").innerHTML=""; } , 5000);
		})
	}
}
</script>
</body>
</html>