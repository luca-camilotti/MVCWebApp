<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.util.ArrayList"  
    import="luke.models.classes.UploadItem"   
    import="luke.date.converter.DateConverter"
    import="luke.models.classes.User"    
%>

<%! private String commentModal = "//";
	private String context = null;
	private User getUser(HttpServletRequest request) {
		return (User) request.getSession().getAttribute("user");
	}
	private String username(HttpServletRequest request) {
		return getUser(request).getName();
	}
%>
<% context = getServletContext().getContextPath(); %>

<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BmbxuPwQa2lc/FVzBcNJ7UAyJxM6wuqIj61tLrc4wSX0szH/Ev+nYRRuWlolflfl" crossorigin="anonymous">
<link href='<%= context+"/" %>css/mycss.css' rel='stylesheet' type='text/css'>
<!-- Bootstrap Datepicker Css -->
<link href='<%= context+"/" %>css/bootstrap-datepicker.min.css' rel='stylesheet' type='text/css'>

<meta charset="ISO-8859-1">
<title>login</title>
</head>
<body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- Bootstrap Datepicker Js -->
<!-- https://makitweb.com/how-to-add-datepicker-in-bootstrap/ -->
<!-- https://bootstrap-datepicker.readthedocs.io/en/latest/ -->
<script src='<%= context+"/" %>js/bootstrap-datepicker.min.js' type='text/javascript'></script>
<script src='<%= context+"/" %>locales/bootstrap-datepicker.it.min.js' type='text/javascript'></script>


<script type="text/javascript">




/* jQuery password strength checker:
	
 * https://phppot.com/jquery/jquery-password-strength-checker/
 
   https://www.c-sharpcorner.com/Blogs/how-to-check-password-strength-in-jquery
 */
 

var myModal;  // modal with a form submit
var myModalMessage;  // modal with a message
var myForm; 
var uploadForm; 


$(document).ready(function(){
	if($('.toast .toast-body').html().trim()!="")
		$('.toast').toast('show');  // show the toast 
		

	// prevent the form to submit if date fiels is empty 
	$(document).on("click", "#submitForm", function () {
		
		// Options:
		// uploadForm.submit();  // 1) simply submit the form
			
		// Check if form is ok, otherwise return a toast message
		if($('#insertForm #date').val()=="") {
			event.preventDefault();  // don't submit the form
			$('.toast-body').html("Inserisci la data!");
			$('.toast').toast('show');
			return;
		}
	});
	
	/*
	myModalMessage = new bootstrap.Modal(document.getElementById('myModalMessage'), {
		backdrop: 'static',  // do not close modal if user click outside
		keyboard: false
	}) 
	
	
	// make a redirect when the modal closes
	var myModalM = document.getElementById('myModalMessage');
	myModalM.addEventListener('hidden.bs.modal', function(event) {
		$(location).attr('href', 'Login')  // redirect to a page
	});

	// $('#myModal').modal({backdrop: 'static', keyboard: false})
	myModal = new bootstrap.Modal(document.getElementById('myModal'), {
			backdrop : 'static', // do not close modal if user click outside
			keyboard : false
	})
<%= commentModal %>myModal.show();  // comment this line of code depending on commentModal value
	
	myForm = document.getElementById("modal-form-id");  // normal auth form
	
	uploadForm = document.getElementById("file-upload-form");	// upload file form
	*/
});




/*
// submit modal form
$(document).on("click", "#modal-form-submit", function () {
	myForm.submit();  // submit modal internal form
	//$(location).attr('href', 'Login')  // redirect
});


// upload file ajax request
$(document).on("click", "#inputGroupFileAddon", function () {
	event.preventDefault();
	// Options:
	// uploadForm.submit();  // 1) simply submit the form
	
	// Check if form is ok, otherwise return a toast message
	if($('#inputGroupFile').val()=="" || $('#datefile').val()=="") {
		$('.toast-body').html("Missing field!");
		$('.toast').toast('show');
		return;
	}
	
	// 2) Ajax request
	var data = new FormData(uploadForm);  // get form data
	
					$.ajax({  // send ajax request to FileUpload servlet
						type : "POST",
						enctype : 'multipart/form-data',
						url : 'FileUpload',
						data : data,
						processData : false,
						contentType : false,
						cache : false,
						success : function(responseText) {
							// $('#ajaxGetUserServletResponse').text(responseText);
							$('#myModalMessage .modal-body #modal-message').html(responseText);
							myModalMessage.show();
						}
					});
	
	
		


});

	$(document).on(
			"click",
			".btnModal",
			function() {
				//var x = new Date(); 
				//var myHeading = "<p>I Am Added Dynamically </p>";
				var message = $('.modal-body #modal-message').html(); // get inner html
				//$("#modal-body").html(myHeading + x);   
				$('#myModal .modal-body #modal-message').html(
						message + $(this).data('id') + '?'); // set inner html
				$('#myModal .modal-body #myId').val($(this).data('id')); // get the value of data-id attribute
				myModal.show();
			});
*/
</script>
<!-- Bootstrap Navbar -->
<nav class="navbar navbar-expand-lg fixed-top navbar-light bg-light">
  <div class="container-fluid">
    <a class="navbar-brand" href="#"></a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="<%= getServletContext().getContextPath() %>/App/dashboard"><%= username(request) %></a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">Link</a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Azioni
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="<%= getServletContext().getContextPath() %>/App/dashboard">Report</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item" href="<%= getServletContext().getContextPath() %>/App/logout">Esci</a></li>
          </ul>
        </li>
        <li class="nav-item">
          <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
        </li>
      </ul>
      <form class="d-flex">
        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
        <button class="btn btn-outline-success" type="submit">Search</button>
      </form>
    </div>
  </div>
</nav>

<!-- Toast -->

<!-- For Overlay -->
<div style="position: relative;">

<!-- Flexbox container for aligning the toasts: position-fixed class do the overlay -->
<div aria-live="polite" aria-atomic="true" class="d-flex justify-content-center align-items-center w-100 position-fixed">

<!-- Container for stacking the toasts (if you show more than one) -->
<div class="toast-container">

<div class="toast" data-bs-delay="20000" data-autohide="false" role="alert" aria-live="assertive" aria-atomic="true">
  <div class="toast-header">
    <!-- img src="..." class="rounded me-2" alt="..." -->
    <svg class="bd-placeholder-img rounded me-2" width="20" height="20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" preserveAspectRatio="xMidYMid slice" focusable="false"><rect width="100%" height="100%" fill="#007aff"></rect></svg>
    <strong class="me-auto">Bootstrap</strong>
    <small>popup</small>
    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
  </div>
  <div class="toast-body">
    ${message}
  </div>
</div>

</div>
</div>
</div>


<!-- Bootstrap Form -->
<div class="container-fluid">

<div class="row d-flex justify-content-center">
  <div class="mb-3 col-6">
	<h2>Inserisci i dati di accesso allo sportello</h2>
  </div>
  <div class="mb-3 col-3">
  </div>
</div>

<form method="post" id="insertForm" action="<%= context+"/" %>App/insert">

<div class="row d-flex justify-content-center">

  <div class="form-group date mb-3 col-3" data-provide="datepicker"	data-date-language="it" data-date-format="dd/mm/yyyy">
    <label for="date" class="form-label">Data</label>
	<input type="text" id="date" name="date" class="form-control" required placeholder="dd/mm/yyyy" readonly="readonly" >
	<div class="input-group-addon">
		<span class="glyphicon glyphicon-th"></span>
	</div>
  </div> 
  <div class="mb-3 col-3">
    <label for="giudice" class="form-label">Giudice Tutelare</label>
    
    <div class="input-group mb-3">
  		<select class="custom-select" name="giudice" id="giudice" required>
    		<option selected></option>
    		<option value="Giudice Tizio">Giudice Tizio</option>
    		<option value="Giudice Caio">Giudice Caio</option>
    		<option value="Giudice Sempronio">Giudice Sempronio</option>
    		<option value="Giudice Sesterzio">Giudice Sesterzio</option>
  		</select>
  		<div class="input-group-append">
    		<label class="input-group-text" for="giudice">Giudice</label>
  		</div>
	</div>
    
    
  </div>
  <div class="mb-3 col-3">
    <label for="notagiudice" class="form-label">Note assegnazione Giudice Tutelare</label>
    <textarea class="form-control" name="notagiudice" id="notagiudice" rows="2"></textarea>
  </div>

</div> 
  
<div class="row d-flex justify-content-center">

  <div class="mb-3 col-3">
    <label for="benef" class="form-label">Beneficiario</label>
    <input type="text" class="form-control" name="benef" id="benef" required>
  </div>
  <div class="mb-3 col-3">
    <label for="ads" class="form-label">Amministratore</label>
    <input type="text" class="form-control" name="ads" id="ads" required>
  </div>
  
  <div class="mb-3 col-3">
    <label for="motivo" class="form-label">Qualifica amministratore</label>
    
    <div class="input-group mb-3">
  		<select class="custom-select" name="tipoads" id="tipoads" required>
    		<option selected></option>
    		<option value="parente">parente</option>
    		<option value="amico">amico</option>
    		<option value="volontario">volontario</option>
    		<option value="involontario">involontario</option>
  		</select>
  		<div class="input-group-append">
    		<label class="input-group-text" for="tipoads">Qualifica</label>
  		</div>
	</div>    
  </div>  
  
</div>  

<div class="row d-flex justify-content-center">

  <div class="mb-3 col-3">
    <label for="recapititel" class="form-label">Recapiti telefonici</label>
    <textarea class="form-control" name="recapititel" id="recapititel" rows="2" required></textarea>
  </div>
  

  <div class="mb-3 col-3">
    <label for="estremipratica" class="form-label">Estremi pratica</label>
    <textarea  class="form-control" name="estremipratica" id="estremipratica" rows="2"></textarea>
  </div>
  
  <div class="mb-3 col-3">
    <label for="motivo" class="form-label">Motivo accesso</label>
    
    <div class="input-group mb-3">
  		<select class="custom-select" name="motivo" id="motivo" required>
    		<option selected></option>
    		<option value="Ricorso">Ricorso</option>
    		<option value="Autorizzazione">Autorizzazione</option>
    		<option value="Eredità">Eredità</option>
    		<option value="Altro motivo">Altro motivo</option>
  		</select>
  		<div class="input-group-append">
    		<label class="input-group-text" for="motivo">Motivo</label>
  		</div>
	</div>    
  </div> 
  
</div>  

<div class="row d-flex justify-content-center">

  <div class="mb-3 col-3">
    <label for="opr" class="form-label">Operatore sportello</label>
    
    <div class="input-group mb-3">
  		<select class="custom-select" name="opr" id="opr" required>
    		<option selected></option>
    		<option value="Pippo">Pippo</option>
    		<option value="Pluto">Pluto</option>
    		<option value="Paperino">Paperino</option>
    		<option value="Topolino">Topolino</option>
    		<option value="Giangiacomo Arcibaldo Pravettoni">Giangiacomo Arcibaldo Pravettoni</option>
  		</select>
  		<div class="input-group-append">
    		<label class="input-group-text" for="opr">Operatore</label>
  		</div>
	</div>    
  </div>
  
  <div class="mb-3 col-3">
    <label for="note" class="form-label">Note</label>
    <textarea  class="form-control" name="note" id="note" rows="2"></textarea>
  </div>

  <div class="mb-3 col-3">
    <label for="email" class="form-label">Email</label>
    <input type="email" class="form-control" name="email" id="email" required>
  </div>
  
  
  
</div>  
<div class="row d-flex justify-content-center">
<div class="mb-3 col-9"></div>
</div>
<div class="row d-flex justify-content-center">
  <div class="mb-3 col-1">  
  <a class='btn btn-primary' href='dashboard' role='button'>Annulla</a>  
  </div>
  <div class="mb-3 col-1">
  <button type="submit" id="submitForm" class="btn btn-primary" >Salva</button>
  </div>
  <div class="mb-3 col-3"></div>  
  <div class="mb-3 col-4"></div>  
</div> 
  
  
</form>

</div>


</body>
</html>