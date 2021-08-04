<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.util.ArrayList"  
    import="luke.models.classes.UploadItem"   
    import="luke.date.converter.DateConverter"
    import="luke.models.classes.User"  
    import="luke.models.classes.AccessoSportello" 
    import="luke.ads.martino.AppConfig"  
%>

<%! private String commentModal = "//";
	private String context = null;
	private User getUser(HttpServletRequest request) {
		return (User) request.getSession().getAttribute("user");
	}
	private String username(HttpServletRequest request) {
		return getUser(request).getName();
	}
	/* restituisce le opzioni da inserire negli elementi select */
	private String printSelectOptions(ArrayList<String> list, String selected) {
		/*
		<option selected></option>
		<option value="Giudice Tizio">Giudice Tizio</option>
		<option value="Giudice Caio">Giudice Caio</option>
		<option value="Giudice Sempronio">Giudice Sempronio</option>
		<option value="Giudice Sesterzio">Giudice Sesterzio</option> */
		String ret = "";
		if(list == null)
			return "";  // la lista delle options non è stata passata correttamente alla pagina jsp
		// l'elemento "selectet" rappresenta il valore già memorizzato in quel campo
		// e deve comparire nella lista delle opzioni della select, anche se non è
		// presente nella tabella relativa
		if(selected != null && selected.length()>0) {
			if(!list.contains(selected))
				list.add(0, selected);  // se l'elemento non c'è, aggiungilo all'inizio della lista delle option
			else {  // se l'elemento c'è già, spostalo all'inizio della lista (sarà l'elemento selezionato)
				int i = list.indexOf(selected);  // prendi l'indice dell'elemento
				list.remove(i);
				list.add(0, selected);
			}
		}
		else
			list.add(0, "");  // se non c'è un elemento già memorizzato aggiungi la stringa vuota
		for(String opt : list) {
			if(list.indexOf(opt) == 0) // il primo elemento è quello selezionato
				ret += "<option selected>"+opt+"</option>";
			else
				ret += "<option>"+opt+"</option>";
		}
		return ret;
	}
	private String hideInsertStuff(boolean insertMode) {
		if(!insertMode)
			return "hidden";
		return "";
	}
	private String hideUpdateStuff(boolean insertMode) {
		if(insertMode)
			return "hidden";
		return "";
	}
	/* return the page title */
	private String pageTitle(boolean insertMode) {
		if(insertMode)
			return AppConfig.titleInserisciDatiAccesso;
		return AppConfig.titleModificaDatiAccesso;
	}
	
	/* return the action of the form */
	private String formAction(boolean insertMode) {
		if(insertMode)
			return "insert";
		return "update";
	}
%>
<% context = getServletContext().getContextPath(); 
   AccessoSportello record = new AccessoSportello();
   if(request.getAttribute("record") != null)
	   record = (AccessoSportello) request.getAttribute("record");
   /* Questa pagina JSP è utilizzata sia per l'inserimento che per la modifica dei record.
      A seconda della modalità (inserimento o modifica) vengono visualizzati elementi diversi.
   */
   boolean insertMode = false;
   if(request.getAttribute("insert") != null && ((String) request.getAttribute("insert")).length()>0)
	   insertMode = true;
   
%>

<!DOCTYPE html>
<html>
<head>
<!--link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BmbxuPwQa2lc/FVzBcNJ7UAyJxM6wuqIj61tLrc4wSX0szH/Ev+nYRRuWlolflfl" crossorigin="anonymous" -->
<link href='<%= context+"/" %>css/bootstrap/bootstrap.min.css' rel='stylesheet' type='text/css'>
<link href='<%= context+"/" %>css/mycss.css' rel='stylesheet' type='text/css'>
<!-- Bootstrap Datepicker Css -->
<link href='<%= context+"/" %>css/bootstrap-datepicker.min.css' rel='stylesheet' type='text/css'>

<meta charset="ISO-8859-1">
<title><%= AppConfig.titleHead %></title>
</head>
<body>
<!--script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script-->
<script src='<%= context+"/" %>js/bootstrap/bootstrap.bundle.min.js' type='text/javascript'></script>
<script src='<%= context+"/" %>js/jquery-3.6.0.min.js' type='text/javascript'></script>


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
 

 
var myModalDelete;  // modal with a form submit
var formDelete; // delete record

var myModal;
var myModalMessage;  // modal with a message
var myForm; 
var uploadForm; 


$(document).ready(function(){
	if($('.toast .toast-body').html().trim()!="")
		$('.toast').toast('show');  // show the toast 
		

	// prevent the insert form to submit if date fiels is empty 
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
		
	// prevent the form to submit if date fiels is empty 
	$(document).on("click", "#updateRecord", function () {
		
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
	
	// Show dialog to confirm delete record:
	myModalDelete = new bootstrap.Modal(document.getElementById('myModalDelete'), {
		backdrop: 'static',  // do not close modal if user click outside
		keyboard: false   // cannot even press esc from keyboard
	}) 
	formDelete = document.getElementById("delete-record-form");
	
	$(document).on("click", "#deleteRecord", function () {
		//alert("Elimina");
		myModalDelete.show();
	});
	
	$(document).on("click", "#delete-form-submit", function () {
		//alert("Elimina");
		formDelete.submit();
		myModalDelete.dismiss();
	});
	
	
	/* Other stuff */
	
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
          <a class="nav-link active" aria-current="page" href="<%= getServletContext().getContextPath() %>/App"><%= username(request) %></a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#"></a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="dashboard"><%= AppConfig.labelDashboard %></a>
        </li>        
        <li class="nav-item">
          <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true"></a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            <%= AppConfig.labelTables %>
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="table?table=giudici"><%= AppConfig.etichettaTabella("giudici") %></a></li>
            <li><a class="dropdown-item" href="table?table=volontari"><%= AppConfig.etichettaTabella("volontari") %></a></li>            
            <li><a class="dropdown-item" href="table?table=tipoads"><%= AppConfig.etichettaTabella("tipoads") %></a></li>
            <li><a class="dropdown-item" href="table?table=motiviaccesso"><%= AppConfig.etichettaTabella("motiviaccesso") %></a></li>
            <li><a class="dropdown-item" href="table?table=sedi"><%= AppConfig.etichettaTabella("sedi") %></a></li>
          </ul>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="files"><%= AppConfig.labelFiles %></a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#"></a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="logout"><%= AppConfig.labelLogout %></a>
        </li>
      </ul>
      <!--form class="d-flex">
        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
        <button class="btn btn-outline-success" type="submit">Search</button>
      </form-->
    </div>
  </div>
</nav>

<!-- Toast -->

<!-- For Overlay -->
<div style="position: relative;">

<!-- Flexbox container for aligning the toasts: position-fixed class do the overlay -->
<div aria-live="polite" aria-atomic="true" class="my-toast-flexbox-container d-flex justify-content-center align-items-center w-100">

<!-- Container for stacking the toasts (if you show more than one) -->
<div class="toast-container">

<div class="toast" data-bs-delay="<%= AppConfig.toastTime %>" data-autohide="false" role="alert" aria-live="assertive" aria-atomic="true">
  <div class="toast-header">
    <!-- img src="..." class="rounded me-2" alt="..." -->
    <svg class="bd-placeholder-img rounded me-2" width="20" height="20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" preserveAspectRatio="xMidYMid slice" focusable="false"><rect width="100%" height="100%" fill="#007aff"></rect></svg>
    <strong class="me-auto"><%= AppConfig.titleToast %></strong>
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
  <div class="mb-3 col-7">
	<h2><%= pageTitle(insertMode) %></h2>
  </div>
  <div class="mb-3 col-3">
  </div>
</div>


<form method="post" id="insertForm" action=<%= formAction(insertMode) %> >

<div class="row d-flex justify-content-center">
  <div class="mb-3 col-3">
    <label <%= hideUpdateStuff(insertMode) %> for="id" class="form-label">ID</label>
    <input <%= hideUpdateStuff(insertMode) %> type="text" class="form-control" name="id" id="id" required readonly="readonly" value="<%= record.getId() %>">
  </div>
  <div class="mb-3 col-2"></div>
   
  <div class="mb-3 col-5">
  	<div class="row d-flex justify-content-center">
  	<div class="mb-3 col-5">
  	<label class="form-label"></label>
  	</div>
  	</div>
  	
  	<div class="row d-flex justify-content-center">
  	<div class="mb-3 col-4">    		
  		<button <%= hideUpdateStuff(insertMode) %> type="submit" id="updateRecord" class="btn btn-primary">Aggiorna</button>
  	</div>
  	<div class="mb-3 col-4">  		
  		<button <%= hideUpdateStuff(insertMode) %> type="button" id="deleteRecord" class="btn btn-primary">Elimina</button>
  	</div>  
  	<div class="mb-3 col-4">  		
  		<a <%= hideUpdateStuff(insertMode) %> class='btn btn-primary' href='dashboard' role='button'>Indietro</a>
  	</div> 
  	</div>
 
 </div> 
</div>

<div class="row d-flex justify-content-center">

  <div class="form-group date mb-3 col-3" data-provide="datepicker"	data-date-language="it" data-date-format="dd/mm/yyyy">
    <label for="date" class="form-label">Data</label>
	<input type="text" id="date" name="date" class="form-control" required placeholder="dd/mm/yyyy" readonly="readonly" value="<%= DateConverter.Sql2String(record.getData()) %>">
	<div class="input-group-addon">
		<span class="glyphicon glyphicon-th"></span>
	</div>
  </div>
  <div class="mb-3 col-2"></div>
  <div class="mb-3 col-5">
    <label for="sportello" class="form-label">Sede Sportello</label>
    <select class="form-select" name="sede" id="sede" required >
    		<%= printSelectOptions((ArrayList<String>)request.getAttribute("sedi"), record.getSede()) %>
  	</select>
  	</div>
</div>

<div class="row d-flex justify-content-center">
  <div class="mb-3 col-5">
    <label for="giudice" class="form-label">Giudice Tutelare</label>    
    
  		<select class="form-select" name="giudice" id="giudice" required >
    		<%= printSelectOptions((ArrayList<String>)request.getAttribute("giudici"), record.getGiudice()) %>
  		</select>
  		
    
    
  </div>
  <div class="mb-3 col-5">
    <label for="notagiudice" class="form-label">Note assegnazione Giudice Tutelare</label>
    <textarea class="form-control" name="notagiudice" id="notagiudice" rows="2" ><%= record.getNotagiudice() %></textarea>
  </div>

</div> 
  
<div class="row d-flex justify-content-center">

  <div class="mb-3 col-5">
    <label for="benef" class="form-label">Beneficiario</label>
    <input type="text" class="form-control" name="benef" id="benef" required value="<%= record.getBeneficiario() %>">
  </div>
  <div class="mb-3 col-5"></div>
</div> 
 
<div class="row d-flex justify-content-center">
  <div class="mb-3 col-5">
    <label for="ads" class="form-label">Amministratore</label>
    <input type="text" class="form-control" name="ads" id="ads" required value="<%= record.getAds() %>">
  </div>
  
  <div class="mb-3 col-5">
    <label for="motivo" class="form-label">Qualifica amministratore</label>    
    
  		<select class="form-select" name="tipoads" id="tipoads" required >
    		<%= printSelectOptions((ArrayList<String>)request.getAttribute("tipoads"), record.getTipoads()) %>
  		
  		</select>
  		   
  </div>  
  
</div>  

<div class="row d-flex justify-content-center">

  <div class="mb-3 col-5">
    <label for="recapititel" class="form-label">Recapiti telefonici</label>
    <textarea class="form-control" name="recapititel" id="recapititel" rows="2" required><%= record.getRecapitotel() %></textarea>
  </div>
  <div class="mb-3 col-5"></div>
</div>

<div class="row d-flex justify-content-center">  

  <div class="mb-3 col-5">
    <label for="estremipratica" class="form-label">Estremi pratica</label>
    <textarea  class="form-control" name="estremipratica" id="estremipratica" rows="2"><%= record.getEstremipratica() %></textarea>
  </div>
  
  <div class="mb-3 col-5">
    <label for="motivo" class="form-label">Motivo accesso</label>    
    
  		<select class="form-select" name="motivo" id="motivo" required >
    		<%= printSelectOptions((ArrayList<String>)request.getAttribute("motivi"), record.getMotivoaccesso()) %>
  		
  		</select>  		    
  </div> 
  
</div>  

<div class="row d-flex justify-content-center">

  <div class="mb-3 col-5">
    <label for="opr" class="form-label">Operatore sportello</label>    
    
  		<select class="form-select" name="opr" id="opr" required ">
    		<%= printSelectOptions((ArrayList<String>)request.getAttribute("volontari"), record.getOperatore()) %>
  		</select>
  		    
  </div>
  
  <div class="mb-3 col-5">
    <label for="note" class="form-label">Note</label>
    <textarea  class="form-control" name="note" id="note" rows="2" ><%= record.getNote() %></textarea>
  </div>
</div>
<div class="row d-flex justify-content-center">
  <div class="mb-3 col-5">
    <label for="email" class="form-label">Email</label>
    <input type="email" class="form-control" name="email" id="email" required value="<%= record.getEmail() %>">
  </div>
  <div class="mb-3 col-5"></div>  
</div>  
<div class="row d-flex justify-content-center">
<div class="mb-3 col-9"></div>
</div>

<div class="row d-flex justify-content-center">
<div class="mb-3 col-9"></div>
</div>
<div class="row d-flex justify-content-center">
  <div class="mb-3 col-1">  
  <a <%= hideInsertStuff(insertMode) %> class='btn btn-primary' href='dashboard' role='button'>Annulla</a>  
  </div>
  <div class="mb-3 col-1">
  <button <%= hideInsertStuff(insertMode) %> type="submit" id="submitForm" class="btn btn-primary" >Salva</button>
  </div>
  <div class="mb-3 col-3"></div>  
  <div class="mb-3 col-4"></div>  
</div>

</form>

</div>


<!-- Modal with form: confirm to delete record -->
<div id="myModalDelete" class="modal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false" >
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Conferma</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p id="modal-message">Sei sicuro di voler eliminare in modo definitivo queste informazioni dal database?</p>
        <form id="delete-record-form" method="post" action="delete">
          <input hidden type="text" name="id" id="id" value="<%= record.getId() %>"/>
          <!--button id="your-id">submit</button-->
		</form>  
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annulla</button>
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal" id="delete-form-submit" >Elimina</button>
      </div>
    </div>
  </div>
</div>


</body>
</html>